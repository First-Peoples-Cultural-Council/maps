const _ = require('lodash')
const puppeteer = require('puppeteer')

const test = async () => {
  const browser = await puppeteer.launch({
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  })
  const page = await browser.newPage()
  await page.goto('http://frontend')
  const communities = await page.evaluate(() => {
    const divs = [...document.querySelectorAll('.community-card-title')]
    return divs.map(div => div.textContent.trim())
  })
  console.log('Communities', _.uniq(communities).length)

  await browser.close()
}

test()
