<template>
  <div class="d-flex align-items-center">
    <b-button variant="info" block>Upload Media</b-button>
    <ToolTip
      class="pl-2"
      content="Add relevant audio, images, links to YouTube videos, and PDF files. You can add multiple files."
    ></ToolTip>
  </div>
</template>
<script>
import ToolTip from '@/components/Tooltip.vue'

export default {
  components: {
    ToolTip
  }
}
</script>
<style></style>
