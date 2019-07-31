export const state = () => ({
  layers: [
    {
      name: 'Western Names',
      id: 1,
      layerNames: [
        'settlement-subdivision-label',
        'transit-label',
        'water-point-label',
        'water-line-label',
        'natural-point-label',
        'natural-line-label',
        'waterway-label',
        'road-label',
        'settlement-label',
        'coutour-label',
        'poi-label'
      ],
      active: true
    },
    {
      name: 'Sleeping Languages',
      id: 2,
      layerNames: [
        'fn-lang-area-outlines-1',
        'fn-lang-area-outlines-fade',
        'fn-lang-areas-fill'
      ],
      active: true
    },
    {
      name: 'Reserves',
      id: 3,
      layerNames: [
        'fn-reserve-outlines',
        'fn-reserve-areas',
        'fn-reserve-labels'
      ],
      active: false
    },
    {
      name: 'Provincial Borders',
      id: 4,
      layerNames: ['admin'],
      active: true
    }
  ]
})

export const mutations = {
  set(state, layer) {
    state.layers.push(layer)
  },

  toggleLayer(state, { layer, map, on }) {
    console.log(arguments)
    const toggleLayer = state.layers.find(l => l.id === layer.id)
    toggleLayer.active = !toggleLayer.active
    if (toggleLayer.name === 'Sleeping Languages') {
      if (on) {
        layer.layerNames.map(l => {
          map.setFilter(l, ['!', ['get', 'sleeping']])
        })
      } else {
        layer.layerNames.map(l => {
          map.setFilter(l, ['!=', 'name', ''])
        })
      }
    } else if (on) {
      layer.layerNames.map(l => {
        map.setLayoutProperty(l, 'visibility', 'visible')
      })
    } else {
      layer.layerNames.map(l => {
        map.setLayoutProperty(l, 'visibility', 'none')
      })
    }
  }
}
