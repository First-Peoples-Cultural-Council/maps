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

  test('all communities seem to render fine', async () => {
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
    for (let i = 0; i < communityNamesApi.length; i++) {
      const commName = communityNamesApi[i]
      await page.goto(`http://frontend/content/${encodeFPCC(commName)}`)
      const name = await page.evaluate(() => {
        const names = [...document.querySelectorAll('.comm-name')]
        return names.map(div => div.textContent.trim())
      })
      expect(commName).toBe(name[0])
    }
  }, 300000)
})

afterAll(() => browser.close())
*/

// console.log('Process', process)
