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
          <code>{{ url }}</code>
          <b-button
            size="sm"
            class="d-block mt-2"
            variant="primary"
            @click="copyToClip"
            >Click To Copy</b-button
          >
        </p>
        <h4 class="mt-4">Embed</h4>
        <p>
          <code>{{ iframe }}</code>
        </p>
        <b-button
          size="sm"
          class="d-block mt-2"
          variant="primary"
          @click="copyToClip"
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
    url() {
      return `${this.origin}${this.$route.fullPath}`
    },
    iframe() {
      return `<iframe src="${this.origin}${this.$route.fullPath}"></iframe>`
    }
  },
  mounted() {
    this.origin = window.location.origin
  },
  methods: {
    copyToClip() {}
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
  font-weight: 600;
  text-transform: uppercase;
}
</style>
