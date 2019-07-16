export const zoomToLanguage = ({ map, lang }) => {
  const bounds = [lang.bbox.coordinates[0][0], lang.bbox.coordinates[0][2]]
  console.log('zooming to', lang.name, bounds[0], bounds[1])
  map.fitBounds(bounds, { padding: 30 })
}

export const zoomToCommunity = ({ map, comm, geom }) => {
  map.flyTo({
    center: geom.coordinates,
    zoom: 10
  })
}
