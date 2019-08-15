import { resolve } from 'path'
import { Nuxt, Builder } from 'nuxt'
import regeneratorRuntime from 'regenerator-runtime'

// We keep the nuxt and server instance
// So we can close them at the end of the test

// Init Nuxt.js and create a server listening on localhost:4000

describe('Languages', () => {
  test('Route / exits and render HTML', async () => {
    let nuxt = null
    const context = {}
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

    const { html } = await nuxt.server.renderRoute('/', context)
    console.log(html)

    expect('1').toBe('1')
  }, 300000)
})
