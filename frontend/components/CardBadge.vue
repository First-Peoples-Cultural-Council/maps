<template>
  <div class="card-badge">
    <div v-if="type === 'pronounce'">
      <span class="font-07">{{ content }}</span>
      <img src="@/assets/images/pronounce_icon.svg" alt="Pronounce" />
    </div>
    <div v-if="type === 'learn'" @click="handleLearn">
      <span class="font-07">{{ content }}</span>
      <img src="@/assets/images/share_icon.svg" alt="Learn" />
    </div>
    <div v-if="type === 'edit'">
      <span class="font-07">{{ content }}</span>
      <img src="@/assets/images/share_icon.svg" alt="Learn" />
    </div>
    <div v-if="type === 'delete'">
      <span class="font-07">{{ content }}</span>
      <img src="@/assets/images/delete_small_icon.svg" alt="Learn" />
    </div>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: String,
      default: ''
    },
    type: {
      type: String,
      default: 'pronounce'
    },
    link: {
      type: String,
      default: ''
    }
  },
  methods: {
    handleLearn() {
      window.open(`${this.link}`)
    }
  }
}
</script>

<style>
.card-badge {
  line-height: 0;
  background-color: var(--color-gray, #6f6f70);
  display: inline-block;
  color: white;
  border-radius: 1em;
  padding: 0.2em 0.45em;
}
.card-badge span {
  text-transform: uppercase;
  font-weight: Bold;
}
.card-badge span,
.card-badge img {
  display: inline-block;
  vertical-align: middle;
}
</style>
