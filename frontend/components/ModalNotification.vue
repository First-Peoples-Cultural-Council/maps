<template>
  <div>
    <b-modal
      id="notify-modal"
      v-model="modalShow"
      class="text-align-center"
      hide-header
      hide-footer
    >
      <div class="font-09 color-dark-gray">
        {{ content }}
      </div>
    </b-modal>
  </div>
</template>
<script>
export default {
  data() {
    return {
      modalShow: false,
      content: null
    }
  },
  mounted() {
    this.$root.$on('notification', params => {
      console.log('This got called')
      if (this.modalShow === false) {
        this.content = params.content
        this.modalShow = true
        setTimeout(() => {
          this.modalShow = false
        }, params.time)
      }
    })
  }
}
</script>
<style>
#notify-modal {
  text-align: center;
}
</style>
