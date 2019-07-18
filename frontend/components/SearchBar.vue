<template>
  <div class="searchbar-container">
    <div class="searchbar-input-container">
      <b-form-input
        id="search-input"
        v-model="searchQuery"
        type="search"
        class="search-input"
        placeholder="Search for a language..."
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
          <p>
            <span>No search results were found</span><br /><span>
              Didn't find what you were looking for? Email us at
              <a href="#">daniel@email.com</a></span
            >
          </p>
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
                    handleResultClick($event, key, result.properties.title)
                  "
                >
                  {{ result.properties.title }}
                </h5>
              </div>
              <hr />
            </div>
          </div>
          <div>
            <p class="text-center p-3">
              Didn't find what you were looking for? Email us at
              <a href="#">daniel@email.com</a>
            </p>
          </div>
        </div>
      </b-popover>
      <span class="searchbar-icon"></span>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      show: false,
      searchQuery: '',
      searchResultClicked: false,
      languageResults: [],
      communityResults: [],
      placesResults: [],
      artsResults: []
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
        this.artsResults.length === 0
      )
    },
    searchResults() {
      return {
        Languages: this.languageResults,
        Communities: this.communityResults,
        Places: this.placesResults,
        Arts: this.artsResults
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
    handleSearchUpdate() {
      if (this.searchQuery === '') {
        this.show = false
      } else {
        this.show = true
      }
      this.languageResults = this.filterBasedOnTitle(
        this.languages,
        this.searchQuery
      )

      this.communityResults = this.filterBasedOnTitle(
        this.communities,
        this.searchQuery
      )

      this.placesResults = this.filterBasedOnTitle(
        this.places,
        this.searchQuery,
        2
      )

      this.artsResults = this.filterBasedOnTitle(this.arts, this.searchQuery, 1)
    },
    filterBasedOnTitle(data = [], query = '', mode = 0) {
      if (data.length === 0) {
        return []
      }
      const lowerCasedQuery = query.toLowerCase()
      if (mode === 1) {
        return data.filter(d =>
          d.properties.title.toLowerCase().includes(lowerCasedQuery)
        )
      }
      if (mode === 2) {
        return data.filter(d =>
          d.properties.name.toLowerCase().includes(lowerCasedQuery)
        )
      }
      return data.filter(d => d.name.toLowerCase().includes(lowerCasedQuery))
    },
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
    handleResultClick(event, type, data) {
      this.show = false
      this.searchQuery = data
      if (type === 'Places') {
        return this.$router.push({
          path: `/place-names`
        })
      }

      if (type === 'Languages') {
        return this.$router.push({
          path: `/languages/${encodeURIComponent(data)}`
        })
      }

      if (type === 'Communities') {
        return this.$router.push({
          path: `/content/${encodeURIComponent(data)}`
        })
      }

      if (type === 'Arts') {
        return this.$router.push({
          path: `/art`
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
  width: var(--searchbar-width);
  max-width: var(--searchbar-width);
  max-height: 500px;
  overflow-y: scroll;
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
</style>
