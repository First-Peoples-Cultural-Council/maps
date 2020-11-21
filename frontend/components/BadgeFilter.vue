<template>
  <div
    id="badge-filter-container"
    :class="`badge-filter-container ${isSelected ? 'badge-selected' : ''}`"
    :style="
      `${
        isSelected
          ? `border: 2px solid ${color}; animation: shadowpulse 2.5s infinite`
          : ''
      }`
    "
  >
    <slot name="badge"></slot>
    <div v-if="isSelected && childTaxonomy.length !== 0" class="badge-filters ">
      <p id="badge-choose" @click="toggleFilterOption">
        {{ showFilterOption ? 'Click here to Close' : getFilterText() }}

        <span
          v-if="getSelectedFilterList.length !== 0"
          class="remove-tag-btn cursor-pointer"
          @click="removeTag()"
          >&#x2716;</span
        >
      </p>
      <!-- Parent Popover -->
      <b-popover
        v-if="showFilterOption"
        id="filter-popover"
        target="badge-choose"
        placement="bottom"
        triggers="click "
        :show="showFilterOption"
      >
        <div
          :class="
            `badge-option-container ${
              childTaxonomy.length > 8 ? 'option-split' : 'option-column'
            }`
          "
        >
          <span
            v-for="taxonomy in childTaxonomy"
            :id="`badge-child-option-${taxonomy.id}`"
            :key="taxonomy.id"
            class="badge-option-child"
          >
            <div
              class="badge-option-inner"
              @click="toggleTaxonomyTag(taxonomy)"
            >
              <b-form-checkbox
                v-model="taxonomy.isChecked"
                class="ml-2 disabled-element"
              >
              </b-form-checkbox>
              {{
                filterType === 'grants'
                  ? `${taxonomy.abbreviation} - ${taxonomy.name}`
                  : taxonomy.name
              }}

              <img
                v-if="hasTaxonomyChild(taxonomy.id) && filterType === 'arts'"
                src="@/assets/images/right.svg"
              />
            </div>

            <!-- Child Popover -->
            <b-popover
              v-if="hasTaxonomyChild(taxonomy.id) && filterType === 'arts'"
              :id="`child-popover-${taxonomy.name}`"
              :target="`badge-child-option-${taxonomy.id}`"
              placement="right"
              triggers="click"
            >
              <div
                :class="
                  `badge-option-container ${
                    getChildTaxonomyList(taxonomy.id).length > 8
                      ? 'option-split'
                      : 'option-column'
                  }`
                "
              >
                <span
                  v-for="taxChild in getChildTaxonomyList(taxonomy.id)"
                  :id="`badge-child-option-${taxChild.id}`"
                  :key="taxChild.id"
                >
                  <div
                    class="badge-option-inner"
                    @click="toggleTaxonomyTag(taxChild)"
                  >
                    <b-form-checkbox
                      v-model="taxChild.isChecked"
                      class="ml-2 disabled-element"
                    >
                    </b-form-checkbox>
                    {{ taxChild.name }}

                    <img
                      v-if="hasTaxonomyChild(taxChild.id)"
                      src="@/assets/images/right.svg"
                    />
                  </div>

                  <!-- Child Child Popover -->
                  <b-popover
                    v-if="hasTaxonomyChild(taxChild.id)"
                    :id="`child1-popover-${taxChild.name}`"
                    :target="`badge-child-option-${taxChild.id}`"
                    placement="right"
                    triggers="click"
                  >
                    <div
                      :class="
                        `badge-option-container ${
                          getChildTaxonomyList(taxChild.id).length > 8
                            ? 'option-split'
                            : 'option-column'
                        }`
                      "
                    >
                      <span
                        v-for="taxChild1 in getChildTaxonomyList(taxChild.id)"
                        :id="`badge-child-option-${taxChild1.id}`"
                        :key="taxChild1.id"
                      >
                        <div
                          class="badge-option-inner"
                          @click="toggleTaxonomyTag(taxChild1)"
                        >
                          <b-form-checkbox
                            v-model="taxChild1.isChecked"
                            class="ml-2 disabled-element"
                          >
                          </b-form-checkbox>
                          {{ taxChild1.name }}

                          <img
                            v-if="hasTaxonomyChild(taxChild1.id)"
                            src="@/assets/images/right.svg"
                          />
                        </div>
                      </span>
                    </div>
                  </b-popover>
                </span>
              </div>
            </b-popover>
          </span>
        </div>
      </b-popover>
      <!-- For Mobile Mode -->
      <b-modal
        id="badge-filter-modal"
        ref="badge-filter-modal"
        v-model="showFilterOption"
        size="xl"
        title="Select Taxonomy Filters"
        @ok="handleFilter"
      >
        <div class="modal-filter-container">
          <div
            v-for="taxonomy in childTaxonomy"
            :key="`item-${taxonomy.name}`"
            class="badge-modal-container"
          >
            <b-form-checkbox
              v-model="taxonomy.isChecked"
              class="d-inline-block ml-2 checkbox-parent"
              @change="toggleTaxonomyTag(taxonomy)"
            >
              {{
                filterType === 'grants'
                  ? `${taxonomy.abbreviation} - ${taxonomy.name}`
                  : taxonomy.name
              }}
            </b-form-checkbox>

            <div
              v-if="hasTaxonomyChild(taxonomy.id) && filterType === 'arts'"
              class="badge-modal-child-container"
            >
              <b-form-checkbox
                v-for="taxChild in getChildTaxonomyList(taxonomy.id)"
                :key="`checkbox-${taxChild.name}`"
                v-model="taxChild.isChecked"
                class="d-inline-block ml-2"
                @change="toggleTaxonomyTag(taxChild)"
              >
                {{ taxChild.name }}

                <div
                  v-if="hasTaxonomyChild(taxChild.id)"
                  class="badge-modal-child1-container"
                >
                  <b-form-checkbox
                    v-for="taxChild1 in getChildTaxonomyList(taxChild.id)"
                    :key="`checkbox-${taxChild1.name}`"
                    v-model="taxChild1.isChecked"
                    class="d-inline-block ml-2"
                    @change="toggleTaxonomyTag(taxChild1)"
                  >
                    {{ taxChild1.name }}
                  </b-form-checkbox>
                </div>
              </b-form-checkbox>
            </div>
          </div>
        </div>
      </b-modal>
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
    },
    type: {
      type: String,
      default: ''
    },
    filterType: {
      type: String,
      default: 'arts'
    }
  },
  data() {
    return {
      isHover: false,
      showFilterOption: false,
      showChild: true,
      currentParent: ''
    }
  },
  computed: {
    getTaxonomies() {
      return this.$store.state.arts.taxonomyFilter
    },
    getCategoryFilterList() {
      return this.$store.state.grants.grantCategoryList
    },
    getSelectedFilterList() {
      return this.filterType === 'arts'
        ? this.getTaxonomies
        : this.getCategoryFilterList
    },
    grantCategory() {
      return this.$store.state.grants.categorySearchSet
    },

    taxonomies() {
      return this.$store.state.arts.taxonomySearchSet
    },
    selectedList() {
      return this.filterType === 'arts' ? this.taxonomies : this.grantCategory
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    }
  },
  methods: {
    toggleFilterOption() {
      this.showFilterOption = !this.showFilterOption
    },
    getFilterText() {
      return this.getSelectedFilterList.length !== 0
        ? `${this.getSelectedFilterList.length} ${
            this.filterType === 'arts' ? 'Taxonomy' : 'Program'
          } Selected`
        : `choose a ${this.filterType === 'arts' ? 'sub-category' : 'Program'}`
    },
    toggleOption() {
      this.showFilterOption = !this.showFilterOption
    },
    hasTaxonomyChild(taxId) {
      return this.taxonomies.some(taxonomy => taxonomy.parent === taxId)
    },
    getChildTaxonomyList(id) {
      return this.returnChildTaxonomy(id).sort(
        (a, b) =>
          this.returnChildTaxonomy(b.id).length -
          this.returnChildTaxonomy(a.id).length
      )
    },

    returnChildTaxonomy(id) {
      return this.taxonomies.filter(taxonomy => taxonomy.parent === id)
    },
    optionSelected(taxList) {
      this.$store.commit('arts/setTaxonomyTag', taxList)
      this.showFilterOption = false
      if (this.isDrawerShown) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }
    },
    getTags() {
      return this.getTaxonomies.reduce((result, item, index) => {
        return (result += `${item} ${
          index !== 0 || index !== this.getTaxonomies.length - 1 ? ' / ' : ''
        } `)
      }, '')
    },
    removeTag() {
      if (this.filterType === 'arts') {
        const resetTaxonomy = this.taxonomies.map(taxonomy => {
          taxonomy.isChecked = false
          return taxonomy
        })
        this.$store.commit('arts/setTaxonomySearchSet', resetTaxonomy)
        this.$store.commit('arts/setTaxonomyTag', [])
      } else {
        const resetList = this.selectedList.map(category => {
          category.isChecked = false
          return category
        })
        this.$store.commit('grants/setGrantCategorySearchSet', resetList)
        this.$store.commit('grants/setCategoryTag', [])
      }
    },
    checkIfSelected(value) {
      return this.getTaxonomies.some(tag => tag === value)
    },
    toggleTaxonomyTag(currentTaxonomy) {
      currentTaxonomy.isChecked = !currentTaxonomy.isChecked
      // if being used in ARTS PAGE
      if (this.filterType === 'arts') {
        if (this.type === 'artwork') {
          setTimeout(() => {
            const filteredTag = this.childTaxonomy.filter(
              taxo => taxo.isChecked === true
            )

            const getTagged = filteredTag.map(taxo => taxo.name)
            this.$store.commit('arts/setTaxonomyTag', getTagged)
          }, 100)
        } else {
          // setTimeout is needed because data is delayed
          setTimeout(() => {
            const filteredTag = this.taxonomies.filter(
              taxo => taxo.isChecked === true
            )

            const getTagged = filteredTag.map(taxo => taxo.name)
            this.$store.commit('arts/setTaxonomyTag', getTagged)
          }, 100)
        }
      }
      // if being used in GRANTS PAGE
      else {
        // setTimeout is needed because data is delayed
        setTimeout(() => {
          const filteredTag = this.selectedList.filter(
            category => category.isChecked === true
          )

          const getTagged = filteredTag.map(category => category.name)
          this.$store.commit('grants/setCategoryTag', getTagged)
        }, 100)
      }
    },
    handleFilter() {
      this.$root.$emit('openSideBarSlider')
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

#badge-filter-modal {
  display: none !important;

  & > * {
    display: none !important;
  }

  .modal-dialog {
  }

  .modal-body {
    max-height: 75vh;
    overflow: auto;
  }

  .modal-backdrop {
    display: none !important;
  }
}

#badge-filter-modal___BV_modal_backdrop_ {
  display: none !important;
}

@media (max-width: 993px) {
  .badge-filter-container {
    margin: 0.25em 0.5em;
  }

  #badge-filter-modal {
    display: block !important;

    & > * {
      display: block !important;
    }
  }

  #badge-filter-modal___BV_modal_backdrop_ {
    display: block !important;
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

.option-column {
  flex-direction: column;
  width: 250px;
}

.option-split {
  flex-direction: row;
  flex-wrap: wrap;
  width: 500px;
}

.badge-option-container {
  display: flex;
  background: #fff;
  border-radius: 0.3rem;
  border: 1px solid rgba(0, 0, 0, 0.2);

  span {
    flex: 0 0 50%;
    position: relative;
    display: flex;
    justify-items: flex-end;
    align-items: center;
    color: #707070;
    padding: 0.5em 0.25em;
    cursor: pointer;
    text-transform: capitalize;

    &:hover {
      color: #fff;
      background: #b47839;
    }

    img {
      width: 10px;
      height: 10px;
      position: absolute;
      right: 1em;
    }
  }
}

.badge-option-inner {
  display: flex;
  align-items: center;
  width: 100%;
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

.modal-filter-container {
  overflow-y: auto;
}

.badge-modal-container {
  padding: 0.5em 0;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.07);
}

.badge-modal-child-container {
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;

  & > * {
    flex: 0 0 45%;
    margin-bottom: 0.25em;
  }
}

.badge-modal-child1-container {
  display: flex;
  flex-direction: column;
  flex-wrap: wrap;
}

.popover {
  border: 0;
}

.popover-body {
  padding: 0;
  margin: 0;
}

.disabled-element {
  pointer-events: none;
}
</style>
