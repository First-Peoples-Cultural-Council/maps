<template>
  <div class="cursor-pointer">
    <MdHeartIcon
      w="30"
      h="30"
      class="heart-place-icon"
      style="fill: #dc3545;"
    ></MdHeartIcon>
  </div>
</template>
<script>
import MdHeartIcon from 'vue-ionicons/dist/md-heart.vue'
export default {
  components: {
    MdHeartIcon
  },
  props: {
    favourited: {
      default: false,
      type: Boolean
    }
  }
}
</script>
<style>
.heart-place-icon:hover {
  transform: scale(1.2);
}

.heart-place-icon svg {
  display: block;
}
</style>
