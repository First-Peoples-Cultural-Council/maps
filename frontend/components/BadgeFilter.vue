<template>
  <div
    id="badge-filter-container"
    class="badge-filter-container"
    @mouseover.prevent="isHover = true"
    @mouseleave="isHover = false"
  >
    <slot name="badge"></slot>
    <div v-if="(isSelected && isHover) || showOption" class="badge-filters">
      <p id="badge-choose">choose sub-category</p>
      <b-popover
        target="badge-choose"
        placement="bottom"
        triggers="click"
        :show.sync="showOption"
      >
        <div class="badge-option-container">
          <span>Director</span>
          <span id="badge-child-option"
            >Artist
            <b-popover
              target="badge-child-option"
              placement="right"
              triggers="hover"
              :show.sync="showChild"
              class="child-option-container"
            >
              <div class="badge-option-container">
                <span>Artist</span>
                <span>Director</span>
              </div>
            </b-popover>
          </span>
        </div>
      </b-popover>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    isSelected: {
      type: Boolean,
      default: false
    },
    filter: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      isHover: false,
      showOption: false,
      showChild: false
    }
  },
  methods: {
    toggleOption() {
      this.showOption = !this.showOption
    },
    selectOption(value) {
      this.$store.commit('arts/setFilterTag', value)
    }
  }
}
</script>

<style lang="scss">
.badge-filter-container {
  display: flex;
  position: relative;
  align-items: center;
  width: fit-content;
  border: 2px solid #5a8467;
  border-radius: 1em;
  background-color: #ededed;
  margin: 0.5em 0;
  height: fit-content;
}

.badge-filters {
  font-size: 12px;
  margin: 0 0.5em;
}

.badge-filters > p {
  margin: 0;
  font-weight: 500;
}

.badge-option-container {
  display: flex;
  flex-direction: column;

  span {
    color: #707070;
    padding: 0.5em 1em;
    cursor: pointer;

    &:hover {
      color: #fff;
      background: #b47839;
    }
  }
}

.popover {
  width: 80%;
}

.popover-body {
  padding: 0;
  margin: 0;
}

.child-option-container {
  border: 1px solid red;
}
</style>
