import grantMarker from '@/assets/images/grant_icon.png'

const addLangLayers = map => {
  map.addLayer({
    id: 'satelite',
    type: 'raster',
    source: {
      type: 'raster',
      url: 'mapbox://mapbox.satellite'
    },
    layout: {
      visibility: 'none'
    }
  })
  map.addLayer(
    {
      id: 'fn-lang-areas-fill',
      type: 'fill',
      filter: ['!', ['get', 'sleeping']],
      source: 'langs1',
      layout: {
        visibility: 'visible'
      },
      paint: {
        'fill-color': [
          'interpolate',
          ['linear'],
          ['zoom'],
          0,
          ['get', 'color'],
          7.54,
          'hsla(0, 0%, 0%, 0)',
          22,
          ['get', 'color']
        ],
        'fill-opacity': ['interpolate', ['linear'], ['zoom'], 3, 0.15, 9, 0.1]
      }
    },
    'fn-nations'
  )

  map.addLayer(
    {
      id: 'fn-lang-area-outlines-fade',
      type: 'line',
      filter: ['!', ['get', 'sleeping']],
      source: 'langs1',
      layout: {
        visibility: 'visible'
      },
      paint: {
        'line-color': ['get', 'color'],
        // 'line-blur': ['interpolate', ['linear'], ['zoom'], 0, 1, 12, 6],
        'line-width': [
          'interpolate',
          ['cubic-bezier', 1, 1, 1, 1],
          ['zoom'],
          0,
          3,
          12,
          24
        ],
        'line-opacity': 0.12,
        'line-offset': ['interpolate', ['linear'], ['zoom'], 0, 1, 12, 12]
      }
    },
    'fn-nations'
  )

  map.addLayer(
    {
      id: 'fn-lang-areas-highlighted',
      type: 'line',
      source: 'langs1',
      layout: {
        visibility: 'visible'
      },
      paint: {
        'line-color': 'black',
        'line-width': [
          'interpolate',
          ['cubic-bezier', 1, 1, 1, 1],
          ['zoom'],
          0,
          2,
          12,
          20
        ],
        'line-opacity': 0.35,
        'line-offset': ['interpolate', ['linear'], ['zoom'], 0, -1, 12, -10]
      }
    },
    'fn-nations'
  )
  map.addLayer(
    {
      id: 'fn-lang-area-outlines-1',
      type: 'line',
      filter: ['!', ['get', 'sleeping']],
      source: 'langs1',
      layout: {
        visibility: 'visible'
      },
      paint: {
        'line-color': ['get', 'color'],
        'line-blur': 0,
        'line-width': [
          'interpolate',
          ['cubic-bezier', 1, 1, 1, 1],
          ['zoom'],
          0,
          1,
          12,
          2
        ],
        'line-offset': ['interpolate', ['linear'], ['zoom'], 0, 0.5, 12, 1],
        'line-opacity': 0.75
      }
    },
    'fn-nations'
  )

  map.setFilter('fn-lang-areas-highlighted', ['in', 'name', ''])
}

const addNationsLayers = map => {
  map.addLayer({
    id: 'fn-nations',
    type: 'symbol',
    source: 'communities1',
    minzoom: 5,
    layout: {
      visibility: 'visible',
      'text-optional': true,
      'text-size': 13,
      'icon-image': 'community',
      'text-font': ['BC Sans Regular'],
      'text-padding': 0,
      'text-offset': [0, 1.4],
      'icon-optional': true,
      'icon-size': 0.15,
      'text-field': ['to-string', ['get', 'name']],
      'icon-padding': 0
    },
    paint: {
      'text-color': 'hsl(347, 0%, 0%)',
      'text-halo-width': 1,
      'text-halo-blur': 1,
      'text-halo-color': 'hsl(0, 0%, 100%)',
      'icon-opacity': 0.75
    }
  })
}

const addArtsLayers = (map, context) => {
  map.addLayer(
    {
      id: 'fn-arts',
      minzoom: 3,
      type: 'symbol',
      source: 'arts1',
      filter: ['!', ['has', 'point_count']],
      layout: {
        visibility: 'visible',
        'text-optional': true,
        'symbol-spacing': 50,
        'icon-image': '{kind}_icon',
        'icon-size': 0.15,
        'text-field': '{name}',
        'text-font': ['BC Sans Regular'],
        'text-size': 12,
        'text-offset': [0, 1],
        'text-anchor': 'top'
      },
      paint: {
        'icon-opacity': 0.9
      }
    },
    'fn-nations'
  )

  map.addLayer({
    id: 'fn-arts-clusters',
    type: 'circle',
    source: 'arts1',
    layout: {
      visibility: 'visible'
    },
    minzoom: 3,
    filter: ['has', 'point_count'],
    paint: {
      'circle-color': '#ffffff',
      'circle-opacity': 0.8,
      'circle-stroke-width': 5,
      'circle-stroke-color': '#b45339',
      'circle-radius': [
        'step',
        ['get', 'point_count'],
        12,
        10,
        16,
        100,
        20,
        200,
        24,
        500,
        32
      ]
    }
  })

  map.addLayer({
    id: 'fn-arts-clusters-text',
    type: 'symbol',
    source: 'arts1',
    minzoom: 3,
    filter: ['has', 'point_count'],
    layout: {
      visibility: 'visible',
      'text-field': '{point_count_abbreviated}',
      'text-font': ['BC Sans Regular'],
      'text-size': 11
    },
    paint: {
      'text-color': '#000000'
    }
  })

  map.on('click', 'fn-arts-clusters', function(e) {
    const features = map.queryRenderedFeatures(e.point, {
      layers: ['fn-arts-clusters']
    })
    const clusterId = features[0].properties.cluster_id
    const pointCount = features[0].properties.point_count
    map
      .getSource('arts1')
      .getClusterExpansionZoom(clusterId, function(err, zoom) {
        if (err) return

        if (zoom > 18) {
          map
            .getSource('arts1')
            .getClusterLeaves(clusterId, pointCount, 0, function(
              err,
              aFeatures
            ) {
              if (err) return

              const placenames = aFeatures
              const coordinates = features[0].geometry.coordinates
              context.$root.$emit(
                'showArtsClusterModal',
                placenames,
                coordinates
              )
            })
        } else {
          map.easeTo({
            center: features[0].geometry.coordinates,
            zoom
          })
        }
      })
  })

  const mapboxgl = require('mapbox-gl')

  // objects for caching and keeping track of HTML marker objects (for performance)
  const markers = {}
  let markersOnScreen = {}

  function updateMarkers() {
    const newMarkers = {}
    const features = map.querySourceFeatures('arts1')

    // for every cluster on the screen, create an HTML marker for it (if we didn't yet),
    // and add it to the map if it's not there already
    for (let i = 0; i < features.length; i++) {
      const coords = features[i].geometry.coordinates
      const props = features[i].properties
      if (!props.cluster) continue
      const id = props.cluster_id

      let marker = markers[id]
      if (!marker) {
        const el = getArtsMarker(props)
        marker = markers[id] = new mapboxgl.Marker({
          element: el
        }).setLngLat(coords)
      }
      newMarkers[id] = marker

      if (!markersOnScreen[id]) marker.addTo(map)
    }
    // for every marker we've added previously, remove those that are no longer visible
    for (const id in markersOnScreen) {
      if (!newMarkers[id]) markersOnScreen[id].remove()
    }
    markersOnScreen = newMarkers
  }

  // after the GeoJSON data is loaded, update markers on the screen and do so on every map move/moveend
  map.on('data', function(e) {
    if (e.sourceId !== 'arts1') return
    map.on('move', updateMarkers)
    map.on('moveend', updateMarkers)
    updateMarkers()
  })
}

const addGrantsLayers = (map, context) => {
  let visibility = 'none'

  const routeName = context.$route.name
  if (routeName === 'index-grants') {
    visibility = 'visible'
  }

  map.loadImage(grantMarker, (error, image) => {
    if (error) throw error
    map.addImage('grant-marker', image)

    map.addLayer({
      id: 'fn-grants',
      type: 'symbol',
      source: 'grants1',
      minzoom: 3,
      layout: {
        visibility,
        'text-optional': true,
        'text-size': 13,
        'icon-image': 'grant-marker',
        'text-font': ['BC Sans Regular'],
        'text-padding': 0,
        'text-offset': [0, 1.4],
        'icon-optional': true,
        'icon-size': 0.5,
        'text-field': ['get', 'grant'],
        'icon-padding': 0
      }
    })

    map.addLayer({
      id: 'fn-grants-clusters',
      type: 'circle',
      source: 'grants1',
      filter: ['has', 'point_count'],
      paint: {
        'circle-color': '#ffffff',
        'circle-opacity': 0.8,
        'circle-stroke-width': 5,
        'circle-stroke-color': '#7d6799',
        'circle-radius': [
          'step',
          ['get', 'point_count'],
          12,
          10,
          16,
          100,
          20,
          200,
          24,
          500,
          32
        ]
      },
      layout: {
        visibility
      }
    })

    map.addLayer({
      id: 'fn-grants-cluster-count',
      type: 'symbol',
      source: 'grants1',
      filter: ['has', 'point_count'],
      layout: {
        visibility,
        'text-field': '{point_count_abbreviated}',
        'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
        'text-size': 14
      },
      paint: {
        'text-color': 'black'
      }
    })

    map.addLayer({
      id: 'fn-grants-unclustered-points',
      type: 'circle',
      source: 'grants1',
      filter: ['!', ['has', 'point_count']],
      layout: {
        visibility,
        'icon-image': 'grant-marker',
        'icon-size': 0.5
      }
    })

    map.on('click', 'fn-grants-clusters', function(e) {
      const features = map.queryRenderedFeatures(e.point, {
        layers: ['fn-grants-clusters']
      })
      const clusterId = features[0].properties.cluster_id
      const pointCount = features[0].properties.point_count
      map
        .getSource('grants1')
        .getClusterExpansionZoom(clusterId, function(err, zoom) {
          if (err) return

          if (zoom > 18) {
            map
              .getSource('grants1')
              .getClusterLeaves(clusterId, pointCount, 0, function(
                err,
                aFeatures
              ) {
                if (err) return

                const grants = aFeatures
                const coordinates = features[0].geometry.coordinates
                context.$root.$emit(
                  'showGrantsClusterModal',
                  grants,
                  coordinates
                )
              })
          } else {
            map.easeTo({
              center: features[0].geometry.coordinates,
              zoom
            })
          }
        })
    })
  })
}

const addPlacesLayers = map => {
  map.addLayer(
    {
      id: 'fn-places',
      type: 'symbol',
      source: 'places1',
      minzoom: 5,
      layout: {
        visibility: 'visible',
        'text-optional': true,
        'symbol-spacing': 50,
        'icon-image': 'point_of_interest_icon',
        'icon-size': 0.15,
        'text-field': '{name}',
        'text-font': ['BC Sans Regular'],
        'text-size': 12,
        'text-offset': [0, 0.6],
        'text-anchor': 'top'
      },
      // [cvo] View permissions on frontend is not secure should be done in the API instead.
      // filter: ['!=', ['get', 'status'], 'FL']
      filter: ['!=', '$type', 'Polygon']
    },
    'fn-nations'
  )

  map.addLayer(
    {
      id: 'fn-places-lines',
      type: 'line',
      source: 'places1',
      minzoom: 5,
      layout: {
        visibility: 'visible',
        'line-cap': 'round'
      },
      paint: {
        'line-color': '#987',
        'line-width': 1,
        'line-dasharray': [0, 2]
      },
      filter: ['==', '$type', 'LineString']
    },
    'fn-nations'
  )

  map.addLayer(
    {
      id: 'fn-places-poly',
      type: 'fill',
      source: 'places1',
      minzoom: 5,
      layout: {
        visibility: 'visible'
      },
      paint: {
        'fill-color': '#987',
        'fill-opacity': 0.2
      },
      filter: ['==', '$type', 'Polygon']
    },
    'fn-nations'
  )

  map.addLayer(
    {
      id: 'fn-places-geom-labels',
      type: 'symbol',
      minzoom: 5,
      source: 'places1',
      layout: {
        visibility: 'visible',
        'text-field': ['to-string', ['get', 'name']],
        'text-size': 14,
        'text-font': ['BC Sans Regular']
      },
      paint: {
        'text-halo-width': 2,
        'text-halo-blur': 2,
        'text-halo-color': '#ba9',
        'text-opacity': ['interpolate', ['linear'], ['zoom'], 5, 1, 14, 0.25]
      },
      filter: ['any', ['==', '$type', 'LineString'], ['==', '$type', 'Polygon']]
    },
    'fn-nations'
  )
}

const getArtsMarker = function(features) {
  // Initialize fixed values
  const validKeys = ['artist', 'public_art', 'organization', 'event']
  const pointCount = features.point_count
  const iconSize = 15

  // For horizontal offset of icons
  const divisor = 3 // The lower the value, the closer the icons stick
  const overlap = iconSize / divisor
  let baseHorizontalOffset = -1 * (iconSize * 2 - overlap * 1.5)

  // For vertical offset of icons
  let circleRadius = null
  let verticalOffsetDecrement = iconSize / 2
  if (pointCount <= 10) {
    circleRadius = 10
  } else if (pointCount <= 100) {
    circleRadius = 16
  } else if (pointCount <= 200) {
    circleRadius = 20
  } else if (pointCount <= 500) {
    circleRadius = 24
    verticalOffsetDecrement = iconSize / 3
  } else {
    circleRadius = 32
    verticalOffsetDecrement = iconSize / 4
  }
  const baseVerticalOffset = -1 * (4 + iconSize + (circleRadius - iconSize / 2))

  // Icon creation and styling
  let keyIndex = 0
  const el = document.createElement('div')
  let h = '<div style="position:relative">'
  for (const key in features) {
    // Guards to check whether or not this
    // key is a valid value for the icons
    if (!validKeys.includes(key)) continue
    if (features[key] === 0) continue

    // Calculate the offset for this particular key
    const horizontalOffset = baseHorizontalOffset - keyIndex * overlap
    const verticalOffset =
      keyIndex === 0 || keyIndex === 3
        ? baseVerticalOffset + verticalOffsetDecrement
        : baseVerticalOffset

    const posStyle =
      'position: absolute; transform: translate(' +
      horizontalOffset +
      'px, ' +
      verticalOffset +
      'px);'
    h +=
      '<img src="/' +
      key +
      '_icon.svg" style="width:15px;height:15px;background:white;border-radius:50%;border:1px solid white;' +
      posStyle +
      '">'
    el.innerHTML = h + '</div>'

    // Update looping values
    baseHorizontalOffset += iconSize
    keyIndex += 1
  }

  return el
}

export default {
  layers: (map, context) => {
    addPlacesLayers(map)
    addLangLayers(map)
    addNationsLayers(map)
    addGrantsLayers(map, context)
    addArtsLayers(map, context)

    map.on('mouseenter', 'fn-nations', e => {
      map.getCanvas().style.cursor = 'pointer'
    })
    map.on('mouseleave', 'fn-nations', e => {
      map.getCanvas().style.cursor = 'default'
    })
    map.on('mouseenter', 'fn-arts', e => {
      map.getCanvas().style.cursor = 'pointer'
    })
    map.on('mouseleave', 'fn-arts', e => {
      map.getCanvas().style.cursor = 'default'
    })
    map.on('mouseenter', 'fn-places', e => {
      map.getCanvas().style.cursor = 'pointer'
    })
    map.on('mouseleave', 'fn-places', e => {
      map.getCanvas().style.cursor = 'default'
    })
    map.on('mouseenter', 'fn-grants', e => {
      map.getCanvas().style.cursor = 'pointer'
    })
    map.on('mouseleave', 'fn-grants', e => {
      map.getCanvas().style.cursor = 'default'
    })
    map.on('mouseenter', 'fn-grants-clusters', e => {
      map.getCanvas().style.cursor = 'pointer'
    })
    map.on('mouseleave', 'fn-grants-clusters', e => {
      map.getCanvas().style.cursor = 'default'
    })
    map.on('mouseenter', 'fn-arts-clusters', e => {
      map.getCanvas().style.cursor = 'pointer'
    })
    map.on('mouseleave', 'fn-arts-clusters', e => {
      map.getCanvas().style.cursor = 'default'
    })
  }
}
