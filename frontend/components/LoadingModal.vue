<template>
  <div v-if="showLoading" class="progress-container">
    <!-- <progress-bar :options="options" :value="percentage" /> -->
  </div>
</template>

<script>
// import ProgressBar from 'vuejs-progress-bar'

export default {
  components: {
    // ProgressBar
  },
  data() {
    return {
      options: {
        text: {
          color: '#FFFFFF',
          shadowEnable: true,
          shadowColor: '#000000',
          fontSize: 14,
          fontFamily: 'Helvetica',
          dynamicPosition: false,
          hideText: false
        },
        progress: {
          color: '#2dbd2d',
          backgroundColor: '#333333'
        },
        layout: {
          height: 25,
          width: 200,
          verticalTextAlign: 61,
          horizontalTextAlign: 43,
          zeroOffset: 0,
          strokeWidth: 30,
          progressPadding: 0,
          type: 'line'
        }
      },
      percentage: 0,
      showLoading: false
    }
  },

  mounted() {
    this.$root.$on('initiateLoadingModal', () => {
      console.log('U HAVE ENTERED MY DOMAIN')
      this.showLoading = true
      this.percentage = 0
    })
    this.$root.$on('finishLoadingModal', () => {
      this.showLoading = false
      this.percentage = 0
    })
  },

  methods: {}
}
</script>

<style>
.progress-container {
  position: fixed;
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 500000;
  overflow: hidden;
  background-color: rgba(0, 0, 0, 0.4);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font: Bold 16px/20px Proxima Nova;
}

.progress-container {
  display: flex;
  align-items: center;
  width: 220px;
  height: 40px;
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0px 3px 6px #00000029;
}
</style>
