<template>
  <div :class="`card-badge ${isPronouncation}`">
    <div v-if="type === 'pronounce'">
      <span class="font-07">{{ content }}</span>
      <img
        class="card-icon"
        src="@/assets/images/pronounce_icon.svg"
        alt="Pronounce"
      />
    </div>
    <div v-if="type === 'learn'" @click="handleLearn">
      <span class="font-07">{{ content }}</span>
      <img class="card-icon" src="@/assets/images/share_icon.svg" alt="Learn" />
    </div>
    <div v-if="type === 'edit'" id="card-edit">
      <span class="font-07">{{ content }}</span>
      <img class="card-icon" src="@/assets/images/edit_small.svg" alt="Learn" />
      <b-tooltip target="card-edit">{{
        `You are the owner of this ${placeholder}. You can edit the info in this
        ${placeholder}.`
      }}</b-tooltip>
    </div>
    <div v-if="type === 'delete'" id="card-delete">
      <span class="font-07">{{ content }}</span>
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
    <div v-if="type === 'owner'" id="card-owned">
      <span class="font-07">{{ content }}</span>
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
    }
  },
  computed: {
    isPronouncation() {
      return this.type === 'pronounce' ? 'pronouce-badge' : ''
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
.pronouce-badge {
  background-color: #b47a2b;
}

.card-icon {
  width: 10px;
  height: 10px;
}
</style>
