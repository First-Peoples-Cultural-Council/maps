<template>
  <div
    id="badge-filter-container"
    :class="`badge-filter-container ${isSelected ? 'badge-selected' : ''}`"
    :style="`${isSelected ? `border: 2px solid ${color}` : ''}`"
    @mouseover.prevent="isHover = true"
    @mouseleave="isHover = false"
  >
    <slot name="badge"></slot>
    <div
      v-if="
        (isSelected && isHover) ||
          showOption ||
          (isSelected && getTaxonomies.length !== 0)
      "
      class="badge-filters hide-mobile"
    >
      <p id="badge-choose">
        {{
          `${getTaxonomies.length !== 0 ? getTags() : 'choose sub-category'} `
        }}
        <span
          v-if="getTaxonomies.length !== 0"
          class="remove-tag-btn cursor-pointer"
          @click="removeTag()"
          >&#x2716;</span
        >
      </p>
      <!-- Parent Popover -->
      <b-popover
        target="badge-choose"
        placement="bottom"
        triggers="click"
        :show.sync="showOption"
      >
        <div class="badge-option-container">
          <span
            v-for="taxonomy in getChildTaxonomy"
            :id="`badge-child-option-${taxonomy.id}`"
            :key="taxonomy.id"
            @click="optionSelected([taxonomy.name])"
          >
            {{ taxonomy.name }}
            <!-- Child Popover -->
            <b-popover
              v-if="hasTaxonomyChild(taxonomy.id)"
              :target="`badge-child-option-${taxonomy.id}`"
              placement="right"
              triggers="hover"
            >
              <div class="badge-option-container">
                <span
                  v-for="taxChild in getChildTaxonomyList(taxonomy.id)"
                  :id="`badge-child-option-${taxChild.id}`"
                  :key="taxChild.id"
                  @click="optionSelected([taxonomy.name, taxChild.name])"
                  >{{ taxChild.name }}
                  <!-- Child Child Popover -->
                  <b-popover
                    v-if="hasTaxonomyChild(taxChild.id)"
                    :target="`badge-child-option-${taxChild.id}`"
                    placement="right"
                    triggers="hover"
                  >
                    <div class="badge-option-container">
                      <span
                        v-for="taxChild1 in getChildTaxonomyList(taxChild.id)"
                        :id="`badge-child-option-${taxChild1.id}`"
                        :key="taxChild1.id"
                        @click="
                          optionSelected([
                            taxonomy.name,
                            taxChild.name,
                            taxChild1.name
                          ])
                        "
                        >{{ taxChild1.name }}</span
                      >
                    </div>
                  </b-popover>
                </span>
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
      type: Object,
      default: () => {
        return {}
      }
    },
    color: {
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
  computed: {
    getTaxonomies() {
      return this.$store.state.arts.taxonomyFilter
    },
    taxonomies() {
      return this.$store.state.arts.taxonomySearchSet
    },
    getChildTaxonomy() {
      return this.taxonomies.filter(
        taxonomy => taxonomy.parent === this.filter.id
      )
    }
  },
  methods: {
    toggleOption() {
      this.showOption = !this.showOption
    },
    hasTaxonomyChild(taxId) {
      return this.taxonomies.some(taxonomy => taxonomy.parent === taxId)
    },
    getChildTaxonomyList(id) {
      return this.taxonomies.filter(taxonomy => taxonomy.parent === id)
    },
    optionSelected(taxList) {
      this.$store.commit('arts/setTaxonomyTag', taxList)
      this.showOption = false
    },
    getTags() {
      return this.getTaxonomies.map(
        (tag, index) =>
          `${tag} ${
            index !== 0 || index !== this.getTaxonomies.length - 1 ? ' / ' : ''
          }`
      )
    },
    removeTag() {
      this.$store.commit('arts/setTaxonomyTag', [])
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
  border-radius: 1em;
  background-color: #ededed;
  margin: 0.25em 0.125em;
  height: fit-content;

  .badge {
    margin: 0;
  }
}

.badge-selected {
  width: fit-content;
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

#badge-choose {
  font: Bold 15px/18px Lato;
  text-transform: lowercase;
  color: #151515;
}

.remove-tag-btn {
  margin: 0.25em;
}

.popover {
  width: 80%;
}

.popover-body {
  padding: 0;
  margin: 0;
}
</style>
