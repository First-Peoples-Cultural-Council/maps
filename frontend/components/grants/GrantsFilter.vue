<template>
  <div class="filters-container pl-3 pr-3">
    <div class="cursor-pointer ml-1" @click="showCollapse = !showCollapse">
      <div>
        <img src="@/assets/images/filter_icon.svg" alt="Filter" />
        <span class="d-inline-block font-08">Filters and Layers</span>
        <div class="float-right" style="line-height: 20px;">
          <img
            v-if="!showCollapse"
            src="@/assets/images/arrow_down_icon.svg"
            alt="Open"
          />
          <img v-else src="@/assets/images/arrow_up_icon.svg" alt="Close" />
        </div>
      </div>
    </div>
    <b-collapse id="filters" v-model="showCollapse" class="mt-2 pl-2 pr-2">
      <span class="field-kinds mt-3">AWARD YEAR RANGE</span>
      <div class="date-main-container">
        <div class="date-container">
          <span>From</span>
          <b-form-input
            v-model="fromValue"
            class="date-input"
            maxlength="4"
          ></b-form-input>
        </div>

        <div class="date-container">
          <span>To</span>
          <b-form-input
            v-model="toValue"
            class="date-input"
            maxlength="4"
          ></b-form-input>
        </div>
      </div>
      <HistogramSlider
        :width="350"
        :data="dateList"
        :prettify="prettify"
        :keyboard="true"
        :min="getMinimumDate"
        :max="getMaximumDate"
        handle-color="#B47A2B"
        :hide-from-to="true"
        @change="changeDateValue"
        @finish="handleFilterGrants"
      />
    </b-collapse>
  </div>
</template>

<script>
export default {
  components: {},
  props: {
    dateList: {
      type: Array,
      default: () => {
        return []
      }
    }
  },
  data() {
    return {
      showCollapse: false,
      fromValue: 0,
      toValue: 0
    }
  },
  computed: {
    layers() {
      return this.$store.state.layers.layers
    },
    getMaximumDate() {
      // return maximum date list
      return new Date(2020, 11, 24).valueOf()
    },

    getMinimumDate() {
      // return minimum date from list
      return new Date(2000, 11, 24).valueOf()
    }
  },
  methods: {
    changeDateValue(value) {
      this.toValue = value.to_pretty
      this.fromValue = value.from_pretty
    },
    prettify(ts) {
      return new Date(ts).toLocaleDateString('en', {
        year: 'numeric'
      })
    },
    handleFilterGrants(value) {
      console.log(value)
      const dateValue = { fromDate: this.fromValue, toDate: this.toValue }
      this.$store.commit('grants/setGrantFilterDate', dateValue)
    }
  }
}
</script>

<style lang="scss">
.filters-container {
  padding: 0.25em 0 0.75em 0;
  box-shadow: 0px 4px 4px rgba(0, 0, 0, 0.1);
  color: #737373;
}

.date-main-container {
  display: flex;
  border-radius: 17px;
  background: #eeeeee;
  justify-content: space-between;
  padding: 5px;
  margin: 0.5em 0.5em;
  transform: translateY(20px);
}
.date-container {
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0 0.25em;

  span {
    color: #737373;
    font-weight: 800;
    margin-right: 0.5em;
  }
  .date-input {
    width: 70px;
    height: 30px;
    background: #ffffff;
    border-radius: 17px;
    text-align: center;
  }
}
</style>
