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
        <p>
          <code id="urlShare" data-clipboard-text="This will be copied">{{
            url
          }}</code>
          <b-button
            id="urlshare-button"
            size="sm"
            class="d-block mt-2 clipboard"
            data-clipboard-target="#urlShare"
            variant="primary"
            @click="copyToClip($event, 'url')"
            >Click To Copy</b-button
          >
        </p>
        <h4 class="mt-4">Embed</h4>
        <p>
          <code id="iframeShare">{{ iframe }}</code>
        </p>
        <b-button
          size="sm"
          class="d-block mt-2 clipboard"
          variant="primary"
          data-clipboard-target="#iframeShare"
          @click="copyToClip($event, 'iframe')"
          >Click To Copy</b-button
        >
      </div>
    </b-modal>
  </div>
</template>

<script>
export default {
  props: {
    hideButton: {
      default: false,
      type: Boolean
    }
  },
  data() {
    return {
      origin: '',

      show: false
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
        // console.log(this.$route)
        return `${this.origin}${this.$route.path}#${this.lat}/${this.lng}/${this.zoom}`
      } else {
        return `${this.origin}${this.$route.fullPath}`
      }
    },
    iframe() {
      if (this.lat && this.lng && this.zoom) {
        return `<iframe src="${this.origin}${this.$route.path}#${this.lat}/${this.lng}/${this.zoom}"></iframe>`
      } else {
        return `<iframe src="${this.origin}${this.$route.fullPath}"></iframe>`
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
  },
  methods: {
    toggleModal() {
      this.show = !this.show
      this.$store.commit('sidebar/setDrawerContent', false)
    },
    copyToClip(e, data) {
      // const ClipboardJS = require('clipboard')
      // const clipboard = new ClipboardJS('.clipboard')
      // console.log('Clipboard', clipboard)
    }
  }
}
</script>

<style>
.share-embed-container {
  background-color: white;
  border: 1px solid #ddd5cc;
  border-radius: 3em;
  cursor: pointer;
}
.share-embed-container h5 {
  font: Bold 15px/18px Proxima Nova;
  color: #151515;
  margin: 0;
  padding: 0.5em 0.75em;
  text-transform: uppercase;
}
</style>
