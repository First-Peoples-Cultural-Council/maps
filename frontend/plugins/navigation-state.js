// Mirrors Nuxt's route loading lifecycle into the store so the sidebar can show
// feedback while the next page's asyncData runs. Nuxt calls start() before
// asyncData and finish()/fail()/pause() when the navigation settles.
export default ({ store }) => {
  window.onNuxtReady(app => {
    const loading = app.$loading
    if (!loading || typeof loading.start !== 'function') return

    const track = (method, isNavigating) => {
      const original = loading[method]
      if (typeof original !== 'function') return
      loading[method] = (...args) => {
        store.commit('sidebar/setNavigating', isNavigating)
        return original.apply(loading, args)
      }
    }

    track('start', true)
    track('finish', false)
    track('fail', false)
    track('pause', false)
  })
}
