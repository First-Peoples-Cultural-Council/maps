import request from 'request'
const _ = require('lodash')
const puppeteer = require('puppeteer')

let browser = null

beforeAll(async () => {
  browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  })
})

describe('on the index page', () => {
  let page = null

  beforeEach(async () => {
    page = await browser.newPage()
    await page.goto('http://frontend')
  })

  test('all communities is accurate', async () => {
    const communitiesRendered = _.uniq(
      await page.evaluate(() => {
        const divs = [...document.querySelectorAll('.community-card-title')]
        return divs.map(div => div.textContent.trim())
      })
    )

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
  })

  test('all languages is accurate', async () => {
    const languagesRendered = _.uniq(
      await page.evaluate(() => {
        const divs = [...document.querySelectorAll('.language-card-title')]
        return divs.map(div => div.textContent.trim())
      })
    )

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
    expect(languagesRendered.sort()).toEqual(languageNamesApi.sort())
  })
})

afterAll(() => browser.close())
