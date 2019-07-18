<template>
  <div>
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

<style></style>
