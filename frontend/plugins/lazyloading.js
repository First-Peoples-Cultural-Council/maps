import VueLazyload from 'vue-lazyload'
import Vue from 'vue'
import error from '~/assets/images/artwork_icon.svg'
import loading from '~/assets/images/loading.gif'

Vue.use(VueLazyload, {
  preLoad: 1.3,
  error,
  loading,
  attempt: 1
})
