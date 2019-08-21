<template>
  <div class="accordion">
    <b-collapse id="outer-collapse" visible>
      <b-card>
        <p
          v-if="!notVisible"
          class="outer-text d-flex align-items-center justify-content-between"
        >
          <span class="accordion-content">
            {{ content.substring(0, 85) }}...
          </span>
          <b-button
            v-b-toggle.inner-collapse
            size="sm"
            class="accordion-toggle"
          >
            <img
              src="@/assets/images/expand_icon.svg"
              alt="Expand"
              class="accordion-toggle-icon"
            />
          </b-button>
        </p>
        <b-collapse id="inner-collapse" v-model="notVisible">
          <b-card>
            <p class="accordion-content">{{ content }}</p>
            <b-button
              v-b-toggle.inner-collapse
              size="sm"
              class="accordion-toggle float-right"
            >
              <img
                src="@/assets/images/contract_icon.svg"
                alt="Contract"
                class="accordion-toggle-icon"
              />
            </b-button>
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
  color: var(--color-darkgray);
}
#outer-collapse > .card > .card-body {
  padding: 0.25rem 0.75rem;
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
  padding-top: 0.25rem;
}
.accordion-content {
  font-size: 0.8em;
  margin: 0;
  padding: 0;
  color: var(--color-darkgray);
}
.accordion-toggle {
  background-color: transparent;
  border: 0;
}
.accordion-toggle:hover {
  background-color: transparent;
  border: 0;
}
.accordion-toggle-icon {
  display: inline-block;
  height: 12px;
  width: 12px;
}
</style>
