<template>
  <div>
    <client-only placeholder="Loading...">
      <DetailSideBar :width="500">
        <div class="position-relative pb-3">
          <div
            v-if="drawnFeatures.length === 0 && !place"
            class="required-overlay d-flex align-items-center justify-content-center"
          >
            <b-alert
              v-if="drawnFeatures.length === 0 && !place"
              show
              variant="danger"
            >
              Please draw at least one feature from the map
            </b-alert>
          </div>
          <div v-if="isLoggedIn">
            <div class="contribute-header pt-3 pb-3">
              <div class="text-center pl-2 pr-2">
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
                        :name="
                          community ? community.name : userCommunity[0].name
                        "
                      ></CommunityCard
                    ></b-col>
                  </b-row>
                </div>
              </section>
            </div>
            <section class="pr-3 pl-3">
              <label
                for="traditionalName"
                class="contribute-title-one mt-3 mb-1"
                >Traditional Name (required)</label
              >
              <ToolTip
                content="What is this place called in your language? Enter the name or title in your language, using your alphabet."
              ></ToolTip>
              <b-form-input
                id="traditionalName"
                v-model="tname"
                type="text"
              ></b-form-input>

              <div class="contribute-title-one mt-3 mb-0">
                Pronounciation
                <ToolTip
                  content="How do you pronounce this name? Upload an audio recording of the pronunciation. Say it 3 times in a row, with 1-2 seconds silence in between entries. You don't have to say it English after, but you can."
                ></ToolTip>
              </div>
              <AudioRecorder class="mt-1"></AudioRecorder>

              <label for="westernName" class="contribute-title-one mt-3 mb-1"
                >Common Name</label
              >

              <ToolTip
                content="Is this place already known by a different name? For example in English? Enter that name here so people can find it through that name."
              ></ToolTip>
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

                  <ToolTip
                    content="What would this location be classified as? This will help users find it."
                  ></ToolTip>
                  <b-form-select
                    v-model="categorySelected"
                    :options="categoryOptions"
                  ></b-form-select>
                </b-col>
              </b-row>
              <b-row class="mt-3 mb-1">
                <b-col xl="12">
                  <label for="traditionalName" class="contribute-title-one mb-1"
                    >Community</label
                  >
                  <multiselect
                    v-model="community"
                    placeholder="Select a community"
                    label="name"
                    track-by="id"
                    :options="communities"
                  ></multiselect>
                </b-col>
              </b-row>
              <b-row class="mt-3 mb-4">
                <b-col xl="6" class="d-flex align-items-center">
                  <label
                    class="d-inline-block contribute-title-one"
                    for="community-only"
                    >Community Only?</label
                  >
                  <b-form-checkbox
                    id="community-only"
                    v-model="communityOnly"
                    class="d-inline-block ml-2"
                    name="community-only"
                    value="accepted"
                    unchecked-value="not_accepted"
                  >
                  </b-form-checkbox>
                </b-col>
              </b-row>
              <!-- Text Editor -->

              <h5 class="contribute-title-one mt-3 mb-1">
                Description

                <ToolTip
                  content="Tell people more about this location. You can add history, credit/acknowledgement, links, contact information, notes, etc."
                ></ToolTip>
              </h5>
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
                  href="https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://maps-dev.fpcc.ca"
                  >logged in.</a
                >
              </p>
              <hr />
            </b-alert>
          </div>
        </div>
      </DetailSideBar>
    </client-only>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import AudioRecorder from '@/components/AudioRecorder.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import ToolTip from '@/components/Tooltip.vue'
import {
  getApiUrl,
  getCookie,
  encodeFPCC,
  getLanguagesFromDraw
} from '@/plugins/utils.js'

export default {
  components: {
    DetailSideBar,
    AudioRecorder,
    CommunityCard,
    ToolTip
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
      languageSelectedName: null,
      geom: [],
      communityOnly: false,
      community: null
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
    },
    communities() {
      return this.$store.state.communities.communitySet.map(c => {
        return {
          name: c.name,
          id: c.id
        }
      })
    }
  },
  watch: {
    '$route.query.mode'() {
      this.$eventHub.whenMap(map => {
        if (this.$route.query.mode === 'point') {
          document.querySelector('.mapbox-gl-draw_point').click()
        } else if (this.$route.query.mode === 'polygon') {
          document.querySelector('.mapbox-gl-draw_polygon').click()
        } else if (this.$route.query.mode === 'line') {
          document.querySelector('.mapbox-gl-draw_line').click()
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

  async asyncData({ query, $axios, store, redirect, params }) {
    let data = {}

    if (query.id) {
      const now = new Date()
      const place = await $axios.$get(
        getApiUrl(`placename/${query.id}/?` + now.getTime())
      )

      data = {
        place,
        tname: place.name,
        wname: place.common_name,
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
    console.log('Window', window)
    if (!this.isLoggedIn) {
      window.location =
        'https://fplm.auth.ca-central-1.amazoncognito.com/login?response_type=token&client_id=7rj6th7pknck3tih16ihekk1ik&redirect_uri=https://maps-dev.fpcc.ca'
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
      if (!this.drawnFeatures.length && !this.place) {
        this.errors.push('Please choose a location first.')
        return
      }

      let community_id = null
      if (this.community) {
        community_id = this.community.id
      } else if (this.userCommunity.length > 0) {
        community_id = this.userCommunity[0].id
      }

      const data = {
        name: this.tname,
        common_name: this.wname,
        description: this.content,
        community: community_id,
        language: this.languageSelected,
        category: this.categorySelected,
        community_only: this.communityOnly === 'accepted'
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

      this.$router.push({
        path: '/place-names/' + encodeFPCC(this.tname)
      })

      // window.location = '/place-names/' + encodeFPCC(this.tname)
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('contribute/setIsDrawMode', true)
      vm.$eventHub.whenMap(map => {
        if (vm.$route.query.mode === 'point') {
          document.querySelector('.mapbox-gl-draw_point').click()
        } else if (vm.$route.query.mode === 'polygon') {
          document.querySelector('.mapbox-gl-draw_polygon').click()
        } else if (vm.$route.query.mode === 'line') {
          console.log('It got here')
          document.querySelector('.mapbox-gl-draw_line').click()
        }
      })

      const lat = vm.$route.query.lat
      const lng = vm.$route.query.lng
      if (lat && lng) {
        vm.$eventHub.whenMap(map => {
          map.draw.deleteAll()
          map.draw.add({
            type: 'Point',
            coordinates: [parseFloat(lng), parseFloat(lat)]
          })
          const featuresDrawn = map.draw.getAll()
          const features = featuresDrawn.features
          vm.$store.commit('contribute/setDrawnFeatures', features)
          vm.$store.commit(
            'contribute/setLanguagesInFeature',
            getLanguagesFromDraw(features, vm.languageSet)
          )
        })
      }
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('contribute/setIsDrawMode', false)
    this.$eventHub.whenMap(map => {
      map.draw.changeMode('simple_select')
      map.draw.deleteAll()
    })
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
.required-overlay {
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 50;
  right: 0;
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

.multiselect__element span {
  word-break: break-all;
  white-space: normal;
}
</style>
