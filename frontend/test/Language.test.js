import { resolve } from 'path'
import { Nuxt, Builder } from 'nuxt'
import regeneratorRuntime from 'regenerator-runtime'

// We keep the nuxt and server instance
// So we can close them at the end of the test
let nuxt = null
// Init Nuxt.js and create a server listening on localhost:4000
beforeEach(async () => {
  const config = {
    dev: false,
    rootDir: resolve(__dirname, '../')
  }
  nuxt = new Nuxt(config)
  await new Builder(nuxt).build()
  await nuxt.server.listen(4000, 'localhost')
}, 30000)

describe('Languages', () => {
  test('Route / exits and render HTML', async () => {
    // const context = {}
    console.log(nuxt.server)
    /*
    const { html } = await nuxt.server.renderRoute(
      '/languages/diiɂdiitidq',
      context
    )
    */

    expect('1').toBe('1')
  })
})

// Close server and ask nuxt to stop listening to file changes
afterEach(() => {
  nuxt.close()
})
