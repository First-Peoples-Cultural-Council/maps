const warnMapOperation = (operationName, targetType, targetId, reason) => {
  const target = targetId ? ` ${targetType} "${targetId}"` : ''
  console.warn(`[Mapbox] Skipping ${operationName}${target}: ${reason}.`)
}

const MAX_QUEUE_WAIT_MS = 10000
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

const queueMapOperation = (map, key, fn) => {
  const queuedOperations = getQueuedMapOperations(map)
  queuedOperations[key] = { fn }

  if (queuedOperations[`${key}:scheduled`]) {
    return true
  }

  queuedOperations[`${key}:scheduled`] = true
  let removeListener = () => {}
  let settled = false

  const settle = result => {
    if (settled) {
      return result
    }

    settled = true
    clearTimeout(timeoutId)
    removeListener()
    delete queuedOperations[key]
    delete queuedOperations[`${key}:scheduled`]

    return result
  }

  const flush = isFinal => {
    if (settled) {
      return
    }

    const operation = queuedOperations[key]

    if (operation && typeof operation.fn === 'function') {
      const completed = operation.fn(isFinal)
      if (completed || isFinal) {
        return settle(completed)
      }
    }

    return false
  }

  if (typeof map.on === 'function' && typeof map.off === 'function') {
    const onStyleData = () => flush(false)
    map.on('styledata', onStyleData)
    removeListener = () => map.off('styledata', onStyleData)
  } else if (typeof map.once === 'function') {
    map.once('styledata', () => flush(false))
  }

  const timeoutId = setTimeout(() => flush(true), MAX_QUEUE_WAIT_MS)
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

  queueMapOperation(map, `layer:${operationName}:${layerId}`, isFinal => {
    const queuedStatus = getLayerStatus(map, layerId)
    if (!queuedStatus) {
      return runMapAction(operationName, action)
    }

    if (isFinal) {
      warnMapOperation(operationName, 'layer', layerId, queuedStatus)
    }

    return false
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

  queueMapOperation(map, `source:${operationName}:${sourceId}`, isFinal => {
    const queuedStatus = getSourceStatus(map, sourceId)
    if (!queuedStatus) {
      return runMapAction(operationName, action)
    }

    if (isFinal) {
      warnMapOperation(operationName, 'source', sourceId, queuedStatus)
    }

    return false
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
  return layerIds.every(layerId => safeSetLayerVisibility(map, layerId, visibility))
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
