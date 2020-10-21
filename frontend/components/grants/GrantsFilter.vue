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
    <b-collapse id="filters" v-model="showCollapse" class="mt-2">
      <span class="field-kinds mt-3">FILTER GRANTS BY YEAR</span>
      <div class="date-main-container">
        <div class="date-container">
          <span>From</span>
          <b-form-input
            v-model.number="fromValue"
            class="date-input"
            maxlength="4"
            @blur="handleFromUpdate"
            @keypress="isNumber($event)"
          ></b-form-input>
        </div>

        <div class="date-container">
          <span>To</span>
          <b-form-input
            v-model.number="toValue"
            class="date-input"
            maxlength="4"
            @blur="handleToUpdate"
            @keypress="isNumber($event)"
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
      />

      <div class="badges-container">
        <slot name="badge-filter"></slot>
      </div>
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
    },
    maxDate: {
      type: Number,
      default: 0
    },
    minDate: {
      type: Number,
      default: 0
    }
  },
  data() {
    return {
      showCollapse: true,
      fromValue: 0,
      toValue: 0
    }
  },
  computed: {
    getMaximumDate() {
      // return maximum date list
      return new Date(this.maxDate, 1, 1).valueOf()
    },

    getMinimumDate() {
      // return minimum date from list
      return new Date(this.minDate, 1, 1).valueOf()
    }
  },
  mounted() {
    window.addEventListener('resize', this.screenChecker)

    if (window.innerWidth < 1080) {
      this.showCollapse = false
    }
    this.fromValue = this.prettify(this.getMinimumDate)
    this.toValue = this.prettify(this.getMaximumDate)
    this.setStoreDateValues()
  },
  destroyed() {
    window.removeEventListener('resize', this.screenChecker)
  },
  methods: {
    isNumber(evt) {
      evt = evt || window.event
      const charCode = evt.which ? evt.which : evt.keyCode
      if (
        charCode > 31 &&
        (charCode < 48 || charCode > 57) &&
        charCode === 46
      ) {
        evt.preventDefault()
      } else {
        return true
      }
    },
    screenChecker(e) {
      if (e.srcElement.innerWidth > 1080) {
        this.showCollapse = true
      }
    },
    changeDateValue(value) {
      this.toValue = value.to_pretty
      this.fromValue = value.from_pretty
      this.setStoreDateValues()
    },
    prettify(ts) {
      // return only year of the date
      return new Date(ts).toLocaleDateString('en', {
        year: 'numeric'
      })
    },
    handleFilterGrants(value) {
      this.setStoreDateValues()
    },
    handleFromUpdate() {
      const minimumDate = this.prettify(this.getMinimumDate)
      const maxDate = this.prettify(this.getMaximumDate)
      if (this.fromValue < minimumDate || this.fromValue > maxDate) {
        this.fromValue = minimumDate
      }

      // Set To Date value to Maximum Date if null or lessr than from value
      if (this.toValue === 0 || this.toValue <= this.fromValue) {
        this.toValue = maxDate
      }

      this.setStoreDateValues()
    },
    handleToUpdate() {
      const minimumDate = this.prettify(this.getMinimumDate)
      const maxDate = this.prettify(this.getMaximumDate)

      if (this.toValue > maxDate || this.toValue < minimumDate) {
        this.toValue = maxDate
      }

      // Set To Date value to minimum Date if null or greater than to value
      if (this.fromValue === 0 || this.fromValue >= this.toValue) {
        this.fromValue = minimumDate
      }

      this.setStoreDateValues()
    },
    setStoreDateValues() {
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

.badges-container {
  margin: 1em 0;
}
</style>
