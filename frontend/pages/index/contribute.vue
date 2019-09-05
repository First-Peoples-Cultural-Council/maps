<template>
  <div>
    <no-ssr placeholder="Loading...">
      <DetailSideBar :width="500">
        <div v-if="isLoggedIn">
          <div class="contribute-header pt-3 pb-3">
            <div class="text-center pl-2 pr-2">
              <b-alert
                v-if="drawnFeatures.length === 0 && !place"
                show
                variant="danger"
                dismissible
              >
                Please select an area from the map
              </b-alert>
              <b-alert
                v-if="drawnFeatures.length > 1 && !place"
                show
                variant="warning"
                dismissible
              >
                You may only contribute to one area at a time
              </b-alert>
            </div>
            <div>
              <h4 class="text-uppercase contribute-title mr-2">
                Contribute
              </h4>
            </div>
            <section class="pl-2 pr-2">
              <div v-if="userCommunity && userCommunity.length > 0">
                <b-row no-gutters>
                  <b-col xl="6" class="pl-1"
                    ><CommunityCard
                      :go="false"
                      variant="white"
                      icon="small"
                      :name="userCommunity[0].name"
                    ></CommunityCard
                  ></b-col>
                </b-row>
              </div>
            </section>
          </div>
          <section class="pr-3 pl-3">
            <label for="traditionalName" class="contribute-title-one mt-3 mb-1"
              >Traditional Name (required)</label
            >
            <b-form-input
              id="traditionalName"
              v-model="tname"
              type="text"
            ></b-form-input>

            <div class="contribute-title-one mt-3 mb-0">
              Pronounciation
            </div>
            <AudioRecorder class="mt-1"></AudioRecorder>

            <label for="westernName" class="contribute-title-one mt-3 mb-1"
              >Western Name</label
            >
            <b-form-input
              id="westernName"
              v-model="wname"
              type="text"
            ></b-form-input>

            <b-row class="mt-3">
              <b-col xl="6">
                <label for="traditionalName" class="contribute-title-one mb-1"
                  >Language</label
                >
                <b-form-select
                  v-model="languageSelected"
                  :options="languageOptions"
                ></b-form-select>
              </b-col>
              <b-col xl="6">
                <label for="traditionalName" class="contribute-title-one mb-1"
                  >Category</label
                >
                <b-form-select
                  v-model="categorySelected"
                  :options="categoryOptions"
                ></b-form-select>
              </b-col>
            </b-row>
            <!-- Text Editor -->

            <h5 class="contribute-title-one mt-3 mb-1">Description</h5>
            <TuiEditor
              v-model="content"
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

            <!--<h5 class="mt-3 contribute-title-one mb-1">Upload Files</h5>-->
            <!--<MediaUploader></MediaUploader>-->
          </section>

          <hr />

          <section class="pl-3 pr-3">
            <b-row class="mt-3">
              <b-col xl="12">
                <b-alert
                  v-if="errors.length"
                  show
                  variant="warning"
                  dismissible
                >
                  <ul>
                    <li v-for="err in errors" :key="err">{{ err }}</li>
                  </ul>
                </b-alert>
                <b-button block variant="danger" @click="submitContribute"
                  >Submit</b-button
                >
              </b-col>
            </b-row>
          </section>
        </div>
        <div v-else>
          <b-alert show variant="danger m-2 mt-5">
            <h4 class="alert-heading">Please Log In</h4>
            <p>
              This feature requires you to be
              <a
                href="https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://countable.ca"
                >logged in.</a
              >
            </p>
            <hr />
          </b-alert>
        </div>
      </DetailSideBar>
    </no-ssr>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import AudioRecorder from '@/components/AudioRecorder.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import { getApiUrl, getCookie, encodeFPCC } from '@/plugins/utils.js'

export default {
  components: {
    DetailSideBar,
    AudioRecorder,
    CommunityCard
  },
  middleware: 'authenticated',
  data() {
    return {
      place: null,
      showDismissibleAlert: true,
      content: '',
      languageSelected: null,
      communitySelected: null,
      categorySelected: null,
      tname: '',
      wname: '',
      errors: [],
      languageOptions: [],
      languageSelectedName: null
    }
  },

  computed: {
    categoryOptions() {
      return this.categories
        ? this.categories.map(c => {
            return {
              value: c.id,
              text: c.name
            }
          })
        : []
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    files() {
      return this.$store.state.contribute.files
    },
    audioBlob() {
      return this.$store.state.contribute.audioBlob
    },
    audioFile() {
      return this.$store.state.contribute.audioFile
    },

    drawnFeatures() {
      return this.$store.state.contribute.drawnFeatures
    },
    languageSet() {
      return this.$store.state.languages.languageSet
    },
    languagesInFeature() {
      return this.$store.state.contribute.languagesInFeature
    },
    userCommunity() {
      return this.$store.state.user.user.communities
    }
  },
  watch: {
    '$route.query.mode'() {
      this.$eventHub.whenMap(map => {
        if (this.$route.query.mode === 'point') {
          document.querySelector('.mapbox-gl-draw_point').click()
        } else {
          document.querySelector('.mapbox-gl-draw_polygon').click()
        }
      })
    },
    drawnFeatures(drawnFeatures) {
      if (drawnFeatures.length === 0) {
        this.languageSelected = null
      }
    },
    languagesInFeature(newLangs) {
      this.languageOptions = this.languagesInFeature.map(lang => {
        return {
          value: lang.id,
          text: lang.name
        }
      })
    },
    languageSelected(newSelection) {
      const langSelected = this.languageOptions.find(
        lang => newSelection === lang.value
      )

      if (langSelected) {
        this.languageSelectedName = langSelected.text
      }
    }
  },

  async asyncData({ query, $axios, store, redirect }) {
    let data = {}
    if (query.id) {
      const now = new Date()
      const place = await $axios.$get(
        getApiUrl(`placename/${query.id}/?` + now.getTime())
      )

      data = {
        place,
        tname: place.name,
        wname: place.western_name,
        content: place.description,
        categorySelected: place.category
      }
      if (place.language) {
        try {
          const language = await $axios.$get(
            getApiUrl(`language/${place.language}`)
          )
          if (language) {
            data.languageSelected = language.id
            data.languageOptions = [{ value: language.id, text: language.name }]
            data.languageSelectedName = language.name
          }
        } catch (e) {
          console.error(e)
        }
      }
    }
    data.categories = await $axios.$get(getApiUrl(`placenamecategory/`))
    return data
  },
  mounted() {
    if (!this.isLoggedIn) {
      window.location =
        'https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://countable.ca'
    }
  },
  methods: {
    async uploadAudioFile(id, audio) {
      const data = new FormData()
      data.append('audio_file', audio)
      data.append('_method', 'PATCH')
      data.append('csrftoken', getCookie('csrftoken'))

      try {
        await this.$axios.$patch(`/api/placename/${id}/`, data, {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        })
      } catch (e) {
        // for now assume this always succeeds.
      }
    },
    uploadFiles(id) {
      this.files.map(async file => {
        const data = new FormData()
        data.append('name', file.name)
        data.append('description', '')
        data.append('file_type', file.type)
        data.append('placename', id)
        data.append('media_file', file)
        data.append('csrftoken', getCookie('csrftoken'))
        data.append('_method', 'POST')
        try {
          await this.$axios.$post(`/api/media/`, data)
        } catch (e) {}
      })
    },
    async submitContribute(e) {
      let id
      this.errors = []
      if (!this.drawnFeatures.length && !this.place.geom) {
        this.errors.push('Please choose a location first.')
        return
      }

      const data = {
        name: this.tname,
        western_name: this.wname,
        description: this.content,
        community: this.userCommunity && this.userCommunity.id,
        language: this.languageSelected,
        category: this.categorySelected
      }
      if (this.drawnFeatures.length) data.geom = this.drawnFeatures[0].geometry

      if (this.$route.query.id) {
        id = this.$route.query.id
        try {
          const modified = await this.$axios.$patch(
            `/api/placename/${id}/`,
            data,
            {
              headers: {
                'X-CSRFToken': getCookie('csrftoken')
              }
            }
          )
          id = modified.id
        } catch (e) {
          console.warn('ERROR in update', e.response)
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )
          return
        }
      } else {
        try {
          const created = await this.$axios.$post('/api/placename/', data, {
            headers: {
              'X-CSRFToken': getCookie('csrftoken')
            }
          })
          id = created.id
        } catch (e) {
          console.error(Object.entries(e.response.data))
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )
          return
        }
      }
      let audio = null
      if (this.audioBlob && this.audioFile) {
        return
      } else if (this.audioBlob) {
        audio = new File([this.audioBlob], `${this.tname}`, {
          type: 'multipart/form-data'
        })
      } else {
        audio = this.audioFile
      }

      if (audio) {
        await this.uploadAudioFile(id, audio)
      }

      window.location = '/place-names/' + encodeFPCC(this.tname)
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('contribute/setIsDrawMode', true)
      vm.$eventHub.whenMap(map => {
        if (vm.$route.query.mode === 'point') {
          document.querySelector('.mapbox-gl-draw_point').click()
        } else {
          document.querySelector('.mapbox-gl-draw_polygon').click()
        }
      })
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('contribute/setIsDrawMode', false)
    next()
  }
}
</script>

<style>
.contribute-header {
  background-color: #f4f0eb;
}
.contribute-title {
  background-color: #591d14;
  color: white;
  font-size: 0.8em;
  padding: 0.65em;
  text-align: right;
  font-weight: bold;
}
.contribute-title-one {
  color: #707070;
  font-weight: bold;
  font-size: 0.85em;
  padding: 0;
  margin: 0;
}
</style>
