const webpack = require('webpack')

module.exports = {
  mode: 'universal',
  server: {
    port: 80, // default: 3000
    host: '0.0.0.0' // default: localhost
  },
  /*
   ** Headers of the page
   */
  head: {
    script: [
      {
        src: `https://cdnjs.cloudflare.com/ajax/libs/core-js/2.6.9/core.min.js`,
        body: true
      },
      {
        src: `https://unpkg.com/element-closest/browser`,
        body: true
      }
    ],
    title: "%s | First Peoples' Cultural Council",
    meta: [
      {
        charset: 'utf-8'
      },
      {
        name: 'viewport',
        content: 'width=device-width, initial-scale=1'
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
          'https://fonts.googleapis.com/css?family=Lato:300,400,700&display=swap'
      }
    ]
  },
  /*
   ** Customize the progress-bar color
   */
  loading: {
    color: '#fff'
  },
  /*
   ** history mode
   */
  //   router: {
  //     mode: 'hash'
  //   },
  /*
   ** Global CSS
   */
  css: [
    '@/assets/styles/sass/global.sass',
    '@/node_modules/mapbox-gl/dist/mapbox-gl.css'
  ],
  /*
   ** Plugins to load before mounting the App
   */
  plugins: ['~/plugins/global'],
  /*
   ** Nuxt.js modules
   */
  polyfill: {
    features: [
      {
        require: '@babel/polyfill'
      }
    ]
  },
  modules: [
    // Doc: https://bootstrap-vue.js.org/docs/
    'bootstrap-vue/nuxt',
    // Doc: https://axios.nuxtjs.org/usage
    '@nuxtjs/axios',
    '@nuxtjs/pwa',
    '@nuxtjs/eslint-module'
  ],
  /*
   ** Axios module configuration
   ** See https://axios.nuxtjs.org/options
   */
  axios: {
    debug: true
  },

  /*
   ** Build configuration
   */
  build: {
    analyze: true,
    plugins: [
      new webpack.ProvidePlugin({
        mapboxgl: 'mapbox-gl'
      })
    ],
    postcss: {
      // Add plugin names as key and arguments as value
      // Install them before as dependencies with npm or yarn
      plugins: {
        'postcss-flexbugs-fixes': {}
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
