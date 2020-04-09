/*
import request from 'request'
import { encodeFPCC } from '@/plugins/utils.js'
const puppeteer = require('puppeteer')

let browser = null

beforeAll(async () => {
  browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  })
})

describe('on the community page', () => {
  let page = null

  beforeEach(async () => {
    page = await browser.newPage()
  })

  test('all arts seem to render fine', async () => {
    const artsApi = JSON.parse(
      await new Promise((resolve, reject) => {
        request('http://nginx/api/art/', function(error, response, body) {
          if (!error) {
            resolve(body)
          }
          reject(error)
        })
      })
    )
    const artNamesApi = artsApi.features.map(place =>
      place.properties.name.trim()
    )
    for (let i = 0; i < artNamesApi.length; i++) {
      const artName = artNamesApi[i]
      await page.goto(`http://frontend/art/${encodeFPCC(artName)}`)
      const name = await page.evaluate(() => {
        const names = [...document.querySelectorAll('.art-name')]
        return names.map(div => div.textContent.trim())
      })
      expect(artName).toBe(name[0])
    }
  }, 300000)
})

afterAll(() => browser.close())
*/
