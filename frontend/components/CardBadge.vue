<template>
  <div class="card-badge" :style="'background-color:' + color">
    <div v-if="type === 'pronounce'">
      <span>{{ content }}</span>
      <img
        class="card-icon"
        src="@/assets/images/pronounce_icon.svg"
        alt="Pronounce"
      />
    </div>
    <div v-else-if="type === 'learn'" @click="handleLearn">
      <span>{{ content }}</span>
      <img class="card-icon" src="@/assets/images/share_icon.svg" alt="Learn" />
    </div>
    <div v-else-if="type === 'edit'" id="card-edit">
      <span>{{ content }}</span>
      <img class="card-icon" src="@/assets/images/edit_small.svg" alt="Learn" />
      <b-tooltip target="card-edit">{{
        `You are the owner of this ${placeholder}. You can edit the info in this
        ${placeholder}.`
      }}</b-tooltip>
    </div>
    <div v-else-if="type === 'delete'" id="card-delete">
      <span>{{ content }}</span>
      <img
        class="card-icon"
        src="@/assets/images/delete_small_icon.svg"
        alt="Learn"
      />
      <b-tooltip target="card-delete">{{
        `You are the owner of this ${placeholder}. You can delete this
        ${placeholder}.`
      }}</b-tooltip>
    </div>
    <div v-else-if="type === 'owner'" id="card-owned">
      <span>{{ content }}</span>
      <img
        class="card-icon"
        src="@/assets/images/heart_liked.svg"
        alt="Learn"
      />
      <b-tooltip target="card-owned"
        >{{ `You are the owner of this ${placeholder} ` }}.</b-tooltip
      >
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
    },
    placeholder: {
      type: String,
      default: ''
    },
    color: {
      type: String,
      default: '#b47a2b'
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
  padding: 3.5px 7.5px;
}
.card-badge span {
  text-transform: uppercase;
  font-weight: Bold;
  font-size: 12px;
}
.card-badge span,
.card-badge img {
  display: inline-block;
  vertical-align: middle;
}
.card-icon {
  width: 10px;
  height: 10px;
}
</style>
