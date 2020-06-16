<template>
  <div class="share-embed-container">
    <h5 v-b-modal="'share-modal'">Share</h5>
    <b-modal
      id="share-modal"
      v-model="show"
      ok-title="Close"
      :ok-only="true"
      :hide-header="true"
      cancel="false"
    >
      <div class="share-embed-modal-contents">
        <h4>Share this Media</h4>
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
      </div>
    </b-modal>
  </div>
</template>

<script>
export default {
  data() {
    return {}
  }
}
</script>

<style></style>
