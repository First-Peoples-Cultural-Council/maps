<template>
  <div class="login-overlay d-flex align-items-center justify-content-center">
    <div class="text-center">
      <b-spinner
        class="d-inline-block"
        type="grow"
        label="Spinning"
      ></b-spinner>
      <h5 class="color-gray font-weight-bold">Logging In..</h5>
    </div>
  </div>
</template>
<script>
export default {}
</script>
<style>
.login-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(255, 255, 255, 0.8);
  z-index: 1000;
}
</style>
