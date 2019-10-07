<template>
  <div class="share-embed-container">
    <h5 v-if="!hideButton" v-b-modal="'share-embed-modal'">Share & Embed</h5>
    <div v-body-scroll-lock="show">
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
          <div v-if="isLoggedIn">
            <h4 class="mt-4">Save Current Location</h4>
            <label class="font-08" for="savetitle">Title</label>

            <b-form-input
              id="savetitle"
              v-model="saveTitle"
              class="font-08"
              placeholder="Enter Title (required)"
              :state="stateTitle"
              required
            ></b-form-input>
            <b-form-invalid-feedback id="title-feedback">
              Title is required
            </b-form-invalid-feedback>

            <label class="mt-3 font-08" for="savedescription"
              >Description</label
            >

            <b-form-textarea
              id="savedescription"
              v-model="saveDescription"
              placeholder="Enter description"
              rows="3"
              max-rows="6"
              class="mt-2 mb-2 font-08"
            ></b-form-textarea>
            <b-button
              size="sm"
              class="d-block mt-2 clipboard"
              variant="primary"
              data-clipboard-target="#iframeShare"
              @click="handleSave"
              >Save Location</b-button
            >
          </div>
        </div>
      </b-modal>
    </div>
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
      saveTitle: null,
      saveDescription: null,
      stateTitle: null,
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
    this.$root.$on('openShareEmbed', d => {
      this.show = true
    })
    this.$root.$on('closeShareEmbed', d => {
      this.show = false
    })
  },
  methods: {
    copyToClip(e, data) {
      const ClipboardJS = require('clipboard')
      const clipboard = new ClipboardJS('.clipboard')
      console.log('Clipboard', clipboard)
    },
    async handleSave() {
      if (!this.saveTitle) {
        this.stateTitle = false
        return false
      }

      const point = {
        type: 'Point',
        coordinates: [this.lng, this.lat]
      }

      const data = {
        name: this.saveTitle,
        favourite_type: 'saved_location',
        description: this.saveDescription,
        point,
        zoom: parseInt(this.zoom)
      }

      const result = await this.$store.dispatch('user/saveLocation', data)
      if (result.status === 'failed') {
        this.$root.$emit('notification', {
          content: result.message || 'Location save failed (unspecified error)',
          time: 1500,
          danger: true
        })
        return false
      }
      if (
        result.request.status === 201 &&
        result.request.statusText === 'Created'
      ) {
        this.$root.$emit('notification', {
          content: 'Location Has Been Saved Successfully',
          time: 1500
        })
        return true
      }
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
