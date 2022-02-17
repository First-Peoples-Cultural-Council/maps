<template>
  <div class="share-embed-container">
    <h5 v-if="!hideButton" @click="toggleModal">Share</h5>
    <b-modal
      id="share-embed-modal"
      v-model="show"
      ok-title="Close"
      :ok-only="true"
      :hide-header="true"
      title="BootstrapVue"
      cancel="false"
    >
      <div class="share-embed-modal-contents">
        <h4>Share</h4>
        <div>
          <pre>{{ url }}</pre>
          <b-button
            size="sm"
            class="d-block mt-2 clipboard"
            variant="primary"
            @click="copyText(url)"
            >Click To Copy</b-button
          >
        </div>
        <h4 class="mt-4">Embed</h4>
        <div>
          <pre>{{ iframeCode }}</pre>
          <EmbedOptions :sc="sc" />
          <b-button
            size="sm"
            class="d-block mt-2 clipboard"
            variant="primary"
            @click="copyText(iframeCode)"
            >Click To Copy</b-button
          >
        </div>
      </div>
    </b-modal>
  </div>
</template>

<script>
import EmbedOptions from '@/components/EmbedOptions.vue'

export default {
  components: {
    EmbedOptions
  },
  props: {
    hideButton: {
      default: false,
      type: Boolean
    }
  },
  data() {
    return {
      origin: '',
      show: false,
      iframeCode: '',
      sol: null,
      sc: null,
      scol: null,
      sap: null,
      lb: null
    }
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    lat() {
      return this.$store.state.mapinstance.lat
    },
    lng() {
      return this.$store.state.mapinstance.lng
    },
    zoom() {
      return this.$store.state.mapinstance.zoom
    },
    url() {
      if (this.lat && this.lng && this.zoom) {
        return `${this.origin}${this.$route.path}#${this.lat}/${this.lng}/${this.zoom}`
      } else {
        return `${this.origin}${this.$route.fullPath}`
      }
    }
  },
  mounted() {
    this.origin = window.location.origin
    this.$root.$on('openShareEmbed', d => {
      this.show = true
    })
    this.$root.$on('closeShareEmbed', d => {
      this.show = false
    })
    this.$root.$on('toggleEmbedOption', (prop, value) => {
      // If Show Communities is disabled, disable
      // Show Communities Outside Language too
      if (prop === 'sc' && value === false) this.scol = false

      this[prop] = value
      this.setIframeText()
    })
    this.setIframeText()
  },
  methods: {
    toggleModal() {
      this.show = !this.show
      this.$store.commit('sidebar/setDrawerContent', false)
    },
    copyText(text) {
      navigator.clipboard.writeText(text)
    },
    setIframeText() {
      let uri

      // Build querystring
      const paramsArray = ['embed=1']
      if (this.sol) paramsArray.push('sol=1')
      if (this.sc) paramsArray.push('sc=1')
      if (this.scol) paramsArray.push('scol=1')
      if (this.sap) paramsArray.push('sap=1')
      if (this.lb) paramsArray.push('lb=1')
      const params = paramsArray.join('&')

      if (this.lat && this.lng && this.zoom) {
        uri = `${this.origin}${this.$route.path}`
        uri = encodeURI(uri)
        this.iframeCode = `<iframe src="${uri}?${params}#${this.lat}/${this.lng}/${this.zoom}" width="600" height="400" allowfullscreen></iframe>`
      } else {
        uri = `${this.origin}${this.$route.fullPath}`
        uri = encodeURI(uri)
        this.iframeCode = `<iframe src="${uri}?${params}" width="600" height="400" allowfullscreen></iframe>`
      }
    }
  }
}
</script>

<style>
.share-embed-container {
  background-color: white;
  border: 1px solid #ddd5cc;
  cursor: pointer;
}
.share-embed-container h5 {
  font-weight: 800;
  font-size: 15px;
  color: #151515;
  margin: 0;
  padding: 0.5em 0.75em;
  text-transform: uppercase;
}
pre {
  font-size: 12px;
  padding: 4px;
  color: #e83e8c;
  border-radius: 5px;
}
</style>
