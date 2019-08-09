export const zoomToLanguage = ({ map, lang }) => {
  if (!map) return
  const bounds = [lang.bbox.coordinates[0][0], lang.bbox.coordinates[0][2]]
  map.fitBounds(bounds, { padding: 30 })
  // selectLanguage({ map, lang })
  map.setFilter('fn-lang-areas-highlighted', ['in', 'name', lang.name])
}
export const selectLanguage = ({ map, lang }) => {
  map.setFilter('fn-lang-areas-highlighted', ['in', 'name', lang.name])
}

export const zoomToIdealBox = ({ map }) => {
  const bbox = [
    [-142.921875, 46.800059446787316],
    [-108.9951171875, 62.568120480921074]
  ]
  const bounds = [bbox[0], bbox[1]]
  map.fitBounds(bounds, { padding: 10 })
}

export const zoomToPoint = ({ map, geom, zoom }) => {
  console.log(geom.coordinates)
  const currentZoom = map.getZoom()
  if (currentZoom > zoom) zoom = currentZoom
  map.flyTo({
    center: geom.coordinates,
    zoom: zoom || 10,
    speed: 3
  })
}

export const inBounds = (bounds, lnglat) => {
  let lng
  const multLng = (lnglat[0] - bounds._ne.lng) * (lnglat[0] - bounds._sw.lng)
  if (bounds._ne.lng > bounds._sw.lng) {
    lng = multLng < 0
  } else {
    lng = multLng > 0
  }
  const lat = (lnglat[1] - bounds._ne.lat) * (lnglat[1] - bounds._sw.lat) < 0
  return lng && lat
}

export const intersects = (r1, r2) => {
  return !(
    r2._sw.lng >= r1._ne.lng ||
    r2._ne.lng <= r1._sw.lng ||
    r2._ne.lat <= r1._sw.lat ||
    r2._sw.lat >= r1._ne.lat
  )
}
