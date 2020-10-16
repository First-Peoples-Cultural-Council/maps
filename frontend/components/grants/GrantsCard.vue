<template>
  <div
    class="grants-card"
    :class="{ 'is-grant-selected': isSelected }"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <div>
      <h5 class="grant-title">
        {{ grant.properties.recipient }} - {{ grant.properties.grant }}
      </h5>
      <div class="grant-tag-container">
        <span class="grant-tag">
          {{ grant.properties.category }}
        </span>
        <span class="grant-tag-date">
          {{ grant.properties.year }}
        </span>
      </div>
    </div>

    <div class="grant-card-more">
      <img v-if="!hover" src="@/assets/images/go_icon_hover.svg" alt="Go" />
      <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
    </div>
  </div>
</template>

<script>
export default {
  components: {},
  props: {
    grant: {
      type: Object,
      default: () => {
        return {}
      }
    },
    isSelected: {
      default: false,
      type: Boolean
    }
  },
  data() {
    return {
      hover: false
    }
  },
  computed: {
    getGrantsDateFilter() {
      return this.$store.state.grants.filterDate
    }
  },
  methods: {
    grantCardClass(year) {
      const filter = this.getGrantsDateFilter
      return filter
        ? year <= filter.toDate && year >= filter.fromDate
          ? 'year-selected'
          : ''
        : ''
    },
    handleMouseOver() {
      if (this.grant.geometry) {
        this.hover = true
        // in some cases, we list places without full geometry, no marker shown.
        if (!this.grant.geometry) return
        this.$eventHub.revealArea(this.grant.geometry)
      }
    },
    handleMouseLeave() {
      if (this.grant.geometry) {
        this.hover = false
        // in some cases, we list places without full geometry, no marker shown.
        if (!this.grant.geometry) return
        this.$eventHub.doneReveal()
      }
    }
  }
}
</script>

<style lang="scss">
.grants-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  height: 100%;
  border: 1px solid #ebe6dc;
  padding: 0.5em 0em 0.5em 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);

  .grant-title {
    font: Bold 16px/18px Proxima Nova;
    color: #707070;
    margin: 0.1em;
    padding: 0;
  }

  &:hover {
    border: 1px solid #b57936;

    .grant-card-more {
      background-color: #00333a;
    }
  }
}

.is-grant-selected {
  border: 1px solid #b57936;
  transform: translateX(5px);

  .grant-card-more {
    background-color: #00333a;
  }
}

.year-selected {
  color: #fff !important;
  background-color: #545b62 !important;

  &:hover {
    background: #ddd4c6 !important;
    color: #707070 !important;
  }
}

.grant-tag-container {
  display: flex;
  flex-wrap: wrap;
  margin: 1em 0;

  & > span {
    margin-right: 1em;
    margin-bottom: 1em;
    border-radius: 20px;
    padding: 5px 10px;
    font-size: 0.8em;
    font-weight: 800;
  }

  .grant-tag {
    background-color: #7d6799;
    color: #fff;
  }

  .grant-tag-date {
    background-color: #ddd4c6;
    color: #000;
  }
}
</style>
