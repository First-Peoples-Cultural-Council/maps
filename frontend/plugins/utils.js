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
