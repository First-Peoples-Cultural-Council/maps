<template>
  <div>
    <b-toast
      id="my-toast"
      :variant="variant"
      solid
      :auto-hide-delay="autoHideDelay"
    >
      <template v-slot:toast-title>
        <div class="d-flex flex-grow-1 align-items-baseline">
          <strong class="mr-auto">{{ title }}</strong>
          <small class="text-muted mr-2">{{ message }}</small>
        </div>
      </template>
      This is the content of the toast. It is short and to the point.
    </b-toast>
  </div>
</template>
<script>
export default {
  data() {
    return {
      autoHideDelay: 1500,
      title: null,
      message: null,
      variant: 'primary'
    }
  },
  mounted() {
    this.$root.$on('notification', params => {
      this.$bvToast.toast(params.message || '', {
        title: params.title,
        variant: params.variant,
        autoHideDelay: params.time || 1500
      })
    })
  }
}
</script>
<style>
#notify-modal {
  text-align: center;
}
</style>
