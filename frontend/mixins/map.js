import { bbox } from '@turf/turf'

export const zoomToLanguage = ({ map, lang, feature }) => {
  try {
    if (!feature) {
      const features = map.querySourceFeatures('langs1')
      feature = features.find(feature => feature.properties.title === lang)
    }
    console.log('Zoom to feature invoked')
    const bounds = bbox(feature)
    map.fitBounds(bounds, { padding: 30 })
  } catch (e) {
    alert('Language/Community must be visible in map!')
  }
}

export const zoomToCommunity = ({ map, comm, geom }) => {
  map.flyTo({
    center: geom.coordinates,
    zoom: 10
  })
}
