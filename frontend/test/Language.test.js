import { resolve } from 'path'
import { Nuxt, Builder } from 'nuxt'
import regeneratorRuntime from 'regenerator-runtime'
import { JSDOM } from 'jsdom'
import { uniqBy } from 'lodash'
import { JestEnvironment } from '@jest/environment'
import request from 'request'

// We keep the nuxt and server instance
// So we can close them at the end of the test

// Init Nuxt.js and create a server listening on localhost:4000
let nuxt = null

beforeAll(async () => {
  const config = {
    dev: false,
    rootDir: resolve(__dirname, '../'),
    modules: [
      // Doc: https://axios.nuxtjs.org/usage
      '@nuxtjs/axios',
      '@nuxtjs/pwa',
      '@nuxtjs/eslint-module'
    ],
    plugins: ['~/mixins/mixins.js', '~/plugins/global']
  }
  nuxt = new Nuxt(config)
  await new Builder(nuxt).build()
  await nuxt.server.listen(4000, 'localhost')
}, 300000)

describe('Languages', () => {
  test('Route / exits and render HTML', async () => {
    const context = {}
    const { html } = await nuxt.server.renderRoute('/', context)
    const { window } = new JSDOM(html).window

    const languagesRendered = uniqBy(
      window.document.getElementsByClassName('language-card-title'),
      'textContent'
    ).map(lang => lang.textContent.trim())

    const languagesApi = JSON.parse(
      await new Promise((resolve, reject) => {
        request('http://nginx/api/language/', function(error, response, body) {
          if (!error) {
            resolve(body)
          }
          reject(error)
        })
      })
    )

    const languageNamesApi = languagesApi.map(lang => lang.name)
    expect(languagesRendered.sort()).toEqual(languageNamesApi.sort())
  }, 300000)
})

afterAll(() => {
  nuxt.close()
})
