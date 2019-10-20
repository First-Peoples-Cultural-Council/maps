<template>
  <div>
    <label
      class="font-08 d-inline-block contribute-title-one"
      for="community-only"
      >Community Only?</label
    >
    <b-form-checkbox
      id="community-only"
      v-model="commonly"
      class="d-inline-block ml-2"
      name="community-only"
      value="accepted"
      unchecked-value="not_accepted"
      @input="$emit('update:commonly', commonly)"
    >
    </b-form-checkbox>
  </div>
</template>
<script>
export default {
  data() {
    return {
      commonly: null
    }
  }
}
</script>
<style></style>
