const warnMapOperation = (operationName, targetType, targetId, reason) => {
  const target = targetId ? ` ${targetType} "${targetId}"` : ''
  console.warn(`[Mapbox] Skipping ${operationName}${target}: ${reason}.`)
}

const MAX_RETRY_ATTEMPTS = 3
const queuedMapOperations = new WeakMap()

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
  if (!queuedMapOperations.has(map)) {
    queuedMapOperations.set(map, {})
  }

  return queuedMapOperations.get(map)
}

const queueMapOperation = (map, key, attempt, fn) => {
  const queuedOperations = getQueuedMapOperations(map)
  queuedOperations[key] = {
    attempt,
    fn
  }

  if (queuedOperations[`${key}:scheduled`]) {
    return true
  }

  queuedOperations[`${key}:scheduled`] = true
  let flushed = false
  let removeListener = () => {}

  const flush = () => {
    if (flushed) {
      return
    }

    flushed = true
    clearTimeout(timeoutId)
    removeListener()
    const operation = queuedOperations[key]
    delete queuedOperations[key]
    delete queuedOperations[`${key}:scheduled`]

    if (operation && typeof operation.fn === 'function') {
      operation.fn(operation.attempt)
    }
  }

  if (typeof map.on === 'function' && typeof map.off === 'function') {
    map.on('styledata', flush)
    removeListener = () => map.off('styledata', flush)
  } else if (typeof map.once === 'function') {
    map.once('styledata', flush)
  }

  const timeoutId = setTimeout(flush, attempt * 100)
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

const runWhenLayerReady = (map, layerId, operationName, action, attempt = 0) => {
  const status = getLayerStatus(map, layerId)
  if (!status) {
    return runMapAction(operationName, action)
  }

  if (!map) {
    warnMapOperation(operationName, 'layer', layerId, status)
    return false
  }

  if (attempt >= MAX_RETRY_ATTEMPTS) {
    warnMapOperation(operationName, 'layer', layerId, status)
    return false
  }

  queueMapOperation(
    map,
    `layer:${operationName}:${layerId}`,
    attempt + 1,
    nextAttempt => {
      runWhenLayerReady(map, layerId, operationName, action, nextAttempt)
    }
  )

  return false
}

const runWhenSourceReady = (map, sourceId, operationName, action, attempt = 0) => {
  const status = getSourceStatus(map, sourceId)
  if (!status) {
    return runMapAction(operationName, action)
  }

  if (!map) {
    warnMapOperation(operationName, 'source', sourceId, status)
    return false
  }

  if (attempt >= MAX_RETRY_ATTEMPTS) {
    warnMapOperation(operationName, 'source', sourceId, status)
    return false
  }

  queueMapOperation(
    map,
    `source:${operationName}:${sourceId}`,
    attempt + 1,
    nextAttempt => {
      runWhenSourceReady(map, sourceId, operationName, action, nextAttempt)
    }
  )

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
  return layerIds.map(layerId =>
    safeSetLayerVisibility(map, layerId, visibility)
  )
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
