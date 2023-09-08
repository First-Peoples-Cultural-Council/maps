import groupBy from 'lodash/groupBy'
import uniqBy from 'lodash/uniqBy'
import axios from 'axios'
import { pointIntersects, intersects } from '../mixins/map'

export const getApiUrl = path => {
  return process.server ? `http://nginx/api/${path}` : `/api/${path}`
}

export const updateArtHistoryState = data => {
  const getBaseUrl = data.isArtsDetailPage
    ? ''
    : `${data.route}/${encodeFPCC(data.placename)}`

  /* Manually update the URL without refreshing/redirecting the page */

  history.pushState(
    {},
    null,
    `${getBaseUrl}?artwork=${encodeFPCC(data.mediaName)}`
  )
}

export const formatPoint = point => {
  return {
    lng: point[0],
    lat: point[1]
  }
}

export const geomToLatLng = geometry => {
  if (geometry.type === 'Point') {
    return geometry.coordinates
  } else {
    return geometry.coordinates[0][0]
  }
}

export const makeMarker = (geom, icon, context) => {
  const mapboxgl = require('mapbox-gl')
  const el = document.createElement('div')
  el.className = 'marker art-marker'
  el.style = `background-image: url('/${icon}'); z-index: 10;`

  const marker = new mapboxgl.Marker(el).setLngLat(geomToLatLng(geom))
  context.$store.commit('features/setMarker', marker)
  return marker
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
  context,
  sleepingLayer
) => {
  // console.log('it Got here 1')
  if (mode === 'draw' && point) {
    return languageSet.filter(lang => {
      if (!sleepingLayer && lang.sleeping) {
        // console.log('it Got here mode')
        return false
      }
      const langBounds = formatLangBounds(lang)
      return pointIntersects(point, langBounds)
    })
  }

  const filteredLanguages = languageSet.filter(lang => {
    if (!sleepingLayer && lang.sleeping) {
      // console.log('it Got here')
      return false
    }
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

export const decodeFPCC = s => {
  return s.replace(/-/g, ' ')
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

export const setCookie = value => {
  let expires = ''
  if (value.days) {
    const date = new Date()
    date.setTime(date.getTime() + value.days * 24 * 60 * 60 * 1000)
    expires = '; expires=' + date.toUTCString()
  }
  document.cookie =
    value.name + '=' + (value.value || '') + expires + '; path=/'
}

export const getMediaUrl = (media_file, isServer) => {
  if (!media_file) {
    return null
  } else if (media_file.includes('http://nginx')) {
    return media_file.replace('http://nginx', '')
  } else if (media_file.includes('https://nginx')) {
    return media_file.replace('https://nginx', '')
  } else if (media_file && media_file.includes('http://')) {
    return media_file.replace('http://', 'https://')
  }

  if (media_file.name) {
    return media_file.name
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

export const noteType = {
  text: true
}

export const getGenericFileType = fileType => {
  if (fileType === 'youtube') {
    return 'youtube'
  }

  if (fileType === 'vimeo') {
    return 'vimeo'
  }
  if (imageTypes[fileType] || fileType === 'image') {
    return 'image'
  }

  if (audioTypes[fileType]) {
    return 'audio'
  }

  if (noteType[fileType]) {
    return 'note'
  }

  return 'other'
}

export const getFormData = (
  {
    name,
    file_type,
    description,
    type,
    id,
    media_file,
    community_only,
    url,
    is_artwork
  },
  note
) => {
  if (note) {
    const formData = new FormData()
    formData.append('name', name)
    formData.append('file_type', file_type)
    formData.append('description', description)
    formData.append(type, id)

    if (community_only) {
      formData.append('community_only', community_only)
    }
    if (url) {
      formData.append('url', url)
    }
    return formData
  }
  const formData = new FormData()
  formData.append('name', name)
  formData.append('file_type', file_type)
  formData.append('description', description)
  formData.append('media_file', media_file)
  formData.append(type, id)

  if (is_artwork) {
    formData.append('is_artwork', is_artwork)
  }

  if (community_only) {
    formData.append('community_only', community_only)
  }

  return formData
}

export const getYoutubeId = link => {
  /* eslint-disable */
  return link.match(/^.*(youtu.be\/|v\/|e\/|u\/\w+\/|embed\/|v=)([^#\&\?]*).*/)
}

export const getVimeoEmbed = async link => {
  const result = axios.get(`https://vimeo.com/api/oembed.json?url=${link}`)
  return result.video_id
}

export const isValidEmail = email => {
  const regex = /^(([^<>()\[\]\\.,;:\s@"]+(\.[^<>()\[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
  return regex.test(email.toLowerCase())
}

export const isValidURL = email => {
  const regex = new RegExp('^(https?:\\/\\/)?'+ 
    '((([a-z\\d]([a-z\\d-]*[a-z\\d])*)\\.)+[a-z]{2,}|'+
    '((\\d{1,3}\\.){3}\\d{1,3}))'+ 
    '(\\:\\d+)?(\\/[-a-z\\d%_.~+]*)*'+ 
    '(\\?[;&a-z\\d%_.~+=-]*)?'+ 
    '(\\#[-a-z\\d_]*)?$','i'); 
  return !!regex.test(email.toLowerCase());
}

export const isValidYoutubeLink = url => {
  const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
      const match = url.match(regExp)
      return match && match[7].length === 11 ? match[7] : false
}
export const getYoutubeThumbnail = url => {

  return `https://img.youtube.com/vi/${isValidYoutubeLink(
        url
      )}/hqdefault.jpg`
}

export const isEmptyObject = (obj) => {
  return Object.keys(obj).length === 0;
}




