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
    <div
      v-if="isSelected || (isSelected && getTaxonomies.length !== 0)"
      class="badge-filters "
    >
      <p id="badge-choose" @click="showFilterOption = !showFilterOption">
        {{
          showFilterOption
            ? 'Click here to Close'
            : `${
                getTaxonomies.length !== 0
                  ? `${getTaxonomies.length} Taxonomy Selected`
                  : 'choose sub-category'
              } `
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
        v-if="showFilterOption"
        id="filter-popover"
        target="badge-choose"
        placement="bottom"
        triggers="click "
        :show="showFilterOption"
      >
        <div class="badge-option-container">
          <span
            v-for="taxonomy in childTaxonomy"
            :id="`badge-child-option-${taxonomy.id}`"
            :key="taxonomy.id"
            class="badge-option-child"
          >
            <b-form-checkbox
              v-model="taxonomy.isChecked"
              class="d-inline-block ml-2"
              @change="toggleTaxonomyTag(taxonomy)"
            >
            </b-form-checkbox>
            {{ taxonomy.name }}

            <img
              v-if="hasTaxonomyChild(taxonomy.id) && filterType === 'arts'"
              src="@/assets/images/right.svg"
            />
            <!-- Child Popover -->
            <b-popover
              v-if="hasTaxonomyChild(taxonomy.id) && filterType === 'arts'"
              :id="`child-popover-${taxonomy.name}`"
              :target="`badge-child-option-${taxonomy.id}`"
              placement="right"
              triggers="click"
            >
              <div class="badge-option-container">
                <span
                  v-for="taxChild in getChildTaxonomyList(taxonomy.id)"
                  :id="`badge-child-option-${taxChild.id}`"
                  :key="taxChild.id"
                >
                  <b-form-checkbox
                    v-model="taxChild.isChecked"
                    class="d-inline-block ml-2"
                    @change="toggleTaxonomyTag(taxChild)"
                  >
                  </b-form-checkbox>
                  {{ taxChild.name }}

                  <img
                    v-if="hasTaxonomyChild(taxChild.id)"
                    src="@/assets/images/right.svg"
                  />

                  <!-- Child Child Popover -->
                  <b-popover
                    v-if="hasTaxonomyChild(taxChild.id)"
                    :id="`child1-popover-${taxChild.name}`"
                    :target="`badge-child-option-${taxChild.id}`"
                    placement="right"
                    triggers="click"
                  >
                    <div class="badge-option-container">
                      <span
                        v-for="taxChild1 in getChildTaxonomyList(taxChild.id)"
                        :id="`badge-child-option-${taxChild1.id}`"
                        :key="taxChild1.id"
                      >
                        <b-form-checkbox
                          v-model="taxChild1.isChecked"
                          class="d-inline-block ml-2"
                          @change="toggleTaxonomyTag(taxChild1)"
                        >
                        </b-form-checkbox>
                        {{ taxChild1.name }}

                        <img
                          v-if="hasTaxonomyChild(taxChild1.id)"
                          src="@/assets/images/right.svg"
                        />
                      </span>
                    </div>
                  </b-popover>
                </span>
              </div>
            </b-popover>
          </span>
        </div>
      </b-popover>
      <b-modal
        id="badge-filter-modal"
        ref="badge-filter-modal"
        v-model="showFilterOption"
        size="xl"
        title="Select Taxonomy Filters"
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
              {{ taxonomy.name }}
            </b-form-checkbox>

            <div
              v-if="hasTaxonomyChild(taxonomy.id)"
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
      const resetTaxonomy = this.taxonomies.map(taxonomy => {
        taxonomy.isChecked = false
        return taxonomy
      })
      this.$store.commit('arts/setTaxonomySearchSet', resetTaxonomy)
      this.$store.commit('arts/setTaxonomyTag', [])
    },
    checkIfSelected(value) {
      return this.getTaxonomies.some(tag => tag === value)
    },
    toggleTaxonomyTag(currentTaxonomy) {
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
          // if you uncheck a parent taxonomy, also uncheck the child
          if (currentTaxonomy.isChecked) {
            this.taxonomies
              .filter(taxo => taxo.parent === currentTaxonomy.id)
              .map(taxo => {
                if (currentTaxonomy.isChecked) {
                  taxo.isChecked = false
                }
                return taxo
              })
          }
          // if you check a child taxonomy, also check the parent
          else {
            const findParent = this.taxonomies.find(
              taxo => currentTaxonomy.parent === taxo.id
            )

            if (findParent) findParent.isChecked = true
          }

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

.badge-option-container {
  display: flex;
  flex-direction: column;

  span {
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

.checkbox-parent {
  font-size: 1.25em;
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
  width: 80%;
}

.popover-body {
  padding: 0;
  margin: 0;
}
</style>
