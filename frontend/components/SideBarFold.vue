<template>
  <div class="accordion">
    <b-collapse id="outer-collapse" visible>
      <b-card>
        <div v-b-toggle.inner-collapse>Toggle Inner</div>
        <b-collapse id="inner-collapse" v-model="notVisible">
          <b-card>
            <p class="accordion-content">
              <slot name="cards"></slot>
            </p>
          </b-card>
        </b-collapse>
      </b-card>
    </b-collapse>
  </div>
</template>

<script>
export default {
  data() {
    return {
      visible: false
    }
  }
}
</script>

<style></style>
