/*
{ createLocalVue, shallowMount } from '@vue/test-utils'
import {} from '../plugins/global'
import regeneratorRuntime from 'regenerator-runtime'
import BootstrapVue from 'bootstrap-vue'
import { encodeFPCC } from '../plugins/utils'
import Language from '../pages/index/languages/_lang/index.vue'
const request = require('request-promise')
const localVue = createLocalVue()
localVue.use(BootstrapVue)

describe('Languages', () => {
  test('is Language Correctly Loaded', () => {
    return request('http://nginx/api/language/').then(data => {
      const languages = JSON.parse(data)
      languages.map(lang => {
        console.log(encodeFPCC(lang.name))
        const $route = {
          params: encodeFPCC(lang.name)
        }
        const wrapper = shallowMount(Language, {
          Vue: localVue,
          mocks: {
            $route
          }
        })

        console.log(wrapper.vm.languages)
      })
      expect('1').toBe('1')
    })
  })
})
*/
