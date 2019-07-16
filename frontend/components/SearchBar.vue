<template>
  <div class="searchbar-container">
    <div class="searchbar-input-container">
      <b-form-input
        id="search-input"
        v-model="searchQuery"
        type="search"
        class="search-input"
        placeholder="Search for a language..."
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
        <div v-if="languageResults.length === 0" class="nosearch-results">
          No search results were found
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
      searchResults: [],
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
      const languageResults = this.filterBasedOnTitle(
        this.languages,
        this.searchQuery
      )

      const communityResults = this.filterBasedOnTitle(
        this.communities,
        this.searchQuery
      )

      const placesResults = this.filterBasedOnTitle(
        this.places,
        this.searchQuery
      )

      const artsResults = this.filterBasedOnTitle(this.arts, this.searchQuery)

      console.log('Language Results', languageResults)
      console.log('Communities Results', communityResults)
      console.log('Places', placesResults)
      console.log('Arts', artsResults)
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
      const isPopOver = el.closest('#__BV_popover_1__')
      if (!isPopOver) {
        this.show = false
      }
    },
    isSearchEmpty() {
      return (
        this.languageResults.length === 0 &&
        this.communityResults.length === 0 &&
        this.placesResults.length === 0 &&
        this.artsResults.length === 0
      )
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
}

.nosearch-results {
  text-align: center;
  font-size: 0.8em;
  padding: 1em;
}
</style>
