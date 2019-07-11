export const state = () => ({
  mapInstance: null
})

export const mutations = {
  set(state, mapInstance) {
    state.mapInstance = mapInstance
  }
}
