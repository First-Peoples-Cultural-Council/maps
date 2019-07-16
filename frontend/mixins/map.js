/* import { bbox } from '@turf/turf' */

export const zoomToLanguage = ({ map, lang, feature }) => {
  console.log('zooming to', lang)
  /* if (!feature) {
    const features = map.querySourceFeatures('langs1')
    feature = features.find(feature => feature.properties.name === lang)
}
console.log('Zoom to feature invoked')
const bounds = bbox(feature) */
  const bounds = [lang.bbox.coordinates[0][0], lang.bbox.coordinates[0][2]]
  console.log(bounds)
  map.fitBounds(bounds, { padding: 30 })
}

export const zoomToCommunity = ({ map, comm, geom }) => {
  map.flyTo({
    center: geom.coordinates,
    zoom: 10
  })
}
