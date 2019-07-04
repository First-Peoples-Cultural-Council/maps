<template>
  <div class="accordion">
    <b-collapse id="outer-collapse" visible class="mt-2">
      <b-card>
        <p v-if="!notVisible" class="outer-text">
          <span class="accordion-content"
            >{{ content.substring(0, 35) }}...</span
          >
          <b-button
            v-b-toggle.inner-collapse
            size="sm"
            class="accordion-toggle float-right"
          ></b-button>
        </p>
        <b-collapse id="inner-collapse" v-model="notVisible">
          <b-card>
            <p class="accordion-content">{{ content }}</p>
            <b-button
              v-b-toggle.inner-collapse
              size="sm"
              class="accordion-toggle float-right"
            ></b-button>
          </b-card>
        </b-collapse>
      </b-card>
    </b-collapse>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      notVisible: false
    }
  }
}
</script>

<style>
.card-text span {
  display: inline-block;
  vertical-align: middle;
}
#outer-collapse .outer-text {
  padding: 0;
  margin: 0;
}
#inner-collapse {
  margin: 0;
  padding: 0;
}
#inner-collapse .card {
  border: 0;
}
#inner-collapse .card-body {
  padding: 0;
}
.accordion-content {
  font-size: 0.8em;
}
</style>
