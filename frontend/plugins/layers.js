export default {
  layers: (map, self) => {
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
      'fn-nations copy'
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
      'fn-nations copy'
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
          'line-opacity': 0.45,
          'line-offset': ['interpolate', ['linear'], ['zoom'], 0, -1, 12, -10]
        }
      },
      'fn-nations copy'
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
      'fn-nations copy'
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
      'fn-nations copy'
    )
    map.setFilter('fn-lang-areas-highlighted', ['in', 'name', ''])

    map.addLayer(
      {
        id: 'cluster-count',
        type: 'symbol',
        source: 'arts1',
        filter: ['has', 'point_count'],
        layout: {
          'text-field': '{point_count_abbreviated}',
          'text-font': ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
          'text-size': 12,
          'text-halo-color': 'hsl(0, 0%, 100%)',
          'text-halo-width': 1,
          'text-halo-blur': 1
        }
      },
      'fn-nations copy'
    )

    map.addLayer(
      {
        id: 'fn-arts',
        type: 'symbol',
        source: 'arts1',
        filter: ['!', ['has', 'point_count']],
        layout: {
          'icon-image': '{type}',
          'icon-allow-overlap': true,
          'icon-size': 0.15,
          'text-field': '{title}',
          'text-font': ['Open Sans Regular', 'Arial Unicode MS Regular'],
          'text-size': 12,
          'text-offset': [0, 0.6],
          'text-anchor': 'top'
        }
      },
      'fn-nations copy'
    )

    map.addLayer(
      {
        id: 'fn-places',
        source: 'places1',
        layout: {
          'text-optional': true,
          'icon-optional': true,
          'icon-ignore-placemnt': true,
          'icon-allow-overlap': true,
          'text-size': 13,
          'text-font': ['Open Sans Italic', 'Arial Unicode MS Regular'],
          'text-field': ['get', 'name'],
          'text-offset': [0, 1.3],
          'icon-image': 'point_of_interest_icon',
          'icon-size': 0.15
        },
        paint: {
          'text-halo-color': 'hsl(0, 0%, 100%)',
          'text-halo-width': 1,
          'text-halo-blur': 1,
          'text-color': 'hsl(0, 0%, 24%)'
        }
      },
      'fn-nations copy'
    )

    map.on('click', 'fn-arts', function(e) {
      console.log('Fn-arts', e)
      if (
        e.features[0] &&
        e.features[0].properties &&
        e.features[0].properties.title
      ) {
        self.$router.push({
          path: `/art/${e.features[0].properties.title}`
        })
      }
    })

    map.on('click', 'fn-nations copy copy', function(e) {
      if (
        e.features[0] &&
        e.features[0].properties &&
        e.features[0].properties.title
      ) {
        self.$router.push({
          path: `/content/${e.features[0].properties.title}`
        })
      }
    })
  }
}
