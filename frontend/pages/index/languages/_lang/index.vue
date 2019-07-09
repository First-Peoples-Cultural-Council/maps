<template>
  <div class="language">
    <div
      class="color-row"
      :style="'background-color: ' + getColor(languages)"
      @click="handleColor"
    ></div>
    <LanguageDetailCard
      :color="getColor(languages)"
      :name="this.$route.params.lang"
    ></LanguageDetailCard>
    <h5 class="other-lang-names-title text-uppercase mt-4 ml-2">
      Other Language Names
    </h5>
  </div>
</template>

<script>
import LanguageDetailCard from '@/components/languages/LanguageDetailCard.vue'
import { mapState } from 'vuex'
export default {
  components: {
    LanguageDetailCard
  },
  computed: {
    ...mapState({
      communities: state => state.communities.communities,
      languages: state => state.languages.languages
    })
  },
  mounted() {
    console.log('Store', this.$store.state.languages)
  },
  methods: {
    handleColor() {
      console.log('Color Click')
      console.log(this.communities)
      console.log('Language', this.languages)
      console.log('Language Color', this.languageColor)
    },
    getColor(languages) {
      return languages.find(lang => lang.name === this.$route.params.lang).color
    }
  }
}
</script>

<style>
.color-row {
  background-color: black;
  height: 7px;
}
.other-lang-names-title {
  color: var(--color-gray);
  font-size: 0.8em;
}
</style>
