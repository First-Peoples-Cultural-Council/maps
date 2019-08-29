<template>
  <div class="searchbar-container">
    <div class="searchbar-input-container">
      <b-form-input
        id="search-input"
        v-model="searchQuery"
        type="search"
        class="search-input"
        placeholder="Search for a language, community, or place name..."
        autocomplete="off"
        @update="handleSearchUpdate"
        @focus="handleInputFocus"
      >
      </b-form-input>
      <b-popover
        target="search-input"
        placement="bottom"
        :show.sync="show"
        triggers=""
        @click.native="handlePopOverClick"
      >
        <template slot="title"
          >Search Term: {{ searchQuery }}
        </template>
        <div v-if="isSearchEmpty" class="nosearch-results p-3">
          <Contact
            error="No search results were found"
            subject="FPCC Map: Didn't find what I was looking for (search)"
          ></Contact>
        </div>
        <div v-else class="pt-2">
          <div
            v-for="(results, key) in searchResults"
            :key="key"
            class="search-row"
          >
            <div v-if="results.length > 0" class="mb-3">
              <h5 class="search-result-group font-1 pl-3 pr-3">{{ key }}</h5>
              <div
                v-for="(result, index) in results"
                :key="index"
                class="search-results pl-3 pr-3"
              >
                <h5
                  v-if="key === 'Languages' || key === 'Communities'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="handleResultClick($event, key, result.name)"
                >
                  {{ result.name }}
                </h5>
                <h5
                  v-else-if="key === 'Places'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick($event, key, result.properties.name)
                  "
                >
                  {{ result.properties.name }}
                </h5>
                <h5
                  v-else-if="key === 'Arts'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick($event, key, result.properties.name)
                  "
                >
                  {{ result.properties.name }}
                </h5>
                <h5
                  v-else-if="key === 'Locations'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick(
                      $event,
                      key,
                      result.properties.name,
                      result.geometry
                    )
                  "
                >
                  {{ result.properties.name }} -
                  {{ result.properties.feature.relativeLocation }}
                </h5>
                <h5
                  v-else-if="key === 'Address'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick(
                      $event,
                      key,
                      result.place_name,
                      result.geometry
                    )
                  "
                >
                  {{ result.place_name }}
                </h5>
              </div>
              <hr />
            </div>
          </div>
          <div>
            <Contact
              subject="FPCC Map: Didn't find what I was looking for (search)"
            ></Contact>
          </div>
        </div>
      </b-popover>
      <span class="searchbar-icon"></span>
    </div>
  </div>
</template>

<script>
import { debounce } from 'lodash'
import Contact from '@/components/Contact.vue'
import { encodeFPCC } from '@/plugins/utils.js'
import { zoomToPoint } from '@/mixins/map.js'
const Fuse = require('fuse.js')

export default {
  components: {
    Contact
  },
  data() {
    return {
      MAPBOX_ACCESS_TOKEN:
        'pk.eyJ1IjoiY291bnRhYmxlLXdlYiIsImEiOiJjamQyZG90dzAxcmxmMndtdzBuY3Ywa2ViIn0.MU-sGTVDS9aGzgdJJ3EwHA',
      show: false,
      searchQuery: '',
      searchResultClicked: false,
      languageResults: [],
      communityResults: [],
      placesResults: [],
      artsResults: [],
      locationResults: [],
      addressResults: []
    }
  },
  computed: {
    communities() {
      return this.$store.state.communities.communitySet
    },
    languages() {
      return this.$store.state.languages.languageSet
    },
    places() {
      return this.$store.state.places.placesSet
    },
    arts() {
      return this.$store.state.arts.artsSet
    },
    isSearchEmpty() {
      return (
        this.languageResults.length === 0 &&
        this.communityResults.length === 0 &&
        this.placesResults.length === 0 &&
        this.artsResults.length === 0 &&
        this.locationResults.length === 0 &&
        this.addressResults.length === 0
      )
    },
    searchResults() {
      return {
        Languages: this.languageResults,
        Communities: this.communityResults,
        Places: this.placesResults,
        Arts: this.artsResults,
        Locations: this.locationResults,
        Address: this.addressResults
      }
    }
  },
  mounted() {
    document.addEventListener('click', this.clicked)
  },
  beforeDestroy() {
    document.removeEventListener('click', this.clicked)
  },
  methods: {
    handleSearchUpdate: debounce(async function() {
      if (this.searchQuery === '') {
        this.show = false
        return
      } else {
        this.show = true
      }
      this.languageResults = this.fuzzySearch(
        this.languages,
        this.searchQuery,
        [
          {
            name: 'name',
            weight: 0.3
          },
          {
            name: 'family.name',
            weight: 0.7
          },
          {
            name: 'other_names',
            weight: 0.7
          }
        ]
      )
      this.communityResults = this.fuzzySearch(
        this.communities,
        this.searchQuery,
        ['name']
      )

      this.placesResults = this.fuzzySearch(this.places, this.searchQuery, [
        {
          name: 'properties.name',
          weight: 0.3
        },
        {
          name: 'properties.other_names',
          weight: 0.7
        }
      ])

      this.artsResults = this.fuzzySearch(this.arts, this.searchQuery, [
        'properties.name'
      ])
      try {
        const geoCodeResults = await Promise.all([
          this.$axios.$get(
            `https://apps.gov.bc.ca/pub/bcgnws/names/search?outputFormat=json&name=${
              this.searchQuery
            }&outputSRS=4326&outputStyle=detail`
          ),
          this.$axios.$get(
            `https://api.mapbox.com/geocoding/v5/mapbox.places/${
              this.searchQuery
            }.json?access_token=${
              this.MAPBOX_ACCESS_TOKEN
            }&bbox=-140,48,-114,60`
          )
        ])

        this.locationResults = geoCodeResults[0].features
        this.addressResults = geoCodeResults[1].features
        console.log('Government', this.locationResults)
        console.log('Mapbox', this.addressResults)
      } catch (e) {
        console.error(e)
      }
    }, 500),
    fuzzySearch(data, query, keys) {
      const options = {
        shouldSort: true,
        threshold: 0.3,
        location: 0,
        distance: 70,
        maxPatternLength: 32,
        minMatchCharLength: 3,
        keys
      }

      const fuse = new Fuse(data, options)
      const result = fuse.search(query)
      return result
    },
    // filterBasedOnTitle(data = [], query = '', mode = 0) {
    //   if (data.length === 0) {
    //     return []
    //   }
    //   let results
    //   const lowerCasedQuery = query.toLowerCase()
    //   if (mode === 1) {
    //     results = data.filter(d => {
    //       return (
    //         d.properties.name.toLowerCase().includes(lowerCasedQuery) ||
    //         (d.properties.other_names || '')
    //           .toLowerCase()
    //           .includes(lowerCasedQuery)
    //       )
    //     })
    //   } else {
    //     results = data.filter(d => {
    //       return (
    //         d.name.toLowerCase().includes(lowerCasedQuery) ||
    //         (d.other_names || '').toLowerCase().includes(lowerCasedQuery)
    //       )
    //     })
    //   }
    //   return results
    // },
    clicked(event) {
      const el = event.target
      const isPopOver = el.closest('.popover')
      const isInput = el.closest('.searchbar-input-container')
      if (isInput) {
        return
      }
      if (!isPopOver) {
        this.show = false
      }
    },
    handleInputFocus() {
      if (this.searchQuery !== '') {
        this.show = true
      }
    },
    handleResultClick(event, type, data, geom) {
      this.show = false
      this.searchQuery = data
      if (type === 'Places') {
        return this.$router.push({
          path: `/place-names/${encodeFPCC(data)}`
        })
      }

      if (type === 'Languages') {
        return this.$router.push({
          path: `/languages/${encodeFPCC(data)}`
        })
      }

      if (type === 'Communities') {
        return this.$router.push({
          path: `/content/${encodeFPCC(data)}`
        })
      }

      if (type === 'Arts') {
        return this.$router.push({
          path: `/art/${encodeFPCC(data)}`
        })
      }

      if (type === 'Locations' || type === 'Address') {
        this.$eventHub.whenMap(map => {
          zoomToPoint({ map, geom, zoom: 11 })
        })
      }
    }
  }
}
</script>

<style>
.searchbar-container {
  position: fixed;
  top: 10px;
  left: calc(50% - 250px);
  width: 500px;
}
.searchbar-input-container {
  display: flex;
}
.searchbar-input {
  flex: 10 1 0;
  padding: 0.5em 1em;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-right: 0;
  outline: none;
}
.searchbar-icon {
  flex: 1 1 0;
  background-color: white;
  border-top-right-radius: 0.5em;
  border-bottom-right-radius: 0.5em;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-left: 0;
}
.popover {
  width: var(--searchbar-width, 500px);
  max-width: var(--searchbar-width, 500px);
  max-height: 500px;
  overflow-y: auto;
}

.popover-body {
  padding: 0;
}

.nosearch-results {
  text-align: center;
  font-size: 0.8em;
  padding: 1em;
}
.search-results:hover h5 {
  text-decoration: underline;
  cursor: pointer;
  font-weight: bold !important;
}
.search-result-group {
  font-weight: bold;
}

.search-input::placeholder {
  color: rgba(0, 0, 0, 0.2);
}

@media (max-width: 992px) {
  .searchbar-container {
    top: 0;
    width: auto;
    position: static;
    display: inline-block;
    display: table-cell;
    width: 70%;
    padding-left: 0.5em;
    vertical-align: middle;
  }
}
</style>
