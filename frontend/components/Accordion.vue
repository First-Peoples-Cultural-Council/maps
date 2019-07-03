<template>
  <div class="accordion">
    <b-collapse id="outer-collapse" visible class="mt-2">
      <b-card>
        <p class="outer-text">
          <span>Collapse contents Here</span>
          <b-button
            v-b-toggle.inner-collapse
            size="sm"
            class="accordion-toggle float-right"
          ></b-button>
        </p>
        <b-collapse id="inner-collapse" class="mt-2">
          <b-card>
            <p>Hello</p>
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
export default {}
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
#inner-collapse .card {
  border: 0;
}
#inner-collapse .card-body {
  padding: 0;
}
</style>
