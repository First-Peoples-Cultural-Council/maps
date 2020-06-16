<template>
  <div
    class="searchbar-container"
    :class="{ 'searchbar-container-detail': isDetailMode }"
  >
    <div class="searchbar-input-container">
      <div v-if="mobile" class="searchbar-mobile-header">
        <div class="search-mobile-icon">
          <img src="@/assets/images/search_icon.svg" alt="Search" />
        </div>
        <div class="search-mobile-input">
          <b-form-input
            id="search-input"
            v-model="searchQuery"
            type="text"
            class="search-input"
            placeholder="Search for a language, community, or place name..."
            autocomplete="off"
            @update="handleSearchUpdate"
            @focus="handleInputFocus"
          >
          </b-form-input>
        </div>
        <div class="search-mobile-close-icon">
          <img
            src="@/assets/images/close_icon.svg"
            alt="Close"
            @click="$root.$emit('closeSearchOverlay', true)"
          />
        </div>
      </div>
      <b-form-input
        v-else
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
      <div v-if="mobile">
        <h5 v-if="searchQuery" class="font-08 font-weight-bold p-3">
          Search Term: {{ searchQuery }}
        </h5>
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
              <h5
                v-if="key === 'Locations'"
                class="search-result-group font-1 pl-3 pr-3"
              >
                Locations from the BC Geographical Names Database
              </h5>
              <h5 v-else class="search-result-group font-1 pl-3 pr-3">
                {{ key }}
              </h5>
              <div
                v-for="(result, index) in results"
                :key="index"
                class="search-results pl-3 pr-3"
              >
                <h5
                  v-if="key === 'Languages' || key === 'Communities'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="handleResultClick($event, key, result.item.name)"
                >
                  <div
                    v-html="highlightSearch(result.item.name, result.matches)"
                  ></div>
                </h5>
                <h5
                  v-else-if="key === 'Places'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick($event, key, result.item.properties.name)
                  "
                >
                  <div
                    v-html="
                      highlightSearch(
                        result.item.properties.name,
                        result.matches
                      )
                    "
                  ></div>
                </h5>
                <h5
                  v-else-if="key === 'Arts'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick($event, key, result.item.properties.name)
                  "
                >
                  <div
                    v-html="
                      highlightSearch(
                        result.item.properties.name,
                        result.matches
                      )
                    "
                  ></div>
                </h5>
                <h5
                  v-else-if="key === 'Locations'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick(
                      $event,
                      key,
                      result.properties.name,
                      result.geometry,
                      result
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
                      result.geometry,
                      result
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
      </div>
      <b-popover
        v-else
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
              <h5
                v-if="key === 'Locations'"
                class="search-result-group font-1 pl-3 pr-3"
              >
                Locations from the BC Geographical Names Database
              </h5>
              <h5 v-else class="search-result-group font-1 pl-3 pr-3">
                {{ key }}
              </h5>
              <div
                v-for="(result, index) in results"
                :key="index"
                class="search-results pl-3 pr-3"
              >
                <h5
                  v-if="key === 'Languages' || key === 'Communities'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="handleResultClick($event, key, result.item.name)"
                >
                  <div
                    v-html="highlightSearch(result.item.name, result.matches)"
                  ></div>
                </h5>
                <h5
                  v-else-if="key === 'Places'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick($event, key, result.item.properties.name)
                  "
                >
                  <div
                    v-html="
                      highlightSearch(
                        result.item.properties.name,
                        result.matches
                      )
                    "
                  ></div>
                </h5>
                <h5
                  v-else-if="key === 'Arts'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick($event, key, result.item.properties.name)
                  "
                >
                  <div
                    v-html="
                      highlightSearch(
                        result.item.properties.name,
                        result.matches
                      )
                    "
                  ></div>
                </h5>
                <h5
                  v-else-if="key === 'Locations'"
                  class="search-result-title font-1 font-weight-normal"
                  @click="
                    handleResultClick(
                      $event,
                      key,
                      result.properties.name,
                      result.geometry,
                      result
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
                      result.geometry,
                      result
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
import debounce from 'lodash/debounce'
import Contact from '@/components/Contact.vue'
import { encodeFPCC } from '@/plugins/utils.js'
import { zoomToPoint } from '@/mixins/map.js'
const Fuse = require('fuse.js')

export default {
  components: {
    Contact
  },
  props: {
    mobile: {
      default: false,
      type: Boolean
    }
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
      addressResults: [],
      popup: null,
      marker: null
    }
  },
  computed: {
    isDetailMode() {
      return this.$store.state.sidebar.isDetailMode
    },
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
        this.searchQuery.length !== 0 &&
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
    generateHighlightedText(s, indices) {
      return indices
        .reduce((str, [start, end]) => {
          str[start] = `<span class="font-weight-bold">${str[start]}`
          str[end] = `${str[end]}</span>`
          return str
        }, s.split(''))
        .join('')
    },
    highlightSearch(s, matches) {
      if (!matches || matches.length === 0) {
        return s
      }

      return this.generateHighlightedText(s, matches[0].indices)
    },
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

      const placeFuzzy = this.fuzzySearch(this.places, this.searchQuery, [
        {
          name: 'properties.name',
          weight: 0.3
        },
        {
          name: 'properties.other_names',
          weight: 0.7
        }
      ])
      this.placesResults = placeFuzzy.filter(
        p => p.item.properties.status !== 'FL'
      )

      this.artsResults = this.fuzzySearch(this.arts, this.searchQuery, [
        'properties.name'
      ])
      try {
        const geoCodeResults = await Promise.all([
          this.$axios.$get(
            `https://apps.gov.bc.ca/pub/bcgnws/names/search?outputFormat=json&name=${this.searchQuery}&outputSRS=4326&outputStyle=detail`
          ),
          this.$axios.$get(
            `https://api.mapbox.com/geocoding/v5/mapbox.places/${this.searchQuery}.json?access_token=${this.MAPBOX_ACCESS_TOKEN}&bbox=-140,48,-114,60`
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
        includeMatches: true,
        includeScore: true,
        shouldSort: true,
        threshold: 0.3,
        location: 0,
        distance: 70,
        maxPatternLength: 32,
        minMatchCharLength: 3,
        keys
      }

      try {
        const fuse = new Fuse(data, options)
        const result = fuse.search(query)
        console.log('Fuse Result', result)

        return result
      } catch (e) {
        return []
      }
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
    handleResultClick(event, type, data, geom, result) {
      if (this.popup) {
        this.popup.remove()
        this.popup = null
      }
      if (this.marker) {
        this.marker.remove()
        this.marker = null
      }
      if (this.mobile) {
        this.$root.$emit('closeSearchOverlay')
      }
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
        const self = this
        this.$eventHub.whenMap(map => {
          self.$router.push({ path: '/languages' })
          zoomToPoint({ map, geom, zoom: 11 })
          const el = document.createElement('div')
          el.className = 'marker search-marker'
          el.style = "background-image: url('https://i.imgur.com/MK4NUzI.png')"
          const mapboxgl = require('mapbox-gl')

          let govLink = ''
          let locationHtml = ''
          if (type === 'Locations') {
            govLink = `http://${result.properties.uri}.html`
            locationHtml = `<div class="mb-1 word-break-all">Location provided from BC Geographical Names website. To view the entry on that site, 
                <a class="white-space-normal" href="${govLink}" target=_blank>click here</a>.</div>`
          }

          self.marker = new mapboxgl.Marker(el)
            .setLngLat(geom.coordinates)
            .addTo(map)
          self.popup = new mapboxgl.Popup({
            className: 'artPopUp'
          })
            .setLngLat(geom.coordinates)
            .setHTML(
              `<div class='popup-inner address-popup'>
                <h4 class="font-1 font-weight-bold">${data}</h4>

                ${locationHtml}
                
                <a class="d-block text-center" href="/contribute?lat=${
                  geom.coordinates[1]
                }&lng=${
                geom.coordinates[0]
              }&cname=${data}">Contribute To This Point.</a>

                </div>`
            )
            .addTo(map)
        })
      }
    }
  }
}
</script>

<style>
.address-popup {
  border-radius: 0.5em;
}
.searchbar-container {
  position: fixed;
  top: 10px;
  left: calc(50% - 200px);
  width: 500px;
}
.searchbar-container-detail {
  left: 45%;
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

@media (max-width: 1200px) {
  .searchbar-container {
    position: fixed;
    top: 10px;
    left: 40%;
    width: 400px;
  }

  .searchbar-container-detail {
    left: 55%;
    width: 300px;
  }
}

@media (max-width: 992px) {
  .searchbar-input-container {
    flex-direction: column;
  }
  .searchbar-container {
    top: 0;
    position: static;
    display: inline-block;
    width: 100%;
    padding: 0 0.5em;
  }

  .searchbar-icon {
    display: none;
  }

  .searchbar-mobile-header {
    display: flex;
    align-items: center;
    padding: 0.25em;
    line-height: 0.8em;
  }

  .search-mobile-input {
    flex: 1 1 auto;
  }

  .search-mobile-input #search-input {
    border: 0;
    font-size: 0.8em;
    border-radius: 0;
    outline: none;
    padding: 0;
  }

  .search-mobile-input #search-input:focus {
    border: none;
    box-shadow: none;
    border-bottom: 1px solid rgba(0, 0, 0, 0.2);
  }

  .search-mobile-icon {
    padding-right: 1em;
  }

  .search-mobile-close-icon {
    padding-left: 1em;
  }
}
</style>
