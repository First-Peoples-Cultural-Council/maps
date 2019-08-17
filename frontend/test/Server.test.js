import { resolve } from 'path'
import { Nuxt, Builder } from 'nuxt'
import regeneratorRuntime from 'regenerator-runtime'
import { JSDOM } from 'jsdom'
import { uniqBy } from 'lodash'
import { JestEnvironment } from '@jest/environment'
import request from 'request'
import { encodeFPCC } from '@/plugins/utils.js'

// We keep the nuxt and server instance
// So we can close them at the end of the test

// Init Nuxt.js and create a server listening on localhost:4000
let nuxt = null

beforeAll(async () => {
  const config = {
    mode: 'universal',
    dev: false,
    rootDir: resolve(__dirname, '../'),
    modules: [
      // Doc: https://axios.nuxtjs.org/usage
      'bootstrap-vue/nuxt',
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

describe(`Index Route / (Landing Page)`, () => {
  test('All languages are rendered', async () => {
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

  test('All communities are rendered', async () => {
    const context = {}
    const { html } = await nuxt.server.renderRoute('/', context)
    const { window } = new JSDOM(html).window

    const communitiesRendered = uniqBy(
      window.document.getElementsByClassName('community-card-title'),
      'textContent'
    ).map(comm => comm.textContent.trim())

    const communitiesApi = JSON.parse(
      await new Promise((resolve, reject) => {
        request('http://nginx/api/community/', function(error, response, body) {
          if (!error) {
            resolve(body)
          }
          reject(error)
        })
      })
    )

    const communityNamesApi = communitiesApi.map(comm => comm.name.trim())
    expect(communitiesRendered.sort()).toEqual(communityNamesApi.sort())
  }, 300000)

  test('All languages are rendered', async () => {
    // const context = {}
    // const { html } = await nuxt.server.renderRoute('/', context)
    // const { window } = new JSDOM(html).window

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

    const { html } = await nuxt.server.renderRoute(`/languages/hailhzaqvla`, {
      params: {
        lang: 'hailhzaqvla'
      }
    })
    console.log('Html', html)
    /*
    languagesApi.map(async lang => {
      const context = {}
      console.log('Lang Name', encodeFPCC(lang.name))
      try {
        const { html } = await nuxt.server.renderRoute(
          `/languages/${encodeFPCC(lang.name)}`,
          context
        )
        console.log('html', html)
      } catch (e) {
        console.error(e)
      }

      /*
      const context = {}
      const { html } = await nuxt.server.renderRoute(
        `/languages/${encodeFPCC(lang.name)}`,
        context
      )
      console.log('Html', html)
      /*
      const { window } = new JSDOM(html).window
      const languageRendered = uniqBy(
        window.document.getElementsByClassName('language-title'),
        'textContent'encodeFPCC
      ).map(lang => lang.textContent.trim())
      console.log('Language Rendered', languageRendered)
      */
    // })
  }, 300000)
})

afterAll(() => {
  nuxt.close()
})
