<template>
  <client-only>
    <DetailSideBar :width="500">
      <h4 class="profile-title pl-3 pr-3 color-gray font-weight-bold">
        Edit Profile
      </h4>
      <section class="pl-3 pr-3">
        <label
          for="firstname"
          class="contribute-title-one mt-3 mb-1 color-gray font-weight-bold font-09"
          >First Name</label
        >
        <b-form-input
          id="firstname"
          v-model="user.first_name"
          type="text"
          class="font-08"
        ></b-form-input>

        <label
          for="lastname"
          class="contribute-title-one mt-3 mb-1 color-gray font-weight-bold font-09"
          >Last Name</label
        >
        <b-form-input
          id="lastname"
          v-model="user.last_name"
          type="text"
          class="font-08"
        ></b-form-input>

        <label
          class="contribute-title-one mb-1 color-gray font-weight-bold mt-4 font-09"
          >Languages</label
        >
        <multiselect
          v-model="value"
          placeholder="Search or select a language"
          label="name"
          track-by="id"
          :options="options"
          :multiple="true"
        ></multiselect>

        <label
          class="color-gray font-weight-bold contribute-title-one mb-1 mt-4 font-09"
          >Community</label
        >
        <multiselect
          v-model="community"
          placeholder="Search or select a community"
          label="name"
          track-by="id"
          :options="communities"
        ></multiselect>

        <label
          class="contribute-title-one mt-3 color-gray font-weight-bold font-09 mb-2"
          >User Description</label
        >

        <TuiEditor
          v-model="user.bio"
          mode="wysiwyg"
          :options="{
            hideModeSwitch: true,
            toolbarItems: [
              'heading',
              'bold',
              'italic',
              'strike',
              'hr',
              'quote',
              'ul',
              'ol',
              'indent',
              'outdent',
              'link'
            ]
          }"
          preview-style="vertical"
          height="300px"
        />

        <b-alert v-if="errors.length" show variant="warning" dismissible>
          <ul>
            <li v-for="err in errors" :key="err">{{ err }}</li>
          </ul>
        </b-alert>
        <button class="btn btn-primary mt-4" @click="save()">Save</button>
      </section>
    </DetailSideBar>
  </client-only>
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
      value: [],
      options: [],
      content: ''
    }
  },
  computed: {
    languageSet() {
      return this.$store.state.languages.languageSet
    },
    communities() {
      return this.$store.state.communities.communitySet.map(c => {
        return {
          name: c.name,
          id: c.id
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

    return {
      user,
      options,
      value: user.languages,
      community: user.communities[0]
    }
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
      const communityId = this.community ? [this.community.id] : []
      this.errors = []
      const data = {
        first_name: this.user.first_name,
        last_name: this.user.last_name,
        bio: this.user.bio,
        language_ids: this.value.map(lang => lang.id),
        community_ids: communityId
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

.profile-title {
  background-color: #efeae2;
  padding-top: 3rem;
  padding-bottom: 1rem;
  font-size: 1.2em;
}

.multiselect__tag {
  background-color: #c46157;
}

.multiselect__tag-icon:after {
  color: white;
}

.multiselect__tag-icon:focus,
.multiselect__tag-icon:hover {
  background-color: #91433b;
}

.multiselect__option--highlight {
  background-color: #c46157;
}

.multiselect__element span::after {
  background-color: #c46157;
  color: white;
}
</style>
