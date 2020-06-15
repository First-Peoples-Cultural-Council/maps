<template>
  <div>
    <client-only>
      <div>
        <div
          v-if="!mobileContent"
          class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
        >
          <div>
            User: <b-badge variant="primary">{{ getUserName() }}</b-badge
            ><b-badge class="ml-2" variant="primary">Expand To Edit</b-badge>
          </div>
          <div @click="$store.commit('sidebar/setMobileContent', true)">
            <img src="@/assets/images/arrow_up_icon.svg" />
          </div>
        </div>
        <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
          <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
          <div
            class="text-center d-none mobile-close"
            :class="{ 'content-mobile': mobileContent }"
            @click="$store.commit('sidebar/setMobileContent', false)"
          >
            <img
              class="d-inline-block"
              src="@/assets/images/arrow_down_icon.svg"
            />
          </div>

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
          </section>
        </div>
      </div>
    </client-only>
    <div class="pl-3 pr-3">
      <div id="quill" ref="quill"></div>
    </div>
    <client-only>
      <section class="pl-3 pr-3 pb-2">
        <label
          class="color-gray font-weight-bold contribute-title-one mb-1 mt-4 font-09"
          >Notifications</label
        >
        <b-form-select
          v-model="user.notification_frequency"
          :options="notification_options"
        ></b-form-select>

        <b-alert v-if="errors.length" show variant="warning" dismissible>
          <ul>
            <li v-for="err in errors" :key="err">{{ err }}</li>
          </ul>
        </b-alert>
        <b-button class="btn btn-primary mt-4" variant="primary" @click="save"
          >Save</b-button
        >
        <b-button
          class="btn btn-primary mt-4"
          variant="danger"
          @click="handleCancel"
        >
          Cancel
        </b-button>
      </section>
    </client-only>
  </div>
</template>

<script>
import { getApiUrl, getCookie } from '@/plugins/utils.js'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    Logo
  },
  data() {
    return {
      quillEditor: null,
      errors: [],
      user: {},
      language: null,
      value: [],
      options: [],
      content: '',
      notification_options: [
        { text: 'on', value: 7 },
        { text: 'off', value: -1 }
      ]
    }
  },
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
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
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/set', true)
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('sidebar/set', false)
    next()
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
      community: user.communities[0],
      isServer: !!process.server
    }
  },

  mounted() {
    if (this.user.id !== this.$store.state.user.user.id) {
      window.open(
        'https://auth.firstvoices.com/logout?response_type=token&client_id=tssmvghv2kfepud7tth4olugp&redirect_uri=https://maps.fpcc.ca'
      )
      window.location.reload()
    }
    this.initQuill()
  },

  methods: {
    initQuill() {
      require('quill/dist/quill.snow.css')
      const Quill = require('quill')
      const container = this.$refs.quill
      const editor = new Quill(container, {
        theme: 'snow'
      })
      editor.setText(`${this.user.bio}\n`)
      this.quillEditor = editor
    },
    handleCancel() {
      if (this.isServer) {
        this.$router.push({
          path: `/profile/${this.user.id}`
        })
      } else {
        this.$router.go(-1)
      }
    },
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
    },
    async save() {
      const communityId = this.community ? [this.community.id] : []
      this.errors = []
      if (this.quillEditor) {
        this.user.bio = this.quillEditor.getText()
      } else {
        return
      }
      const data = {
        first_name: this.user.first_name,
        last_name: this.user.last_name,
        bio: this.user.bio,
        language_ids: this.value.map(lang => lang.id),
        community_ids: communityId,
        notification_frequency: this.user.notification_frequency
      }
      try {
        await this.$axios.$patch(getApiUrl(`user/${this.user.id}/`), data, {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        })
        await this.$store.dispatch('user/setLoggedInUser')
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

#quill {
  height: 300px;
  margin-bottom: 1em;
}
</style>
