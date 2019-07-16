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
        @blur="handleSearchLeave"
      ></b-form-input>
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
        <div v-else>
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
                <h5 class="search-result-title font-1 font-weight-normal">
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
      languageResults: [],
      communityResults: [],
      placesResults: [],
      artsResults: []
    }
  },
  computed: {
    communities() {
      return this.$store.state.communities.communities
    },
    languages() {
      return this.$store.state.languages.languages
    },
    places() {
      return this.$store.state.places.places
    },
    arts() {
      return this.$store.state.arts.arts
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
        Arts: this.arts
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
      console.log('Form Changed')
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
        this.searchQuery
      )

      this.artsResults = this.filterBasedOnTitle(this.arts, this.searchQuery)
    },
    handleSearchLeave() {
      console.log(this.clickedElement)
      // this.show = false
    },
    filterBasedOnTitle(data = [], query = '') {
      const lowerCasedQuery = query.toLowerCase()
      return data.filter(d =>
        d.properties.title.toLowerCase().includes(lowerCasedQuery)
      )
    },
    clicked(event) {
      const el = event.target
      const isPopOver = el.closest('.popover')
      if (!isPopOver) {
        this.show = false
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
</style>
