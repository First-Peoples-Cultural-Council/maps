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

  test('all pois seem to render fine', async () => {
    const placesApi = JSON.parse(
      await new Promise((resolve, reject) => {
        request('http://nginx/api/placename-geo/', function(
          error,
          response,
          body
        ) {
          if (!error) {
            resolve(body)
          }
          reject(error)
        })
      })
    )
    const placeNamesApi = placesApi.features.map(place =>
      place.properties.name.trim()
    )
    for (let i = 0; i < placeNamesApi.length; i++) {
      const placeName = placeNamesApi[i]
      await page.goto(`http://frontend/place-names/${encodeFPCC(placeName)}`)
      const name = await page.evaluate(() => {
        const names = [...document.querySelectorAll('.place-name')]
        return names.map(div => div.textContent.trim())
      })
      expect(placeName).toBe(name[0])
    }
  }, 300000)
})

afterAll(() => browser.close())
*/
