export default {
  layers: map => {
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
          'fill-opacity': ['interpolate', ['linear'], ['zoom'], 3, 0.5, 9, 0.08]
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
          'line-opacity': 0.45,
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
      'fn-nations'
    )

    map.addLayer(
      {
        id: 'fn-arts',
        type: 'symbol',
        source: 'arts1',
        filter: ['!', ['has', 'point_count']],
        layout: {
          'icon-image': 'artist_icon',
          'text-field': '{title}',
          'text-font': ['Open Sans Regular', 'Arial Unicode MS Regular'],
          'text-size': 12,
          'text-offset': [0, 0.6],
          'text-anchor': 'top'
        }
      },
      'fn-nations'
    )
  }
}
