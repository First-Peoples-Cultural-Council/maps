<template>
  <div>
    <b-modal v-model="show" ok-only hide-header @ok="toggleModal">
      <div class="message-box-container">
        <!-- <img class="message-box-icon" src="@/assets/images/user_icon.svg" /> -->
        <span class="message-box-content">
          {{ message }}
        </span>
      </div>
    </b-modal>
  </div>
</template>
<script>
export default {
  props: {
    showModal: {
      type: Boolean,
      default: false
    },
    message: {
      type: String,
      default: ''
    },
    toggleModal: {
      default: () => {
        return true
      },
      type: Function
    }
  },
  data() {
    return {
      show: false
    }
  },
  mounted() {
    this.show = this.showModal
  }
}
</script>
<style>
.message-box-container {
  display: flex;
  flex-direction: column;
  align-items: center;
}
</style>
