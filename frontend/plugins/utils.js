export const getApiUrl = path => {
  console.log(process.server)
  return process.server ? `http://nginx/api/${path}` : `/api/${path}`
}
