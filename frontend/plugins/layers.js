const addLangLayers = map => {
  map.addLayer(
    {
      id: 'fn-lang-areas-fill',
      type: 'fill',
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
        'fill-opacity': ['interpolate', ['linear'], ['zoom'], 3, 0.4, 9, 0.06]
      }
    },
    'fn-nations'
  )

  map.addLayer(
    {
      id: 'fn-lang-area-outlines-fade',
      type: 'line',
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
  map.addLayer(
    {
      id: 'fn-lang-areas-shaded',
      type: 'fill',
      source: 'langs1',
      layout: {},
      paint: {
        'fill-color': 'black',
        'fill-opacity': 0.001
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
    layout: {
      'text-optional': true,
      'text-size': 13,
      'icon-image': 'community',
      'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
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
export default {
  layers: (map, self) => {
    addNationsLayers(map)
    addLangLayers(map)
    map.addLayer(
      {
        id: 'cluster-count',
        type: 'symbol',
        source: 'arts1',
        filter: ['has', 'point_count'],
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
          'text-size': 12,
          'text-halo-color': 'hsl(0, 0%, 100%)',
          'text-halo-width': 1,
          'text-halo-blur': 1
        }
      },
      'fn-nations'
    )

    map.addLayer(
      {
        id: 'fn-places',
        type: 'symbol',
        source: 'places1',
        layout: {
          'text-optional': true,
          'symbol-spacing': 50,
          'icon-image': 'point_of_interest_icon',
          'icon-size': 0.15,
          'text-field': '{name}',
          'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
          'text-size': 12,
          'text-offset': [0, 0.6],
          'text-anchor': 'top'
        }
      },
      'fn-nations'
    )

    map.addLayer(
      {
        id: 'fn-arts',
        type: 'symbol',
        source: 'arts1',
        filter: ['!', ['has', 'point_count']],
        layout: {
          'text-optional': true,
          'symbol-spacing': 50,
          'icon-image': '{type}',
          'icon-size': 0.15,
          'text-field': '{title}',
          'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
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

    map.addLayer({
      id: 'fn-lang-labels',
      type: 'symbol',
      source: 'langs1',
      layout: {
        'text-field': ['to-string', ['get', 'name']],
        'text-size': 16,
        'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular']
      },
      paint: {
        'text-halo-width': 1,
        'text-halo-blur': 1,
        'text-halo-color': 'hsl(0, 0%, 100%)'
      }
    })

    map.addLayer({
      id: 'fn-nations-highlighted',
      type: 'symbol',
      source: 'communities1',
      layout: {
        'text-size': 15,
        'icon-image': 'community',
        'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
        'text-padding': 0,
        'text-offset': [0, 1.7],
        'icon-size': 0.25,
        'text-field': ['to-string', ['get', 'name']],
        'icon-padding': 0
      },
      paint: {
        'text-color': 'hsl(347, 0%, 0%)',
        'text-halo-width': 2,
        'text-halo-blur': 2,
        'text-halo-color': 'hsl(53, 50%, 70%)'
      }
    })

    map.addLayer({
      id: 'fn-arts-highlighted',
      type: 'symbol',
      source: 'arts1',
      layout: {
        'text-optional': true,
        'symbol-spacing': 50,
        'icon-image': '{type}',
        'icon-size': 0.25,
        'text-field': '{title}',
        'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
        'text-size': 15,
        'text-offset': [0, 0.6],
        'text-anchor': 'top'
      },
      paint: {
        'text-color': 'hsl(347, 0%, 0%)',
        'text-halo-width': 2,
        'text-halo-blur': 2,
        'text-halo-color': 'hsl(53, 50%, 70%)'
      }
    })

    map.addLayer({
      id: 'fn-places-highlighted',
      type: 'symbol',
      source: 'places1',
      layout: {
        'text-optional': true,
        'symbol-spacing': 50,
        'icon-image': 'point_of_interest_icon',
        'icon-size': 0.25,
        'text-field': '{name}',
        'text-font': ['FreeSans Medium', 'Arial Unicode MS Regular'],
        'text-size': 15,
        'text-offset': [0, 0.6],
        'text-anchor': 'top'
      },
      paint: {
        'text-color': 'hsl(347, 0%, 0%)',
        'text-halo-width': 2,
        'text-halo-blur': 2,
        'text-halo-color': 'hsl(53, 50%, 70%)'
      }
    })

    map.setFilter('fn-nations-highlighted', ['in', 'name', ''])
    map.setFilter('fn-places-highlighted', ['in', 'name', ''])
    map.setFilter('fn-arts-highlighted', ['in', 'title', ''])

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
    //       'text-optional': true,
    //       'icon-optional': true,
    //       'text-ignore-placemnt': true,
    //       'icon-ignore-placemnt': true,
    //       'symbol-spacing': 1,
    //       'text-allow-overlap': true,
    //       'icon-allow-overlap': true,
  }
}
