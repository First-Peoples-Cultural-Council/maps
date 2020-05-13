<template>
  <div>
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        <b-badge
          v-if="drawnFeatures.length === 0 && !place"
          show
          variant="danger"
          class="p-2"
        >
          Please draw at least one feature from the map
        </b-badge>
        <b-badge v-else show variant="primary" class="p-2">
          Expand to fill out the form
        </b-badge>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>
    <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
      <div
        class="text-center d-none mobile-close"
        :class="{ 'content-mobile': mobileContent }"
        @click="$store.commit('sidebar/setMobileContent', false)"
      >
        <img class="d-inline-block" src="@/assets/images/arrow_down_icon.svg" />
      </div>
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
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
          </div>
          <!-- If Placename Contribution -->
          <section v-if="queryMode === 'placename'" class="pr-3 pl-3">
            <div class="upload-img-container mt-3">
              <div class="upload-img">
                <img
                  v-if="fileImg === null"
                  class="upload-placeholder"
                  src="@/assets/images/user_icon.svg"
                />
                <img v-else :src="fileSrc" />
                <b-button
                  v-if="fileImg !== null"
                  class="upload-remove"
                  @click="removeImg()"
                  >Remove Image</b-button
                >
              </div>

              <b-form-file
                ref="fileUpload"
                v-model="fileImg"
                class="file-upload-input mt-2"
                placeholder="choose a placename image"
                drop-placeholder="Drop file here..."
                accept="image/*"
              ></b-form-file>
            </div>

            <b-row class="field-row mt-3">
              <div>
                <label for="traditionalName" class="contribute-title-one"
                  >Traditional Name (required)</label
                >
                <ToolTip
                  content="What is this place called in your language? Enter the name or title in your language, using your alphabet."
                ></ToolTip>
              </div>

              <b-form-input
                id="traditionalName"
                v-model="traditionalName"
                type="text"
              ></b-form-input>
            </b-row>

            <b-row class="mt-3">
              <b-col xl="6">
                <div>
                  <label for="traditionalName" class="contribute-title-one"
                    >Other Name</label
                  >
                  <ToolTip
                    content="Is this place already known by a different name? For example in English? Enter that name here so people can find it through that name."
                  ></ToolTip>
                </div>

                <b-form-input
                  id="otherName"
                  v-model="otherName"
                  type="text"
                ></b-form-input>
              </b-col>
              <b-col xl="6">
                <label for="traditionalName" class="contribute-title-one mb-1"
                  >Common Name</label
                >

                <ToolTip
                  content="Is this place already known by a different name? For example in English? Enter that name here so people can find it through that name."
                ></ToolTip>
                <b-form-input
                  id="otherName"
                  v-model="otherName"
                  type="text"
                ></b-form-input>
                <!-- <b-form-select
                  v-model="kindSelected"
                  :options="kinds"
                  @change="resetTaxonomy()"
                ></b-form-select> -->
              </b-col>
            </b-row>

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
                  :multiple="true"
                ></multiselect>
              </b-col>
            </b-row>

            <b-row class="field-row">
              <div>
                <label
                  class="contribute-title-one mb-1 color-gray font-weight-bold mt-4 font-09"
                  >Taxonomies</label
                >
                <ToolTip
                  content="What would this placename be classified as? Select tags for your placename. This will help users find it."
                ></ToolTip>
              </div>

              <multiselect
                v-model="taxonomySelected"
                placeholder="Search or Select a Taxonomy"
                label="name"
                track-by="id"
                :options="getTaxonomy"
                :multiple="true"
              ></multiselect>
            </b-row>

            <b-row v-if="queryType !== 'Artist'" class="field-row">
              <div>
                <label
                  class="contribute-title-one mb-1 color-gray font-weight-bold mt-4 font-09"
                  >Contributing Artist</label
                >
                <ToolTip
                  content="Who are the contributing Artist? This will help users know who are involved in this Placename."
                ></ToolTip>
              </div>

              <multiselect
                v-model="artistSelected"
                placeholder="Search or Select an Artist"
                label="name"
                track-by="id"
                :options="listOfArtist"
                :multiple="true"
              ></multiselect>
            </b-row>

            <b-row class="field-row">
              <div>
                <label
                  class="contribute-title-one mb-1 color-gray font-weight-bold mt-4 font-09"
                  >Public Art</label
                >
                <ToolTip
                  content="What are the Public Arts involved in this Placename? This will let users see Public Arts on a Placename."
                ></ToolTip>
              </div>
              <multiselect
                v-model="publicArtSelected"
                placeholder="Search or Select a Public Art"
                label="name"
                track-by="id"
                :options="listOfPublicArt"
                :multiple="true"
              ></multiselect>
            </b-row>

            <template v-if="queryType === 'Artist'">
              <b-row class="mt-3">
                <b-col xl="6">
                  <label for="traditionalName" class="contribute-title-one mb-1"
                    >Email</label
                  >
                  <ToolTip
                    content="If you wish to be contacted personally or for commercial inquiries. This information can be confidential."
                  ></ToolTip>
                  <b-form-input
                    id="email"
                    v-model="email"
                    type="text"
                  ></b-form-input>
                </b-col>
                <b-col xl="6">
                  <label for="traditionalName" class="contribute-title-one mb-1"
                    >Phone</label
                  >

                  <ToolTip
                    content="If you wish to be contacted personally or for commercial inquiries. This information can be confidential."
                  ></ToolTip>
                  <b-form-input
                    id="phone"
                    v-model="phone"
                    type="text"
                  ></b-form-input>
                </b-col>
              </b-row>

              <b-row class="field-row mt-3">
                <div>
                  <label for="traditionalName" class="contribute-title-one"
                    >Location</label
                  >
                  <ToolTip
                    content="If you wish to be visited personally or for commercial inquiries. This information can be confidential."
                  ></ToolTip>
                </div>

                <b-form-input
                  id="location"
                  v-model="location"
                  type="text"
                ></b-form-input>
              </b-row>

              <b-row class="field-row mt-3">
                <div>
                  <label for="traditionalName" class="contribute-title-one"
                    >Copyright</label
                  >
                  <ToolTip
                    content="If you wish your Artworks to be protected, a copyright tag will be included upon showing the Artwork."
                  ></ToolTip>
                </div>

                <b-form-input
                  id="copyright"
                  v-model="copyright"
                  type="text"
                ></b-form-input>
              </b-row>

              <div class="website-container mt-3">
                <div>
                  <label class="contribute-title-one">Website</label>
                  <ToolTip
                    content="If you wish to be contacted through social media for inquiries. This information can be confidential. Add as many as you want."
                  ></ToolTip>
                </div>

                <div
                  v-for="(site, index) in websiteList"
                  :key="index"
                  class="site-input-container"
                >
                  <b-form-select
                    v-model="site.socMedia"
                    :options="socialMedia"
                  ></b-form-select>
                  <b-form-input
                    :id="`site-${index}`"
                    v-model="site.siteValue"
                    type="text"
                  ></b-form-input>
                  <span
                    v-if="
                      (index !== 0 && websiteList.length !== 1) ||
                        websiteList.length > 1
                    "
                    class="site-btn"
                    @click="removeSite()"
                    >-</span
                  >
                  <span
                    v-if="index + 1 === websiteList.length"
                    class="site-btn"
                    @click="addSite()"
                    >+</span
                  >
                </div>
              </div>
            </template>

            <div v-if="queryType === 'Event'">
              <div>
                <label class="contribute-title-one">Event Date/Time</label>
                <ToolTip
                  content="If you wish to be contacted through social media for inquiries. This information can be confidential. Add as many as you want."
                ></ToolTip>
              </div>

              <b-time
                id="event-timepicker"
                v-model="timeValue"
                locale="en"
                @context="onTimeContext"
              ></b-time>
              <b-form-datepicker
                id="event-datepicker"
                v-model="dateValue"
                today-button
                reset-button
                class="mb-2"
              ></b-form-datepicker>
            </div>

            <h5 class="contribute-title-one mt-3 mb-1">
              Description

              <ToolTip
                content="Tell people more about this location. You can add history, credit/acknowledgement, links, contact information, notes, etc."
              ></ToolTip>
            </h5>
            <div id="quill" ref="quill"></div>

            <div class="media-list-container">
              <MediaPreview
                v-for="media in getMediaFiles"
                :key="media.name"
                :file="media"
                :all-media="getMediaFiles"
                class="media-add-btn"
              />

              <div class="media-add-btn " @click="openModal">
                <img
                  class="add-btn"
                  src="@/assets/images/plus_icon.svg"
                  alt="Zoom In"
                />
                Upload Your Art
                <UploadModal :id="1" :type="'placename'"></UploadModal>
              </div>
            </div>

            <b-row class="field-row mt-3">
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
            </b-row>
            <template v-if="queryType === 'Artist'">
              <b-row class="field-row mt-3">
                <label
                  class="d-inline-block contribute-title-one"
                  for="community-only"
                  >Are you interested in commercial inquiries?</label
                >
                <b-form-checkbox
                  id="community-only"
                  v-model="commercialOnly"
                  class="d-inline-block ml-2"
                  name="community-only"
                  value="accepted"
                  unchecked-value="not_accepted"
                >
                </b-form-checkbox>
              </b-row>

              <b-row class="field-row mt-3">
                <label
                  class="d-inline-block contribute-title-one"
                  for="community-only"
                  >Do you wish to be contacted?
                </label>
                <b-form-checkbox
                  id="community-only"
                  v-model="contactedOnly"
                  class="d-inline-block ml-2"
                  name="community-only"
                  value="accepted"
                  unchecked-value="not_accepted"
                >
                </b-form-checkbox>
              </b-row>
            </template>
          </section>

          <!-- Other Contributions -->
          <section v-else class="pr-3 pl-3">
            <label for="traditionalName" class="contribute-title-one mt-3 mb-1"
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
                  :multiple="true"
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
            <div id="quill" ref="quill"></div>

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
              <a :href="getLoginUrl()">logged in.</a>
            </p>
            <hr />
          </b-alert>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import AudioRecorder from '@/components/AudioRecorder.vue'
import ToolTip from '@/components/Tooltip.vue'
import Logo from '@/components/Logo.vue'
import UploadModal from '@/components/UploadModal.vue'
import MediaPreview from '@/components/MediaPreview.vue'
import {
  getApiUrl,
  getCookie,
  encodeFPCC,
  getLanguagesFromDraw
} from '@/plugins/utils.js'

const base64Encode = data =>
  new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(data)
    reader.onload = () => resolve(reader.result)
    reader.onerror = error => reject(error)
  })

export default {
  components: {
    AudioRecorder,
    ToolTip,
    Logo,
    UploadModal,
    MediaPreview
  },
  middleware: 'authenticated',
  data() {
    return {
      socialMedia: [
        'Facebook',
        'Instagram',
        'Youtube',
        'LinkedIn',
        'Twitter',
        'Others'
      ],
      fileSrc: null,
      fileImg: null,
      websiteList: [],
      websiteCount: 1,
      kinds: ['Artist', 'Event', 'Public Art', 'Organization'],
      kindSelected: 'Artist',
      taxonomySelected: [],
      artistSelected: [],
      publicArtSelected: [],

      // Placename fields
      traditionalName: '',
      otherName: '',
      email: '',
      phone: '',
      location: '',
      copyright: '',
      contactedOnly: false,
      commercialOnly: false,
      timeContext: null,
      timeValue: '',
      dateContext: null,
      dateValue: '',

      quillEditor: null,
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
      community:
        this.$store.state.user.user.communities &&
        this.$store.state.user.user.communities[0]
    }
  },

  computed: {
    listOfArtist() {
      return this.$store.state.arts.artsGeo
        .filter(arts => arts.properties.kind === 'artist')
        .map(art => {
          return {
            id: art.id,
            name: art.properties.name
          }
        })
    },
    listOfPublicArt() {
      return this.$store.state.arts.artsGeo
        .filter(arts => arts.properties.kind === 'public_art')
        .map(art => {
          return {
            id: art.id,
            name: art.properties.name
          }
        })
    },
    taxonomies() {
      return this.$store.state.arts.taxonomySearchSet
    },
    getTaxonomyId() {
      return this.taxonomies.find(taxonomy => taxonomy.name === this.queryType)
    },
    getTaxonomy() {
      return this.taxonomies.filter(
        taxonomy =>
          taxonomy.parent === this.getTaxonomyId.id ||
          this.taxonomySelected.some(tax => taxonomy.parent === tax.id)
      )
    },
    queryMode() {
      return this.$route.query.mode
    },
    queryType() {
      return this.$route.query.type
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
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
    isLangAdmin() {
      return this.$store.state.user.user.administrator_set.length > 0
    },
    isStaff() {
      if (!this.$store.state.user.user) {
        return null
      }
      return this.$store.state.user.user.is_staff
    },
    isSuperUser() {
      if (!this.$store.state.user.user) {
        return null
      }
      return this.$store.state.user.user.is_superuser
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
    },
    getMediaFiles() {
      return this.$store.state.file.fileList
    }
  },
  watch: {
    '$route.query.mode'() {
      this.$eventHub.whenMap(map => {
        if (this.$route.query.mode === 'point') {
          this.$root.$emit('mode_change_draw', 'point')
        } else if (this.$route.query.mode === 'polygon') {
          this.$root.$emit('mode_change_draw', 'polygon')
        } else if (this.$route.query.mode === 'line') {
          this.$root.$emit('mode_change_draw', 'line_string')
        } else if (this.$route.query.mode === 'placename') {
          this.$root.$emit('mode_change_draw', 'point')
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
    },
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

  async asyncData({ query, $axios, store, redirect, params }) {
    let data = {}

    if (query.id) {
      const now = new Date()
      const place = await $axios.$get(
        getApiUrl(`placename/${query.id}/?` + now.getTime())
      )
      let community = null
      if (place.community) {
        community = await $axios.$get(
          getApiUrl(`community/${place.community}/?` + now.getTime())
        )
        community = {
          name: community.name,
          id: place.community
        }
      }
      data = {
        place,
        tname: place.name,
        wname: place.common_name,
        content: place.description,
        categorySelected: place.category
      }
      if (community) {
        data.community = community
      }
      if (place.community_only) {
        data.communityOnly = 'accepted'
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
    data.isServer = !!process.server
    return data
  },
  mounted() {
    if (!this.isLoggedIn) {
      window.location = `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    }
    this.initQuill()
    this.addSite()

    this.setDateTimeNow()
  },
  methods: {
    setDateTimeNow() {
      const now = new Date()
      this.timeValue = now.toTimeString().slice(0, 8)
    },
    addSite() {
      this.websiteList.push({
        socMedia: null,
        siteValue: null
      })
    },
    removeSite(index) {
      this.websiteList.splice(index, 1)
    },
    removeImg() {
      this.fileImg = null
    },
    openModal(e) {
      this.$root.$emit('openUploadModal')
    },
    resetTaxonomy() {
      this.taxonomySelected = []
    },
    onTimeContext(ctx) {
      this.timeContext = ctx
    },
    initQuill() {
      require('quill/dist/quill.snow.css')
      const Quill = require('quill')
      const container = this.$refs.quill
      const editor = new Quill(container, {
        theme: 'snow'
      })
      editor.setText(`${this.content}\n`)
      this.quillEditor = editor
    },
    async uploadAudioFile(id, audio, newPlace) {
      const audiodata = new FormData()
      audiodata.append('audio_file', audio)
      audiodata.append(
        'date_recorded',
        new Date().toISOString().split('T', 1)[0]
      )
      audiodata.append('csrftoken', getCookie('csrftoken'))

      try {
        const recording = await this.$axios.$post(
          `/api/recording/`,
          audiodata,
          {
            headers: {
              'X-CSRFToken': getCookie('csrftoken')
            }
          }
        )
        const recording_id = recording.id

        await this.$axios.$patch(
          `/api/placename/${newPlace.id}/`,
          {
            audio: recording_id,
            audio_obj: recording
          },
          {
            headers: {
              'X-CSRFToken': getCookie('csrftoken')
            }
          }
        )
        // console.log('Modified', modified)
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
      }

      let status = 'UN'
      if (this.isLangAdmin || this.isStaff || this.isSuperUser) {
        status = 'UN'
      }
      if (this.quillEditor) {
        this.content = this.quillEditor.getText()
      } else {
        return
      }
      const data = {
        name: this.tname,
        common_name: this.wname,
        description: this.content,
        community: community_id,
        language: this.languageSelected,
        category: this.categorySelected,
        community_only: this.communityOnly === 'accepted',
        status
      }
      if (this.drawnFeatures.length) {
        data.geom = this.drawnFeatures[0].geometry
      }

      const headers = {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      }
      let newPlace = null
      if (this.$route.query.id) {
        id = this.$route.query.id
        try {
          const modified = await this.$axios.$patch(
            `/api/placename/${id}/`,
            data,
            headers
          )
          newPlace = modified
          id = modified.id
        } catch (e) {
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )
          return
        }
      } else {
        try {
          const created = await this.$axios.$post(
            '/api/placename/',
            data,
            headers
          )
          id = created.id
          newPlace = created
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
        await this.uploadAudioFile(id, audio, newPlace)
      }

      this.$eventHub.whenMap(map => {
        map.getSource('places1').setData('/api/placename-geo/')
        this.$router.push({
          path: '/place-names/' + encodeFPCC(this.tname)
        })
      })
    },
    getLoginUrl() {
      return `${process.env.COGNITO_URL}/login?response_type=token&client_id=${process.env.COGNITO_APP_CLIENT_ID}&redirect_uri=${process.env.COGNITO_HOST}`
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/set', true)
      vm.$store.commit('contribute/setIsDrawMode', true)
      if (vm.$route.query.mode === 'point') {
        if (vm.isServer) {
          vm.$store.commit('contribute/setDrawMode', 'point')
        } else {
          vm.$root.$emit('mode_change_draw', 'point')
        }
      } else if (vm.$route.query.mode === 'polygon') {
        if (vm.isServer) {
          vm.$store.commit('contribute/setDrawMode', 'polygon')
        } else {
          vm.$root.$emit('mode_change_draw', 'polygon')
        }
      } else if (vm.$route.query.mode === 'line') {
        if (vm.isServer) {
          vm.$store.commit('contribute/setDrawMode', 'line_string')
        } else {
          vm.$root.$emit('mode_change_draw', 'line_string')
        }
      } else if (vm.$route.query.mode === 'placename') {
        if (vm.isServer) {
          vm.$store.commit('contribute/setDrawMode', 'point')
        } else {
          vm.$root.$emit('mode_change_draw', 'point')
        }
      }

      const lat = vm.$route.query.lat
      const lng = vm.$route.query.lng
      if (vm.$route.query.cname) {
        vm.wname = vm.$route.query.cname
      }
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
    this.$store.commit('sidebar/set', false)
    next()
  }
}
</script>

<style lang="scss">
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

.multiselect__content-wrapper {
  border: 1px solid #00000044;
  box-shadow: 0px 9px 12px #00000044;
}

#quill {
  height: 300px;
  margin-bottom: 1em;
}

@media (max-width: 992px) {
  .required-overlay {
    align-items: stretch !important;
  }
}

/* Placename Form Style */
.field-row {
  padding: 0 1em;
}

.media-list-container {
  display: flex;
  flex-wrap: wrap;
}

.media-add-btn {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  flex: 0 0 auto;
  width: 125px;
  height: 125px;
  background-clip: border-box;
  border: 1px solid rgba(0, 0, 0, 0.125);
  border-radius: 0.25rem;
  margin: 0.25em;

  &:hover {
    cursor: pointer;
    border: 1px solid #f2a798;
    background-color: #fcedea !important;
  }

  img {
    width: 120px;
    height: 120px;
    object-fit: cover;
  }

  .add-btn {
    width: 30px;
    height: 30px;
  }

  .media-remove-btn {
    background-image: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PHN2ZyAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIiAgIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIgICB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiICAgeG1sbnM6aW5rc2NhcGU9Imh0dHA6Ly93d3cuaW5rc2NhcGUub3JnL25hbWVzcGFjZXMvaW5rc2NhcGUiICAgd2lkdGg9IjIwIiAgIGhlaWdodD0iMjAiICAgaWQ9InN2ZzU3MzgiICAgdmVyc2lvbj0iMS4xIiAgIGlua3NjYXBlOnZlcnNpb249IjAuOTErZGV2ZWwrb3N4bWVudSByMTI5MTEiICAgc29kaXBvZGk6ZG9jbmFtZT0idHJhc2guc3ZnIiAgIHZpZXdCb3g9IjAgMCAyMCAyMCI+ICA8ZGVmcyAgICAgaWQ9ImRlZnM1NzQwIiAvPiAgPHNvZGlwb2RpOm5hbWVkdmlldyAgICAgaWQ9ImJhc2UiICAgICBwYWdlY29sb3I9IiNmZmZmZmYiICAgICBib3JkZXJjb2xvcj0iIzY2NjY2NiIgICAgIGJvcmRlcm9wYWNpdHk9IjEuMCIgICAgIGlua3NjYXBlOnBhZ2VvcGFjaXR5PSIwLjAiICAgICBpbmtzY2FwZTpwYWdlc2hhZG93PSIyIiAgICAgaW5rc2NhcGU6em9vbT0iMjIuNjI3NDE3IiAgICAgaW5rc2NhcGU6Y3g9IjEyLjEyODE4NCIgICAgIGlua3NjYXBlOmN5PSI4Ljg0NjEzMDciICAgICBpbmtzY2FwZTpkb2N1bWVudC11bml0cz0icHgiICAgICBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjEiICAgICBzaG93Z3JpZD0idHJ1ZSIgICAgIGlua3NjYXBlOndpbmRvdy13aWR0aD0iMTAzMyIgICAgIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijc1MSIgICAgIGlua3NjYXBlOndpbmRvdy14PSIyMCIgICAgIGlua3NjYXBlOndpbmRvdy15PSIyMyIgICAgIGlua3NjYXBlOndpbmRvdy1tYXhpbWl6ZWQ9IjAiICAgICBpbmtzY2FwZTpzbmFwLXNtb290aC1ub2Rlcz0idHJ1ZSIgICAgIGlua3NjYXBlOm9iamVjdC1ub2Rlcz0idHJ1ZSI+ICAgIDxpbmtzY2FwZTpncmlkICAgICAgIHR5cGU9Inh5Z3JpZCIgICAgICAgaWQ9ImdyaWQ1NzQ2IiAgICAgICBlbXBzcGFjaW5nPSI1IiAgICAgICB2aXNpYmxlPSJ0cnVlIiAgICAgICBlbmFibGVkPSJ0cnVlIiAgICAgICBzbmFwdmlzaWJsZWdyaWRsaW5lc29ubHk9InRydWUiIC8+ICA8L3NvZGlwb2RpOm5hbWVkdmlldz4gIDxtZXRhZGF0YSAgICAgaWQ9Im1ldGFkYXRhNTc0MyI+ICAgIDxyZGY6UkRGPiAgICAgIDxjYzpXb3JrICAgICAgICAgcmRmOmFib3V0PSIiPiAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9zdmcreG1sPC9kYzpmb3JtYXQ+ICAgICAgICA8ZGM6dHlwZSAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vcHVybC5vcmcvZGMvZGNtaXR5cGUvU3RpbGxJbWFnZSIgLz4gICAgICAgIDxkYzp0aXRsZSAvPiAgICAgIDwvY2M6V29yaz4gICAgPC9yZGY6UkRGPiAgPC9tZXRhZGF0YT4gIDxnICAgICBpbmtzY2FwZTpsYWJlbD0iTGF5ZXIgMSIgICAgIGlua3NjYXBlOmdyb3VwbW9kZT0ibGF5ZXIiICAgICBpZD0ibGF5ZXIxIiAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCwtMTAzMi4zNjIyKSI+ICAgIDxwYXRoICAgICAgIHN0eWxlPSJjb2xvcjojMDAwMDAwO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7dmlzaWJpbGl0eTp2aXNpYmxlO2ZpbGw6IzAwMDAwMDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZTtzdHJva2Utd2lkdGg6MC45OTk5OTk4MjttYXJrZXI6bm9uZTtlbmFibGUtYmFja2dyb3VuZDphY2N1bXVsYXRlIiAgICAgICBkPSJtIDEwLDEwMzUuNzc0MyBjIC0wLjc4NDkyNTMsOGUtNCAtMS40OTY4Mzc2LDAuNDYwNiAtMS44MjAzMTI1LDEuMTc1OCBsIC0zLjE3OTY4NzUsMCAtMSwxIDAsMSAxMiwwIDAsLTEgLTEsLTEgLTMuMTc5Njg4LDAgYyAtMC4zMjM0NzUsLTAuNzE1MiAtMS4wMzUzODcsLTEuMTc1IC0xLjgyMDMxMiwtMS4xNzU4IHogbSAtNSw0LjU4NzkgMCw3IGMgMCwxIDEsMiAyLDIgbCA2LDAgYyAxLDAgMiwtMSAyLC0yIGwgMCwtNyAtMiwwIDAsNS41IC0xLjUsMCAwLC01LjUgLTMsMCAwLDUuNSAtMS41LDAgMCwtNS41IHoiICAgICAgIGlkPSJyZWN0MjQzOS03IiAgICAgICBpbmtzY2FwZTpjb25uZWN0b3ItY3VydmF0dXJlPSIwIiAgICAgICBzb2RpcG9kaTpub2RldHlwZXM9ImNjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2MiIC8+ICA8L2c+PC9zdmc+);
    background-color: #fff;
    width: 25px;
    height: 25px;
    position: absolute;
    bottom: 7.5px;
    right: 7.5px;
    border: 1px solid rgba(0, 0, 0, 0.125);
    border-radius: 0.25rem;
    padding: 0.25em;

    &:hover {
      border: 1px solid #f2a798;
      background-color: #fcedea !important;
    }
  }

  .media-other {
    width: 50px;
    height: 50px;
    object-fit: contain;
  }
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
    width: 75px;
    height: 75px;
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

.badge-notification {
  border: 1px solid red;
}
</style>
