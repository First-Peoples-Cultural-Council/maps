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
      layout: {},
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
      layout: {},
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
      layout: {},
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
      layout: {},
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

const getHTMLMarker = function(map, feature, el) {
  // const layer = map.getLayer('fn-arts-clusters')
  if (!feature.properties.cluster_id) return
  map
    .getSource('arts1')
    .getClusterLeaves(
      feature.properties.cluster_id,
      feature.properties.point_count,
      0,
      function(err, aFeatures) {
        if (err) {
          console.warn('Error', err)
        }
        const buckets = {}
        for (let i = 0; i < aFeatures.length; i++) {
          buckets[aFeatures[i].properties.kind] = 1
        }

        let h = '<div style="position:relative">'
        let key
        let arc = -1.5
        // make an arc of icons on the outside of the parent.
        for (key in buckets) {
          const posStyle =
            'position: absolute; transform: translate(' +
            (Math.sin(arc) * 13 - 9) +
            'px, ' +
            (-Math.cos(arc) * 11 - 9) +
            'px);'
          arc += 0.9
          h +=
            '<img src="/' +
            key +
            '_icon.svg" style="width:15px;height:15px;background:white;border-radius:50%;border:1px solid white;' +
            posStyle +
            '">'
        }
        el.innerHTML = h + '</div>'
      }
    )
}

const addHTMLClusters = map => {
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
        const el = document.createElement('div')
        getHTMLMarker(map, features[i], el)
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
    updateMarkers()
  })

  map.on('move', updateMarkers)
  map.on('moveend', updateMarkers)
}

export default {
  layers: (map, self) => {
    map.addLayer({
      id: 'fn-arts-clusters',
      type: 'circle',
      source: 'arts1',
      minzoom: 3,
      filter: ['has', 'point_count'],
      paint: {
        'circle-color': '#000000',
        // 'circle-radius': ['step', ['get', 'point_count'], 15, 30, 20, 75, 25],
        'circle-radius': 10,
        'circle-opacity': 0.6,
        'circle-stroke-color': '#ffffff',
        'circle-stroke-width': 2,
        'circle-stroke-opacity': 0.7
      }
    })
    addNationsLayers(map)
    addLangLayers(map)
    map.addLayer({
      id: 'fn-arts-clusters-text',
      type: 'symbol',
      source: 'arts1',
      minzoom: 3,
      filter: ['has', 'point_count'],
      layout: {
        'text-field': '{point_count_abbreviated}',
        'text-font': ['BC Sans Regular'],
        'text-size': 11,
        'text-offset': [0, 0.2]
      },
      paint: {
        'text-color': '#ffffff'
      }
    })

    map.addLayer(
      {
        id: 'fn-places',
        type: 'symbol',
        source: 'places1',
        minzoom: 5,
        layout: {
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
        layout: {},
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
        filter: [
          'any',
          ['==', '$type', 'LineString'],
          ['==', '$type', 'Polygon']
        ]
      },
      'fn-nations'
    )

    map.addLayer(
      {
        minzoom: 6,
        id: 'fn-arts',
        type: 'symbol',
        source: 'arts1',
        filter: ['!', ['has', 'point_count']],
        layout: {
          'text-optional': true,
          'symbol-spacing': 50,
          'icon-image': '{kind}_icon',
          'icon-size': 0.15,
          'text-field': '{name}',
          'text-font': ['BC Sans Regular'],
          'text-size': 12,
          'text-offset': [0, 0.6],
          'text-anchor': 'top'
        },
        paint: {
          'icon-opacity': 0.75
        }
      },
      'fn-nations'
    )

    // Loading this from MapBox Studio seems to fix a font rendering issue.
    // [cvo] I've otherwise not been able to determine the root cause (when loading it locally)
    /*
    map.addLayer({
      id: 'fn-lang-labels',
      type: 'symbol',
      source: 'langs1',
      filter: ['get', 'sleeping'],
      layout: {
        'text-field': ['to-string', ['get', 'name']],
        'text-size': 16,
        'text-font': ['BC Sans Regular']
      },
      paint: {
        'text-halo-width': 2,
        'text-halo-blur': 2,
        'text-opacity': ['interpolate', ['linear'], ['zoom'], 5, 1, 14, 0.25],
        'text-halo-color': [
          'let',
          'rgba',
          ['to-rgba', ['to-color', ['get', 'color']]],

          [
            'let',
            'r',
            ['number', ['*', 1, ['at', 0, ['const', 'rgba']]]],
            'g',
            ['number', ['*', 1, ['at', 1, ['const', 'rgba']]]],
            'b',
            ['number', ['*', 1, ['at', 2, ['const', 'rgba']]]],
            'a',
            ['number', ['at', 3, ['const', 'rgba']]],

            [
              'let',
              'r2',
              ['+', ['*', 0.7, 255], ['*', 0.3, ['const', 'r']]],
              'g2',
              ['+', ['*', 0.7, 255], ['*', 0.3, ['const', 'g']]],
              'b2',
              ['+', ['*', 0.7, 255], ['*', 0.3, ['const', 'b']]],
              ['rgba', ['const', 'r2'], ['const', 'g2'], ['const', 'b2'], 1]
            ]
          ]
        ]
      }
    })
    */

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

    addHTMLClusters(map)

    // Layer feature precedence controls, in correct order for your reference:
    //       'text-optional': true,
    //       'icon-optional': true,
    //       'text-ignore-placemnt': true,
    //       'icon-ignore-placemnt': true,
    //       'symbol-spacing': 1,
    //       'text-allow-overlap': true,
    //       'icon-allow-overlap': true,
  }
}
