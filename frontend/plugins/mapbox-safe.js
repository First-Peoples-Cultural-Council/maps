const warnMapOperation = (operationName, targetType, targetId, reason) => {
  const target = targetId ? ` ${targetType} "${targetId}"` : ''
  console.warn(`[Mapbox] Skipping ${operationName}${target}: ${reason}.`)
}

const runMapAction = (operationName, action) => {
  try {
    action()
    return true
  } catch (error) {
    console.warn(`[Mapbox] Failed to ${operationName}.`, error)
    return false
  }
}

const getQueuedMapOperations = map => {
  if (!map.__fpccQueuedMapOperations) {
    map.__fpccQueuedMapOperations = {}
  }

  return map.__fpccQueuedMapOperations
}

const queueMapOperation = (map, key, fn) => {
  const queuedOperations = getQueuedMapOperations(map)
  queuedOperations[key] = fn

  if (queuedOperations[`${key}:scheduled`]) {
    return true
  }

  queuedOperations[`${key}:scheduled`] = true

  const flush = () => {
    const operation = queuedOperations[key]
    delete queuedOperations[key]
    delete queuedOperations[`${key}:scheduled`]

    if (typeof operation === 'function') {
      operation()
    }
  }

  if (typeof map.once === 'function') {
    map.once('idle', flush)
    return true
  }

  flush()
  return true
}

const getLayerStatus = (map, layerId) => {
  if (!map) {
    return 'map is unavailable'
  }

  if (typeof map.isStyleLoaded !== 'function' || !map.isStyleLoaded()) {
    return 'map style is not loaded'
  }

  if (typeof map.getLayer !== 'function' || !map.getLayer(layerId)) {
    return 'layer does not exist'
  }

  return null
}

const getSourceStatus = (map, sourceId) => {
  if (!map) {
    return 'map is unavailable'
  }

  if (typeof map.isStyleLoaded !== 'function' || !map.isStyleLoaded()) {
    return 'map style is not loaded'
  }

  if (typeof map.getSource !== 'function') {
    return 'source lookup is unavailable'
  }

  const source = map.getSource(sourceId)
  if (!source) {
    return 'source does not exist'
  }

  if (typeof source.setData !== 'function') {
    return 'source does not support setData'
  }

  return null
}

const runWhenLayerReady = (map, layerId, operationName, action) => {
  const status = getLayerStatus(map, layerId)
  if (!status) {
    return runMapAction(operationName, action)
  }

  if (!map) {
    warnMapOperation(operationName, 'layer', layerId, status)
    return false
  }

  queueMapOperation(map, `layer:${operationName}:${layerId}`, () => {
    const queuedStatus = getLayerStatus(map, layerId)
    if (queuedStatus) {
      warnMapOperation(operationName, 'layer', layerId, queuedStatus)
      return false
    }

    return runMapAction(operationName, action)
  })

  return false
}

const runWhenSourceReady = (map, sourceId, operationName, action) => {
  const status = getSourceStatus(map, sourceId)
  if (!status) {
    return runMapAction(operationName, action)
  }

  if (!map) {
    warnMapOperation(operationName, 'source', sourceId, status)
    return false
  }

  queueMapOperation(map, `source:${operationName}:${sourceId}`, () => {
    const queuedStatus = getSourceStatus(map, sourceId)
    if (queuedStatus) {
      warnMapOperation(operationName, 'source', sourceId, queuedStatus)
      return false
    }

    return runMapAction(operationName, action)
  })

  return false
}

export const safeSetLayerVisibility = (map, layerId, visibility) => {
  return runWhenLayerReady(
    map,
    layerId,
    `set visibility to "${visibility}"`,
    () => {
      map.setLayoutProperty(layerId, 'visibility', visibility)
    }
  )
}

export const safeSetLayersVisibility = (map, layerIds, visibility) => {
  layerIds.forEach(layerId => safeSetLayerVisibility(map, layerId, visibility))
}

export const safeSetFilter = (map, layerId, filter) => {
  return runWhenLayerReady(map, layerId, 'set filter', () => {
    map.setFilter(layerId, filter)
  })
}

export const safeSetSourceData = (map, sourceId, data) => {
  return runWhenSourceReady(map, sourceId, 'set source data', () => {
    map.getSource(sourceId).setData(data)
  })
}
