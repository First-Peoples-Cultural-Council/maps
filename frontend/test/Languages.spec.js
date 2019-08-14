import { mount } from '@vue/test-utils'
import Logo from '@/components/Logo.vue'

describe('Languages', () => {
  test('is Language Correctly Loaded', () => {
    const wrapper = mount(Logo)
    expect(wrapper.isVueInstance()).toBeTruthy()
  })
})
