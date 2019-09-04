<template>
  <no-ssr>
    <DetailSideBar>
      <h4>Editing {{ getUserName() }}</h4>

      <label for="westernName" class="contribute-title-one mt-3 mb-1"
        >First Name</label
      >
      <b-form-input v-model="user.first_name" type="text"></b-form-input>

      <label for="westernName" class="contribute-title-one mt-3 mb-1"
        >Last Name</label
      >
      <b-form-input v-model="user.last_name" type="text"></b-form-input>

      <label for="westernName" class="contribute-title-one mt-3 mb-1"
        >About you</label
      >
      <b-form-textarea
        id="textarea"
        v-model="user.bio"
        placeholder="..."
        rows="3"
      ></b-form-textarea>
      <label for="language" class="contribute-title-one mb-1">Language</label>
      <multiselect
        v-model="value"
        placeholder="Search or select a language"
        label="name"
        track-by="id"
        :options="options"
        :multiple="true"
      ></multiselect>

      <label for="community" class="contribute-title-one mb-1">Community</label>
      <b-form-select v-model="community" :options="communities"></b-form-select>
      <b-alert v-if="errors.length" show variant="warning" dismissible>
        <ul>
          <li v-for="err in errors" :key="err">{{ err }}</li>
        </ul>
      </b-alert>
      <button class="btn btn-primary" @click="save()">Save</button>
    </DetailSideBar>
  </no-ssr>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import { getApiUrl, getCookie } from '@/plugins/utils.js'

export default {
  components: {
    DetailSideBar
  },
  data() {
    return {
      errors: [],
      user: {},
      language: null,
      community: null,
      value: [],
      options: []
    }
  },
  computed: {
    languageSet() {
      return this.$store.state.languages.languageSet
    },
    communities() {
      return this.$store.state.communities.communitySet.map(c => {
        return {
          text: c.name,
          value: c.id
        }
      })
    },
    languages() {
      return this.$store.state.languages.languageSet.map(l => {
        return {
          text: l.name,
          value: l.id
        }
      })
    }
  },
  async asyncData({ params, $axios, store }) {
    const now = new Date()
    const user = await $axios.$get(
      getApiUrl(`user/${params.id}/?${now.getTime()}`)
    )

    const language = await $axios.$get(getApiUrl('language/'))
    const options = language.map(l => {
      return {
        name: l.name,
        id: l.id
      }
    })

    return { user, options }
  },

  mounted() {
    console.log('USER', this.user)
  },

  methods: {
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
    },
    async save() {
      this.errors = []
      const data = {
        first_name: this.user.first_name,
        last_name: this.user.last_name,
        bio: this.user.bio,
        language_ids: this.value.map(lang => lang.id),
        community_ids: [this.community]
      }
      try {
        await this.$axios.$patch(getApiUrl(`user/${this.user.id}/`), data, {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        })
      } catch (e) {
        console.warn(e.response)
        this.errors = this.errors.concat(
          Object.entries(e.response.data).map(e => {
            return e[0] + ': ' + e[1]
          })
        )
        return
      }
      this.$router.push({
        path: '/profile/' + this.user.id
      })
    }
  }
}
</script>

<style>
.multiselect__element span {
  word-break: break-all;
  white-space: normal;
}
</style>
