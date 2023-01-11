<template>
  <div>
    <div v-if="isCurrentUser">
      <!-- <client-only> -->
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          User: <b-badge variant="primary">{{ getUserName() }}</b-badge
          ><b-badge class="ml-2" variant="primary">Expand To Edit</b-badge>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div>
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

          <h4 class="profile-title pt-3 pb-3 color-gray">
            <h4 class="text-uppercase contribute-title mr-2">Edit Profile</h4>
          </h4>

          <section class="pl-3 pr-3">
            <div class="upload-img-container mt-3">
              <div class="upload-img">
                <img
                  v-if="fileSrc === null"
                  class="upload-placeholder"
                  :src="thumbnailPlaceholder()"
                />
                <img v-else :src="fileSrc" />
                <b-button
                  v-if="fileSrc !== null"
                  class="upload-remove"
                  @click="removeImg()"
                  >Remove Image</b-button
                >
              </div>

              <b-form-file
                ref="fileUpload"
                v-model="fileImg"
                class="file-upload-input mt-2"
                :placeholder="filePlaceholder()"
                drop-placeholder="Drop file here..."
                accept="image/*"
              ></b-form-file>
            </div>

            <label
              for="firstname"
              class="
                contribute-title-one
                mt-3
                mb-1
                color-gray
                font-weight-bold font-09
              "
              >First Name</label
            >
            <b-form-input
              id="firstname"
              v-model="currentUser.first_name"
              type="text"
              class="font-08"
            ></b-form-input>

            <label
              for="lastname"
              class="
                contribute-title-one
                mt-3
                mb-1
                color-gray
                font-weight-bold font-09
              "
              >Last Name</label
            >
            <b-form-input
              id="lastname"
              v-model="currentUser.last_name"
              type="text"
              class="font-08"
            ></b-form-input>

            <template v-if="isArtistProfileExist">
              <label
                class="
                  color-gray
                  font-weight-bold
                  contribute-title-one
                  mb-1
                  mt-4
                  font-09
                "
                >Artist Profile</label
              >
              <multiselect
                v-model="artist_profile"
                placeholder="Search or select an Artist Profile"
                label="name"
                track-by="id"
                :options="artistPlacenames"
              ></multiselect>
            </template>

            <label
              class="
                contribute-title-one
                mt-3
                mb-1
                color-gray
                font-weight-bold font-09
              "
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

            <div v-if="isNonBCLanguage" class="website-container mt-3">
              <div>
                <label class="contribute-title-one">Non B.C. Language</label>
              </div>

              <div
                v-for="(lang, index) in languageNonBC"
                :key="index"
                class="site-input-container"
              >
                <b-form-input
                  :id="`language-${lang}`"
                  v-model="lang.value"
                  type="text"
                  placeholder="(ex. Spanish, English, etc.)"
                ></b-form-input>
                <span
                  v-if="
                    (index !== 0 && languageNonBC.length !== 1) ||
                      languageNonBC.length > 1
                  "
                  class="site-btn"
                  @click="removeLanguage(index)"
                  >-</span
                >
                <span
                  v-if="index + 1 === languageNonBC.length"
                  class="site-btn"
                  @click="addLanguage()"
                  >+</span
                >
              </div>
            </div>

            <label
              class="
                color-gray
                font-weight-bold
                contribute-title-one
                mb-1
                mt-4
                font-09
              "
              >Community</label
            >
            <multiselect
              v-model="selectedCommunities"
              placeholder="Search or select a community"
              label="name"
              track-by="id"
              :options="communities"
              :multiple="true"
            ></multiselect>

            <div v-if="isNonBCCommunity" class="website-container mt-3">
              <div>
                <label class="contribute-title-one">Non B.C. Community</label>
              </div>

              <div class="site-input-container">
                <b-form-input
                  v-model="communityNonBC"
                  type="text"
                ></b-form-input>
              </div>
            </div>

            <label
              class="
                contribute-title-one
                mt-3
                color-gray
                font-weight-bold font-09
                mb-2
              "
              >User Description</label
            >

            <section class="pb-2">
              <div id="quill" ref="quill"></div>

              <label
                class="
                  color-gray
                  font-weight-bold
                  contribute-title-one
                  mb-1
                  mt-4
                  font-09
                "
                >Notifications</label
              >
              <b-form-select
                v-model="currentUser.notification_frequency"
                :options="notification_options"
              ></b-form-select>

              <b-alert v-if="errors.length" show variant="warning" dismissible>
                <ul>
                  <li v-for="err in errors" :key="err">{{ err }}</li>
                </ul>
              </b-alert>
              <b-button
                class="btn btn-primary mt-4"
                variant="primary"
                @click="save"
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
          </section>
        </div>
      </div>
      <!-- </client-only> -->
    </div>
    <ErrorScreen v-else></ErrorScreen>
  </div>
</template>

<script>
import { getApiUrl, getCookie, getMediaUrl } from '@/plugins/utils.js'
import ErrorScreen from '@/layouts/error.vue'
import Logo from '@/components/Logo.vue'

const base64Encode = data =>
  new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(data)
    reader.onload = () => resolve(reader.result)
    reader.onerror = error => reject(error)
  })

export default {
  components: {
    Logo,
    ErrorScreen
  },
  data() {
    return {
      fileSrc: null,
      fileImg: null,
      oldUser: {},
      quillEditor: null,
      errors: [],
      currentUser: {},
      selectedCommunities: [],
      language: null,
      languageNonBC: [],
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
      const communitySet = this.$store.state.communities.communitySet.map(c => {
        return {
          name: c.name,
          id: c.id
        }
      })
      const nonBC = { id: 'nonBC', name: 'Non-BC Community (please specify)' }
      communitySet.unshift(nonBC)
      return communitySet
    },
    isArtistPlacenameExist() {
      const isPlacenameFound = this.currentUser.placename_set.filter(
        placename => placename.kind === 'artist'
      )
      return isPlacenameFound.length !== 0
    },
    artistPlacenames() {
      return this.currentUser.placename_set
        .filter(placename => placename.kind === 'artist')
        .map(place => {
          return {
            id: place.id,
            name: place.name
          }
        })
    },
    isArtistProfileExist() {
      return this.artistPlacenames && this.artistPlacenames.length !== 0
    },
    languages() {
      return this.$store.state.languages.languageSet.map(l => {
        return {
          text: l.name,
          value: l.id
        }
      })
    },
    isNonBCLanguage() {
      return this.value.find(val => val.id === 'others')
    },
    isNonBCCommunity() {
      return this.community && this.community.id === 'nonBC'
    },
    isCurrentUser() {
      return this.currentUser.id === this.$store.state.user.user.id
    }
  },
  watch: {
    fileImg(newValue, oldValue) {
      if (newValue !== oldValue) {
        if (newValue) {
          base64Encode(newValue)
            .then(value => {
              this.fileSrc = value
            })
            .catch(() => {
              this.fileSrc = null
            })
        } else {
          this.fileSrc = null
        }
      }
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/set', false)
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('sidebar/set', false)
    next()
  },
  async asyncData({ params, $axios, store }) {
    const now = new Date()
    const data = {}
    const currentUser = await $axios.$get(
      getApiUrl(`user/${params.id}/?${now.getTime()}`)
    )

    const language = await $axios.$get(getApiUrl('language/'))
    const options = language.map(l => {
      return {
        name: l.name,
        id: l.id
      }
    })
    const otherLanguage = { id: 'others', name: 'Others (please specify)' }
    // Add Other options in the Languages
    options.unshift(otherLanguage)

    // Add Others on the selected list if Non B.C Language exists
    let languageValue = []
    let languageNonBC = []
    let artist_profile = {}

    if (currentUser.languages && currentUser.languages.length !== 0) {
      languageValue = currentUser.languages
    }
    if (
      currentUser.non_bc_languages &&
      currentUser.non_bc_languages.length !== 0
    ) {
      languageValue.push(otherLanguage)
      languageNonBC = currentUser.non_bc_languages.map(lang => {
        return {
          value: lang
        }
      })
    }

    if (currentUser.artist_profile) {
      const findProfile = currentUser.placename_set.find(
        placename => placename.id === currentUser.artist_profile
      )
      if (findProfile) {
        artist_profile = {
          id: findProfile.id,
          name: findProfile.name
        }
      }
    }

    return {
      currentUser,
      data,
      options,
      artist_profile,
      value: languageValue,
      languageNonBC,
      community: currentUser.other_community
        ? { id: 'nonBC', name: 'Non-BC Community (please specify)' }
        : currentUser.communities[0],
      communityNonBC: currentUser.other_community
        ? currentUser.other_community
        : '',
      isServer: !!process.server
    }
  },

  mounted() {
    this.fileSrc = this.getMediaUrl(this.currentUser.image)
    this.addLanguage()
    this.initQuill()
  },

  methods: {
    getMediaUrl,
    addLanguage() {
      this.languageNonBC.push({
        value: null
      })
    },
    removeLanguage(index) {
      this.languageNonBC.splice(index, 1)
    },
    filePlaceholder() {
      return this.fileSrc && this.currentUser.image
        ? getMediaUrl(this.fileSrc)
        : 'choose your display image'
    },
    initQuill() {
      require('quill/dist/quill.snow.css')
      const Quill = require('quill')
      const container = this.$refs.quill
      const editor = new Quill(container, {
        theme: 'snow'
      })
      editor.setText(`${this.currentUser.bio}\n`)
      this.quillEditor = editor
    },
    handleCancel() {
      if (this.isServer) {
        this.$router.push({
          path: `/profile/${this.currentUser.id}`
        })
      } else {
        this.$router.go(-1)
      }
    },
    getUserName() {
      return (
        this.currentUser &&
        (`${this.currentUser.first_name} ${this.currentUser.last_name}` ||
          this.currentUser.username.split('__')[0])
      )
    },
    removeImg() {
      this.fileImg = null
      this.fileSrc = null
    },
    thumbnailPlaceholder() {
      return require(`@/assets/images/artist_icon.svg`)
    },
    async save() {
      this.oldUser = this.currentUser
      const headers = {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      }
      this.errors = []
      if (this.quillEditor) {
        this.currentUser.bio = this.quillEditor.getText()
      } else {
        return
      }

      const selectedCommunities = this.selectedCommunities.map(
        community => community.id
      )
      const data = {
        first_name: this.currentUser.first_name,
        last_name: this.currentUser.last_name,
        bio: this.currentUser.bio,
        language_ids: this.value
          .filter(lang => lang.id !== 'others')
          .map(lang => lang.id),
        community_ids: this.isNonBCCommunity ? [] : selectedCommunities,
        other_community: this.isNonBCCommunity ? this.communityNonBC : null,
        artist_profile: this.artist_profile ? this.artist_profile.id : '',
        notification_frequency: this.currentUser.notification_frequency,
        non_bc_languages: this.value.find(lang => lang.id === 'others')
          ? this.languageNonBC
              .filter(lang => lang.value !== null)
              .map(lang => lang.value)
          : []
      }
      try {
        const result = await this.$axios.$patch(
          getApiUrl(`user/${this.currentUser.id}/`),
          data,
          headers
        )

        const imgResult = this.uploadUserDP(this.currentUser.id, headers)

        if (result && imgResult) {
          await this.$store.dispatch('user/setLoggedInUser')
        }
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
        path: '/profile/' + this.currentUser.id
      })
    },
    async uploadUserDP(id, headers) {
      if (this.fileSrc !== this.getMediaUrl(this.currentUser.image)) {
        const formDatas = new FormData()
        formDatas.append('image', this.fileImg === null ? '' : this.fileImg)

        await this.$axios.$patch(`/api/user/${id}/`, formDatas, headers)
      }
    }
  }
}
</script>

<style lang="scss">
.multiselect__element span {
  word-break: break-all;
  white-space: normal;
}

.profile-title {
  background-color: #efeae2;
  padding-top: 3rem;
  padding-bottom: 1rem;
  font-size: 1em;
}

.contribute-title {
  background-color: #591d14;
  color: white;
  font-size: 0.8em;
  padding: 0.65em;
  text-align: right;
  font-weight: bold;
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

.upload-img-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 70%;
  margin: 0 auto;

  .upload-img {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 150px;
    height: 150px;
    border-radius: 100%;
    border: 2px solid rgba(0, 0, 0, 0.125);

    &:hover {
      img {
        opacity: 0.5;
      }
      .upload-remove {
        display: block;
        opacity: 1;
      }
    }
  }
  img {
    width: 150px;
    height: 150px;
    border-radius: 100%;
    object-fit: cover;
  }

  .upload-placeholder {
    width: 90px;
    height: 90px;
    object-fit: contain;
    border-radius: 0;
  }

  .upload-remove {
    display: none;
    position: absolute;
    margin: auto auto;
    font-size: 0.75em;
    display: none;
  }
}

.field-row {
  padding: 0 1em;
}

.website-container {
  display: flex;
  flex-direction: column;
}

.site-input-container {
  display: flex;
  align-items: center;
  margin-bottom: 0.5em;

  & > * {
    margin-right: 0.5em;
  }
}

.site-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 30px;
  height: 30px;
  padding: 1em;
  border: 1px solid rgba(0, 0, 0, 0.125);
  border-radius: 0.25rem;
}
</style>
