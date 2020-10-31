<template>
  <div
    class="grants-card"
    :class="{ 'is-grant-selected': isSelected }"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
    @click="handleCardClick($event, grant)"
  >
    <div>
      <h5 class="grant-title">
        {{ grant.properties.recipient }} - {{ grant.properties.grant }}
      </h5>
      <div class="grant-tag-container">
        <span class="grant-tag" :style="'background-color:' + grantColor">
          {{
            grant.properties.category
              ? grant.properties.category
              : 'No Category'
          }}
        </span>
        <span class="grant-tag-date">
          {{ grant.properties.year ? grant.properties.year : 'No Year' }}
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
    },
    parentTagObject: {
      default: () => {
        return {
          color: '#99281C'
        }
      },
      type: Object
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
    },
    grantColor() {
      if (this.grant && this.grant.properties.category_abbreviation) {
        if (this.grant.properties.category_abbreviation.startsWith('L')) {
          return '#b47a2b'
        } else if (
          this.grant.properties.category_abbreviation.startsWith('A')
        ) {
          return '#2c8190'
        } else if (
          this.grant.properties.category_abbreviation.startsWith('H')
        ) {
          return '#6d4264'
        }
      }
      return '#99281c'
    },
    currentGrant() {
      return this.$store.state.grants.currentGrant
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
    },
    handleCardClick(e, grant) {
      if (this.currentGrant && this.currentGrant.id === grant.id) {
        this.$store.commit('grants/setCurrentGrant', null)
        this.$root.$emit('resetMap')
      } else {
        this.$root.$emit('showGrantModal', grant)
      }
      this.$root.$emit('closeSideBarSlider')
    }
  }
}
</script>

<style lang="scss">
.grants-card {
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  height: 100%;
  border: 1px solid #ebe6dc;
  padding: 12px 0em 12px 12px;
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
  margin: 1em 0 0 0;

  & > span {
    margin-right: 1em;
    border-radius: 20px;
    padding: 5px 10px;
    font-size: 0.8em;
    font-weight: 800;
  }

  .grant-tag {
    background-color: #7d6799;
    color: #fff;
    margin-bottom: 5px;
  }

  .grant-tag-date {
    background-color: #ddd4c6;
    color: #000;
    margin-bottom: 5px;
  }
}
</style>
