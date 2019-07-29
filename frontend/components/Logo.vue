<template>
  <div class="logo" @click.prevent="$root.$emit('resetMap')">
    <img
      src="../assets/images/symbol_text_background.png"
      alt="Language Map Of British Columbia"
    />
  </div>
</template>

<script></script>

<style>
.logo img {
  display: inline-block;
  width: 375px;
  height: auto;
}
</style>
