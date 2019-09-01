<template>
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
    <b-form-select v-model="language" :options="languages"></b-form-select>

    <label for="community" class="contribute-title-one mb-1">Community</label>
    <b-form-select v-model="community" :options="communities"></b-form-select>

    <button class="btn btn-primary" @click="save()">Save</button>
  </DetailSideBar>
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
      //   first_name: '',
      //   last_name: '',
      //   bio: '',
      user: {},
      language: null,
      community: null
    }
  },
  computed: {
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
    const user = await $axios.$get(getApiUrl(`user/${params.id}/`))
    return { user }
  },

  mounted() {
    console.log('USER', this.user)
    this.community = this.user.communities[0]
    this.language = this.user.languages[0]
  },

  methods: {
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
    },
    async save() {
      const data = {
        first_name: this.user.first_name,
        last_name: this.user.last_name,
        bio: this.user.bio,
        languages: [this.language],
        communities: [this.community]
      }
      try {
        await this.$axios.$patch(getApiUrl(`user/${this.user.id}/`), data, {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        })
      } catch (e) {
        console.warn(e.response)
      }
      this.$router.push({
        path: '/profile/' + this.user.id
      })
    }
  }
}
</script>

<style scoped></style>
