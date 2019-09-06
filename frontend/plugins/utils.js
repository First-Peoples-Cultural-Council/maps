export const getApiUrl = path => {
  return process.server ? `http://nginx/api/${path}` : `/api/${path}`
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

export const getGenericFileType = fileType => {
  const imageTypes = {
    'image/svg+xml': true,
    'image/gif': true,
    'image/jpeg': true,
    'image/jpg': true,
    'image/png': true,
    'image/bmp': true
  }

  const audioTypes = {
    'audio/mpeg': true,
    'audio/basic': true,
    'audio/mid': true,
    'audio/x-wav': true,
    'audio/x-mpegurl': true,
    'audio/x-aiff': true,
    'audio/mp3': true
  }

  if (imageTypes[fileType]) {
    return 'image'
  }

  if (audioTypes[fileType]) {
    return 'audio'
  }

  return 'other'
}
