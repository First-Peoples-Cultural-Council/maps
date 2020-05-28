<template>
  <div
    id="badge-filter-container"
    :class="`badge-filter-container ${isSelected ? 'badge-selected' : ''}`"
    :style="`${isSelected ? `border: 2px solid ${color}` : ''}`"
  >
    <slot name="badge"></slot>
    <div
      v-if="isSelected || (isSelected && getTaxonomies.length !== 0)"
      class="badge-filters "
    >
      <p id="badge-choose" @click="showOption = !showOption">
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
        v-if="showOption"
        id="filter-popover"
        class="hide-mobile"
        target="badge-choose"
        placement="bottom"
        triggers="click"
        :show="showOption"
      >
        <div class="badge-option-container">
          <span
            v-for="taxonomy in childTaxonomy"
            :id="`badge-child-option-${taxonomy.id}`"
            :key="taxonomy.id"
            class="badge-option-child"
            @click="optionSelected([taxonomy.name])"
          >
            {{ taxonomy.name }}
            <!-- <span v-if="hasTaxonomyChild(taxonomy.id)">></span> -->

            <!-- Child Popover -->
            <b-popover
              v-if="hasTaxonomyChild(taxonomy.id)"
              :id="`child-popover-${taxonomy.name}`"
              :target="`badge-child-option-${taxonomy.id}`"
              placement="right"
              triggers="hover focus"
            >
              <div class="badge-option-container">
                <span
                  v-for="taxChild in getChildTaxonomyList(taxonomy.id)"
                  :id="`badge-child-option-${taxChild.id}`"
                  :key="taxChild.id"
                  @click="optionSelected([taxonomy.name, taxChild.name])"
                  >{{ taxChild.name }}

                  <!-- Child Child Popover -->
                  <!-- <b-popover
                    v-if="hasTaxonomyChild(taxChild.id)"
                    :id="`child1-popover-${taxChild.name}`"
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
                  </b-popover> -->
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
    color: {
      type: String,
      default: ''
    },
    childTaxonomy: {
      type: Array,
      default: () => {
        return []
      }
    }
  },
  data() {
    return {
      isHover: false,
      showOption: false,
      showChild: false,
      currentParent: ''
    }
  },
  computed: {
    getTaxonomies() {
      return this.$store.state.arts.taxonomyFilter
    },
    taxonomies() {
      return this.$store.state.arts.taxonomySearchSet
    }
  },
  mounted() {
    console.log('child', this.childTaxonomy)
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
      // this.showOption = false
    },
    getTags() {
      return this.getTaxonomies.reduce((result, item, index) => {
        return (result += `${item} ${
          index !== 0 || index !== this.getTaxonomies.length - 1 ? ' / ' : ''
        } `)
      }, '')
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
  margin: 0.25em 0.125em !important;
  height: fit-content;

  .badge {
    margin: 0;
  }
}

@media (max-width: 993px) {
  .badge-filter-container {
    margin: 0.25em 0.5em;
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
    display: flex;
    flex-direction: column;
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
  overflow: hidden;
}

.remove-tag-btn {
  margin: 0 0.25em;
}

.popover {
  width: 80%;
}

.popover-body {
  padding: 0;
  margin: 0;
}
</style>
