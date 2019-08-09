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
