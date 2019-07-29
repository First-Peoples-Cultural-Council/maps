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
      name: 'Sleeping Languages (TBA)',
      id: 2,
      layerNames: ['fn-lang-areas-highlighted'],
      active: true
    },
    {
      name: 'Reserves',
      id: 3,
      layerNames: ['fn-reserve-outlines', 'fn-reserve-areas'],
      active: false
    }
  ]
})

export const mutations = {
  set(state, layer) {
    state.layers.push(layer)
  },

  toggleLayer(state, layer) {
    const toggleLayer = state.layers.find(l => l.id === layer.id)
    toggleLayer.active = !toggleLayer.active
  }
}
