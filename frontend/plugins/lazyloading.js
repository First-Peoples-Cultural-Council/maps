import VueLazyload from 'vue-lazyload'
import Vue from 'vue'
import loading from '~/assets/images/loading.gif'

Vue.use(VueLazyload, {
  preLoad: 1.3,
  loading,
  attempt: 1
})
