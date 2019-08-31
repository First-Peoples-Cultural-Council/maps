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
