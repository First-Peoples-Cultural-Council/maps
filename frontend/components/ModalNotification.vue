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
        <b-alert v-if="!danger" show class="m-0">{{ content }}</b-alert>
        <b-alert v-else show class="m-0" variant="danger">{{
          content
        }}</b-alert>
      </div>
    </b-modal>
  </div>
</template>
<script>
export default {
  data() {
    return {
      modalShow: false,
      content: null,
      danger: false
    }
  },
  mounted() {
    this.$root.$on('notification', params => {
      console.log('This got called')
      if (this.modalShow === false) {
        if (params.danger) {
          this.danger = true
        }
        this.content = params.content
        this.modalShow = true
        setTimeout(() => {
          this.modalShow = false
          setTimeout(() => {
            this.danger = false
          }, 1000)
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
