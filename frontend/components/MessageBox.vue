<template>
  <div>
    <b-modal v-model="modalShow" ok-only hide-header @ok="toggleModal">
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
    show: {
      type: Boolean,
      default: false
    },
    message: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      modalShow: this.show
    }
  },
  methods: {
    toggleModal() {
      this.modalShow = false
    }
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
