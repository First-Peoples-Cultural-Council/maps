export const getApiUrl = path => {
  return process.server ? `http://nginx/api/${path}` : `/api/${path}`
}
