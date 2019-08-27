<template>
  <div>
    <DetailSideBar :width="500">
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
        </div>
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
            You are contributing to
          </h4>
        </div>
        <section class="pl-2 pr-2">
          <b-row no-gutters>
            <b-col xl="6" class="pr-1"
              ><LanguageCard
                :go="false"
                variant="white"
                icon="small"
                :name="languageSelected ? languageSelected : 'None'"
              ></LanguageCard
            ></b-col>
            <b-col xl="6" class="pl-1"
              ><CommunityCard
                :go="false"
                variant="white"
                icon="small"
                name="diiɁdiitidq"
              ></CommunityCard
            ></b-col>
          </b-row>
        </section>
      </div>
      <section class="pr-3 pl-3">
        <label for="traditionalName" class="contribute-title-one mt-3 mb-1"
          >Traditional Name</label
        >
        <b-form-input
          id="traditionalName"
          v-model="tname"
          type="text"
        ></b-form-input>

        <AudioRecorder class="mt-3"></AudioRecorder>

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
            hideModeSwitch: true
          }"
          preview-style="vertical"
          height="300px"
        />
        <h5 class="mt-3 contribute-title-one mb-1">Upload Files</h5>
        <MediaUploader></MediaUploader>
      </section>

      <hr />

      <section class="pl-3 pr-3">
        <b-row no-gutters>
          <b-col xl="6" class="pr-2">
            <b-button block variant="secondary">Preview</b-button>
          </b-col>
          <b-col xl="6" class="pl-2">
            <b-button block variant="light">Cancel</b-button>
          </b-col>
        </b-row>
        <b-row class="mt-3">
          <b-col xl="12">
            <b-button block variant="danger" @click="submitContribute"
              >Submit</b-button
            >
          </b-col>
        </b-row>
      </section>
    </DetailSideBar>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import AudioRecorder from '@/components/AudioRecorder.vue'
import MediaUploader from '@/components/MediaUploader.vue'
import { getApiUrl } from '@/plugins/utils.js'

export default {
  components: {
    DetailSideBar,
    LanguageCard,
    CommunityCard,
    AudioRecorder,
    MediaUploader
  },
  data() {
    return {
      place: null,
      showDismissibleAlert: true,
      content: '',
      categoryOptions: [],
      languageSelected: null,
      communitySelected: null,
      categorySelected: null,
      files: [null],
      tname: '',
      wname: ''
    }
  },

  computed: {
    audio() {
      return this.$store.state.contribute.audio
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
    languageOptions() {
      return this.languagesInFeature.map(lang => {
        return {
          value: lang.name,
          text: lang.name
        }
      })
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
    }
  },

  async asyncData({ query, $axios, store }) {
    console.log('Params', query)
    if (query.id) {
      const place = await $axios.$get(getApiUrl(`placename/${query.id}/`))
      console.log('Place', place)
      return {
        place,
        tname: place.name
      }
    }

    return {}
  },
  methods: {
    async uploadAudioFile(id) {
      const data = new FormData()
      console.log('Detected audio', this.audio)
      data.append('audio_file', this.audio)
      data.append('_method', 'PATCH')
      const result = await this.$axios.$patch(`/api/placename/${id}/`, data)
      console.log('Result Upload', result)
    },
    async submitContribute(e) {
      const data = {
        name: this.tname,
        western_name: this.wname,
        description: this.content,
        point: this.drawnFeatures[0].geometry,
        community_only: null,
        status: null,
        other_names: this.tname
      }
      console.log('Data', data)
      const { id } = await this.$axios.$post('/api/placename/', data)
      this.uploadAudioFile(id)

      /*



      */
    },
    callback(msg) {
      console.debug('Event: ', msg)
    },
    handleFileSelect(e, file) {
      if (!file) {
        this.files.push(null)
      }
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
