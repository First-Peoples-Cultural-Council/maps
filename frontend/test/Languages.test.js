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

  test('all languages seem to render fine', async () => {
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
    const languageNamesApi = languagesApi.map(lang => lang.name.trim())
    for (let i = 0; i < languageNamesApi.length; i++) {
      const langName = languageNamesApi[i]
      await page.goto(`http://frontend/languages/${encodeFPCC(langName)}`)
      const name = await page.evaluate(() => {
        const names = [...document.querySelectorAll('.lang-name')]
        return names.map(div => div.textContent.trim())
      })

      expect(langName).toBe(name[0])
    }
  }, 300000)
})

afterAll(() => browser.close())
*/
