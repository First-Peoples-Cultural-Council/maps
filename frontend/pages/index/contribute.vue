<template>
  <div>
    <DetailSideBar :width="500">
      <div class="contribute-header pt-3 pb-3">
        <div v-if="languageSelected === null" class="text-center pl-2 pr-2">
          <b-alert
            v-if="drawnFeatures.length === 0"
            show
            variant="danger"
            dismissible
          >
            Please select an area from the map
          </b-alert>
        </div>
        <div v-if="languageSelected === null" class="text-center pl-2 pr-2">
          <b-alert
            v-if="drawnFeatures.length > 1"
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
                name="diiɁdiitidq"
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
        <b-form-input id="traditionalName" type="text"></b-form-input>

        <AudioRecorder class="mt-3"></AudioRecorder>

        <label for="westernName" class="contribute-title-one mt-3 mb-1"
          >Western Name</label
        >
        <b-form-input id="westernName" type="text"></b-form-input>

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
            <b-button block variant="danger">Submit</b-button>
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
      showDismissibleAlert: true,
      content: 'Hello World!',
      languageOptions: [],
      categoryOptions: [],
      languageSelected: null,
      communitySelected: null,
      categorySelected: null,
      files: [null]
    }
  },
  computed: {
    drawnFeatures() {
      return this.$store.state.contribute.drawnFeatures
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
    }
  },
  methods: {
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
