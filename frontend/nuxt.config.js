const webpack = require('webpack')

module.exports = {
  dev: process.env.NODE_ENV !== 'production',

  mode: 'universal',
  server: {
    port: 80, // default: 3000
    host: '0.0.0.0' // default: localhost
  },

  env: {
    COGNITO_APP_CLIENT_ID: process.env.COGNITO_APP_CLIENT_ID,
    COGNITO_URL: process.env.COGNITO_URL,
    COGNITO_HOST: process.env.COGNITO_HOST
  },

  /*
   ** Headers of the page
   */
  head: {
    script: [
      {
        src: `https://polyfill.io/v3/polyfill.min.js?features=Element.prototype.closest%2CArray.from%2CObject.assign`,
        body: true
      }
    ],
    title: "First Peoples' Map of B.C.",
    meta: [
      {
        charset: 'utf-8'
      },
      {
        name: 'viewport',
        content:
          'width=device-width, initial-scale=1 maximum-scale=1, user-scalable=0'
      },
      {
        hid: 'description',
        name: 'description',
        content: process.env.npm_package_description || ''
      }
    ],
    link: [
      {
        rel: 'icon',
        type: 'image/x-icon',
        href: '/favicon.ico'
      },
      {
        rel: 'stylesheet',
        href:
          'https://fonts.googleapis.com/css?family=Lato:300,300i,400,400i,700,700i&display=swap'
      },
      {
        rel: 'stylesheet',
        href:
          'https://fonts.googleapis.com/css?family=Faustina:400,500,700&display=swap'
      }
    ]
  },

  /*
   ** Customize the progress-bar color
   */
  loading: {
    color: '#fff'
  },

  axios: {
    baseURL: process.env.HOST
  },

  /*
   ** Global CSS
   */
  css: [
    '@/assets/styles/sass/index.scss',
    '@/node_modules/mapbox-gl/dist/mapbox-gl.css'
  ],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: [
    '~/mixins/mixins.js',
    '~/plugins/global',
    '~/plugins/lazyloading',
    { src: '~plugins/ga.js', mode: 'client' },
    { src: '~plugins/progressbar.js', mode: 'client' }
  ],
  /*
   ** Nuxt.js modules
   */
  modules: [
    // Doc: https://bootstrap-vue.js.org/docs/
    'bootstrap-vue/nuxt',
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/eslint-module',
    '@nuxtjs/markdownit',
    'nuxt-vue-multiselect'
  ],
  markdownit: {
    injected: true
  },
  tui: {
    editor: {}
  },
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */

  /*
   ** Build configuration
   */
  build: {
    babel: {
      sourceType: 'unambiguous'
    },
    transpile: ['@mapbox/mapbox-gl-draw', 'mapbox-gl-draw-freehand-mode'],
    plugins: [
      new webpack.ProvidePlugin({
        mapboxgl: 'mapbox-gl'
      })
    ],

    postcss: {
      // Add plugin names as key and arguments as value
      // Install them before as dependencies with npm or yarn
      plugins: {
        'postcss-flexbugs-fixes': {},
        'postcss-css-variables': {}
      },
      preset: {
        autoprefixer: {
          grid: true
        }
      }
    },
    /*
     ** You can extend webpack config here
     */
    extend(config, ctx) {
      config.node = {
        fs: 'empty'
      }
      if (ctx.dev && ctx.isClient) {
        config.module.rules.push({
          enforce: 'pre',
          test: /\.(js|vue)$/,
          loader: 'eslint-loader',
          exclude: /(node_modules)/,
          options: {
            fix: true
          }
        })
      }
    }
  }
}
