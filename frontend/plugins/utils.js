import { groupBy, uniqBy } from 'lodash'
import { pointIntersects, intersects } from '../mixins/map'

export const getApiUrl = path => {
  return process.server ? `http://nginx/api/${path}` : `/api/${path}`
}

export const formatPoint = point => {
  return {
    lng: point[0],
    lat: point[1]
  }
}

export const formatLangBounds = lang => {
  const sw = lang.bbox.coordinates[0][0]
  const ne = lang.bbox.coordinates[0][2]
  return {
    _sw: {
      lng: sw[0],
      lat: sw[1]
    },
    _ne: {
      lng: ne[0],
      lat: ne[1]
    }
  }
}

export const filterLanguages = (
  languageSet,
  bounds,
  mode = 'default',
  point = null,
  context
) => {
  if (mode === 'draw' && point) {
    return languageSet.filter(lang => {
      const langBounds = formatLangBounds(lang)
      return pointIntersects(point, langBounds)
    })
  }

  const filteredLanguages = languageSet.filter(lang => {
    const langBounds = formatLangBounds(lang)
    return intersects(bounds, langBounds)
  })
  context.$store.commit('languages/setLanguagesCount', filteredLanguages.length)
  return groupBy(filteredLanguages, 'family.name')
}

export const getLanguagesFromDraw = (features, languageSet) => {
  const languagesInFeature = []
  features.map(feature => {
    const geometry = feature.geometry
    if (geometry.type === 'Point') {
      const point = formatPoint(geometry.coordinates)
      languagesInFeature.push(
        ...filterLanguages(languageSet, null, 'draw', point, this)
      )
    }
    if (geometry.type === 'Polygon') {
      geometry.coordinates[0].map(coord => {
        const point = formatPoint(coord)
        languagesInFeature.push(
          ...filterLanguages(languageSet, null, 'draw', point, this)
        )
      })
    }
    if (geometry.type === 'LineString') {
      geometry.coordinates.map(coord => {
        const point = formatPoint(coord)
        languagesInFeature.push(
          ...filterLanguages(languageSet, null, 'draw', point, this)
        )
      })
    }
  })
  return uniqBy(languagesInFeature, 'name')
}

export const encodeFPCC = s => {
  return s
    .trim()
    .toLowerCase()
    .replace(
      /\\|\/|>|<|\?|\)|\(|~|!|@|#|$|^|%|&|\*|=|\+|]|}|\[|{|\||;|:|_|\.|,|`|'|"/g,
      ''
    )
    .replace(/\s+/g, '-')
}

export const getCookie = name => {
  const value = '; ' + document.cookie
  const parts = value.split('; ' + name + '=')
  if (parts.length === 2)
    return parts
      .pop()
      .split(';')
      .shift()
}

export const getMediaUrl = (media_file, isServer) => {
  if (!media_file) {
    return null
  }
  if (isServer) {
    if (media_file.includes('http://nginx')) {
      return media_file.replace('http://nginx', '')
    }

    if (media_file.includes('https://nginx')) {
      return media_file.replace('https://nginx', '')
    }
  }
  return media_file
}
export const imageTypes = {
  'image/svg+xml': true,
  'image/gif': true,
  'image/jpeg': true,
  'image/jpg': true,
  'image/png': true,
  'image/bmp': true
}

export const audioTypes = {
  'audio/mpeg': true,
  'audio/basic': true,
  'audio/mid': true,
  'audio/x-wav': true,
  'audio/x-mpegurl': true,
  'audio/x-aiff': true,
  'audio/mp3': true,
  'audio/webm': true
}

export const fileTypes = {
  'application/pdf': true
}

export const getGenericFileType = fileType => {
  if (imageTypes[fileType]) {
    return 'image'
  }

  if (audioTypes[fileType]) {
    return 'audio'
  }

  return 'other'
}

export const getFormData = (
  { name, file_type, description, type, id, media_file },
  note
) => {
  if (note) {
    const formData = new FormData()
    formData.append('name', name)
    formData.append('file_type', file_type)
    formData.append('description', description)
    formData.append(type, id)
    return formData
  }
  const formData = new FormData()
  formData.append('name', name)
  formData.append('file_type', file_type)
  formData.append('description', description)
  formData.append('media_file', media_file)
  formData.append(type, id)

  return formData
}
