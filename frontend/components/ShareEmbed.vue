<template>
  <div class="share-embed-container">
    <h5 v-b-modal="'share-embed-modal'">Share & Embed</h5>
    <b-modal
      id="share-embed-modal"
      ok-title="Close"
      :ok-only="true"
      :hide-header="true"
      title="BootstrapVue"
      cancel="false"
    >
      <div class="share-embed-modal-contents">
        <h4>Share</h4>
        <p>
          <code id="urlShare">{{ url }}</code>
          <b-button
            size="sm"
            class="d-block mt-2"
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
          class="d-block mt-2"
          variant="primary"
          @click="copyToClip($event, 'iframe')"
          >Click To Copy</b-button
        >
      </div>
    </b-modal>
  </div>
</template>

<script>
export default {
  data() {
    return {
      origin: ''
    }
  },
  computed: {
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
        console.log(this.$route)
        return `${this.origin}${this.$route.path}#${this.lat}/${this.lng}/${
          this.zoom
        }`
      } else {
        return `${this.origin}${this.$route.fullPath}`
      }
    },
    iframe() {
      if (this.lat && this.lng && this.zoom) {
        return `<iframe src="${this.origin}${this.$route.path}#${this.lat}/${
          this.lng
        }/${this.zoom}"></iframe>`
      } else {
        return `<iframe src="${this.origin}${this.$route.fullPath}"></iframe>`
      }
    }
  },
  mounted() {
    this.origin = window.location.origin
  },
  methods: {
    copyToClip(e, data) {
      let innerText = ''
      if (data === 'url') {
        innerText = document.getElementById('urlShare').innerText
      } else if (data === 'iframe') {
        innerText = document.getElementById('iframeShare').innerText
      }

      const tempInput = document.createElement('input')
      const modal = document.getElementById('share-embed-modal')
      tempInput.type = 'text'
      tempInput.value = innerText
      modal.appendChild(tempInput)
      tempInput.select()
      document.execCommand('Copy')
      modal.removeChild(tempInput)
    }
  }
}
</script>

<style>
.share-embed-container {
  background-color: white;
  border: 1px solid #ddd5cc;
  border-radius: 0.2em;
  cursor: pointer;
}
.share-embed-container h5 {
  font-size: 0.75em;
  margin: 0;
  padding: 0.5em 0.75em;
  color: #7b7b7b;
  font-weight: 700;
  text-transform: uppercase;
}
</style>
