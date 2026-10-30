import { getApiUrl } from '@/plugins/utils.js'

let pendingGrantsLoad = null

export const state = () => ({
  grantsSet: [],
  grantsGeo: { features: [] },
  isGrantsLoaded: false,
  filterDate: null,
  currentGrant: null,
  categorySearchSet: [],
  grantFilterMode: 'all',
  grantCategoryList: [],
  grantsSearch: '',
  visibleGrantsCount: 0
})

export const mutations = {
  setGrants(state, grantsSet) {
    state.grantsSet = grantsSet
  },
  setGrantsGeo(state, grantsGeo) {
    state.grantsGeo = grantsGeo
  },
  setGrantFilterDate(state, value) {
    state.filterDate = value
  },
  setCurrentGrant(state, grant) {
    state.currentGrant = grant
  },
  setGrantCategorySearchSet(state, result) {
    state.categorySearchSet = result
  },
  setGrantFilter(state, value) {
    state.grantFilterMode = value
  },
  setCategoryTag(state, value) {
    state.grantCategoryList = value
  },
  setGrantsSearch(state, query) {
    state.grantsSearch = query
  },
  setVisibleGrantsCount(state, count) {
    state.visibleGrantsCount = count
  },
  setIsGrantsLoaded(state, isLoaded) {
    state.isGrantsLoaded = isLoaded
  }
}

export const actions = {
  loadGrants({ state, commit }) {
    if (state.isGrantsLoaded) return Promise.resolve()

    if (!pendingGrantsLoad) {
      pendingGrantsLoad = Promise.all([
        this.$axios.$get(getApiUrl('grants')),
        this.$axios.$get(getApiUrl('grant-categories'))
      ])
        .then(([grants, categories]) => {
          // Categories first: grant badges and cards look up each grant's category.
          commit(
            'setGrantCategorySearchSet',
            categories.map(category => {
              category.isChecked = false
              return category
            })
          )
          commit('setGrantsGeo', grants)
          commit('setGrants', grants.features)
          commit('setIsGrantsLoaded', true)
        })
        .catch(error => {
          console.error('Failed to fetch grants data', error)
        })
        .finally(() => {
          pendingGrantsLoad = null
        })
    }

    return pendingGrantsLoad
  }
}
