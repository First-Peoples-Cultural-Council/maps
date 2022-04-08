<template>
  <div>
    <ErrorScreen
      v-if="
        ($route.query.id &&
          (!place ||
            (!isUserPlacenameOwner() && !isUserPlacenameContributer()))) ||
          !isURLQueryValid
      "
    ></ErrorScreen>
    <template v-else>
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
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
          <b-badge
            v-else
            show
            variant="primary"
            class="p-2"
            @click="$store.commit('sidebar/setMobileContent', true)"
          >
            Expand to fill out the form
          </b-badge>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div class="hide-mobile " :class="{ 'content-mobile': mobileContent }">
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
        <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
        <div class="position-relative pb-3 contribute-form-container">
          <div
            v-if="
              (drawnFeatures.length === 0 && !place) ||
                isLoading ||
                !isLoggedIn ||
                notAuthenticatedUser
            "
            class="required-overlay"
          >
            <b-alert v-if="notAuthenticatedUser" show variant="danger">
              <ul>
                <li>
                  You can't proceed, you need to select your default Language,
                  and Community
                </li>
                <li>
                  Please select your community or language by clicking
                  <router-link :to="`/profile/edit/${userDetail.id}`"
                    >here</router-link
                  >
                </li>
              </ul>
            </b-alert>
            <b-alert
              v-else-if="(drawnFeatures.length === 0 && !place) || !isLoggedIn"
              show
              variant="danger"
            >
              <ul>
                <li v-for="text in getRequiredTitle()" :key="text">
                  {{ text }}
                </li>
              </ul>
            </b-alert>
          </div>

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
                {{ `Contribute | ${contributeTitle()}` }}
              </h4>
            </div>
          </div>
          <!-- If Placename Contribution -->
          <section
            v-if="queryMode === 'placename' || queryType"
            id="contribute-main-container"
            class="pr-3 pl-3"
          >
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
                class="file-upload-input mt-2 "
                :placeholder="filePlaceholder()"
                drop-placeholder="Drop file here..."
                accept="image/*"
              ></b-form-file>
            </div>

            <div>
              <b-badge
                v-if="isOrganization"
                variant="danger"
                class="p-2 organization-info"
              >
                If you are an Indigenous organization (minimum 51% Indigenous
                <br />
                owned and led) with roots in or connections to the land known as
                <br />
                British Columbia, we invite you to create an organization <br />
                profile. The First Peoples’ Map of BC showcases British Columbia
                <br />
                Indigenous organization, artists and places.
              </b-badge>
            </div>

            <b-row class="field-row mt-3">
              <div>
                <label for="traditionalName" class="contribute-title-one"
                  >{{ queryType }} Name (required)</label
                >
                <ToolTip
                  :content="
                    `${
                      isArtist
                        ? `What is the name of this Artist? `
                        : `What is this ${queryType} called in your language? Enter the name or title in your language, using your alphabet.`
                    }`
                  "
                ></ToolTip>
              </div>

              <b-form-input
                id="traditionalName"
                v-model="traditionalName"
                type="text"
                :placeholder="placenamePlaceholder()"
                :disabled="
                  (!isArtistProfileFound && isArtist && queryProfile) ||
                    ($route.query.id && traditionalName === userGivenName)
                "
              ></b-form-input>
            </b-row>

            <b-row v-if="isArtist" class="field-row mt-3">
              <div>
                <label for="alternateName" class="contribute-title-one"
                  >Alternate Name</label
                >
                <ToolTip
                  :content="
                    `${
                      isArtist
                        ? 'Does this Artist goes with another name, perhaps a stage name? Write the other name of the artist.'
                        : `Is this ${queryType} already known by a different name? For example in English? Enter that name here so people can find it through that name.`
                    }`
                  "
                ></ToolTip>
              </div>

              <b-form-input
                id="alternateName"
                v-model="alternateName"
                type="text"
                placeholder="(ex. BigJohnDoe)"
              ></b-form-input>
            </b-row>

            <b-row class="mt-3 field-row">
              <div>
                <label
                  v-if="isArtist || isOrganization"
                  for="languageSelector"
                  class="contribute-title-one mb-1"
                >
                  Language (required)</label
                >
                <label
                  v-else
                  for="languageSelector"
                  class="contribute-title-one mb-1"
                >
                  Language</label
                >
                <ToolTip
                  :content="
                    `Choices are 34 languages of BC or ‘other’ to enter your language manually.`
                  "
                ></ToolTip>
              </div>

              <multiselect
                id="languageSelector"
                v-model="languageUserSelected"
                :options="languageList"
                label="name"
                track-by="id"
                placeholder="Select a Language"
              ></multiselect>
            </b-row>

            <b-row
              v-if="
                languageUserSelected && languageUserSelected.id === 'others'
              "
              class="mt-3 field-row"
            >
              <div>
                <label for="otherLanguage" class="contribute-title-one mb-1">
                  Non B.C. Language</label
                >
              </div>

              <multiselect
                v-if="userNonBCLanguage.length !== 0"
                id="otherLanguage"
                v-model="languageNonBC"
                placeholder="Select a Non B.C. Language"
                label="name"
                track-by="id"
                :options="userNonBCLanguage"
              ></multiselect>
              <b-form-input
                v-else
                id="otherLanguage"
                v-model="languageNonBC"
                type="text"
                placeholder="(ex. Michif, Mohawk, etc.)                                                                                                                                                                                                        , English)"
              ></b-form-input>
            </b-row>

            <b-row class="mt-3 field-row">
              <div>
                <label
                  v-if="isArtist || isOrganization"
                  for="communitySelector"
                  class="contribute-title-one mb-1"
                  >Community (required)</label
                >
                <label
                  v-else
                  for="communitySelector"
                  class="contribute-title-one mb-1"
                  >Community</label
                >
                <ToolTip
                  :content="
                    `What community does this ${queryType} belong to? Choices are 204 First Nations of BC or 'other' to enter your community manually.`
                  "
                ></ToolTip>
              </div>

              <multiselect
                id="communitySelector"
                v-model="community"
                placeholder="Select a community"
                label="name"
                track-by="id"
                :options="communities"
              ></multiselect>
            </b-row>

            <b-row
              v-if="community && community.id === 'others'"
              class="mt-3 field-row"
            >
              <div>
                <label for="otherCommunity" class="contribute-title-one mb-1">
                  Other Community</label
                >
              </div>

              <b-form-input
                id="otherCommunity"
                v-model="otherCommunity"
                type="text"
                placeholder="(ex. Capitals, Alberta, etc.)                                                                                                                                                                                                        , English)"
              ></b-form-input>
            </b-row>

            <b-row class="field-row">
              <div>
                <label
                  for="taxonomy-container"
                  class="contribute-title-one mb-1 color-gray font-weight-bold mt-4 font-09"
                  >{{ isArtist ? 'Artistic Discipline' : 'Taxonomies' }}</label
                >
                <ToolTip
                  :content="
                    `What would this ${queryType} be classified as? Select tags for your ${queryType}. This will help users find it.`
                  "
                ></ToolTip>
              </div>

              <multiselect
                id="taxonomy-container"
                v-model="taxonomySelected"
                placeholder="Search or Select a Taxonomy"
                label="name"
                track-by="id"
                :options="getTaxonomy"
                :multiple="true"
              ></multiselect>
              <b-tooltip target="taxonomy-container" placement="top">
                Select as many Taxonomy tags as you want.
              </b-tooltip>
            </b-row>

            <b-row
              v-if="queryType === 'Event' || queryType === 'Public Art'"
              class="field-row"
            >
              <div>
                <label
                  for="contributing-artist"
                  class="contribute-title-one mb-1 color-gray font-weight-bold mt-4 font-09"
                  >Contributing Artist</label
                >
                <ToolTip
                  content="Who are the contributing Artist? This will help users know who are involved in this Placename."
                ></ToolTip>
              </div>

              <multiselect
                id="contributing-artist"
                v-model="artistSelected"
                placeholder="Search or Select an Artist"
                label="name"
                track-by="id"
                :options="listOfArtist"
                :multiple="true"
              ></multiselect>
            </b-row>

            <b-row v-if="queryType === 'Event'" class="field-row">
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

            <b-row class="field-row-group mt-3">
              <div>
                <label for="location" class="contribute-title-one"
                  >Location</label
                >
                <ToolTip
                  :content="
                    `Tell people about the Location of that ${queryType}.`
                  "
                ></ToolTip>
              </div>
              <b-form-group
                v-if="queryType === 'Event'"
                id="location-fieldset"
                description="For Online Events, type a location near you, or leave it blank. "
                label-for="location"
              >
                <b-form-input
                  id="location"
                  v-model="relatedData.location"
                  type="text"
                  placeholder="(ex. Vancouver, Canada)"
                ></b-form-input>
              </b-form-group>
              <b-form-input
                v-else
                id="location"
                v-model="relatedData.location"
                type="text"
                placeholder="(ex. Vancouver, Canada)"
              ></b-form-input>
            </b-row>

            <b-row v-if="queryType === 'Event'" class="field-row mt-3">
              <label
                class="d-inline-block contribute-title-one"
                for="online-event"
                >Is this an Online Event?</label
              >
              <b-form-checkbox
                id="online-event"
                v-model="relatedData.is_online"
                class="d-inline-block ml-2"
                name="online-event"
                value="accepted"
                unchecked-value="not_accepted"
              >
              </b-form-checkbox>
            </b-row>

            <b-row
              v-if="isArtist || queryType === 'Organization'"
              class="field-row mt-3"
            >
              <div>
                <label for="email" class="contribute-title-one mb-1"
                  >Email</label
                >
                <ToolTip
                  content="If you wish to be contacted personally or for commercial inquiries. This information can be confidential."
                ></ToolTip>
              </div>

              <b-form-input
                id="email"
                v-model="relatedData.email"
                type="text"
                placeholder="(ex. johndoe@gmail.com)"
              ></b-form-input>
            </b-row>

            <b-row v-if="queryType === 'Organization'" class="field-row mt-3">
              <div>
                <label
                  for="organizationAccess"
                  class="contribute-title-one mb-1"
                  >Organization Access</label
                >
                <ToolTip
                  content="When is the organization open (E.g. 'open year-round'), or the person available (E.g. 'By appointment only')"
                ></ToolTip>
              </div>

              <b-form-input
                id="organizationAccess"
                v-model="relatedData.organization_access"
                type="text"
                placeholder="(ex. Open year-round or By Appointment only)"
              ></b-form-input>
            </b-row>

            <template v-if="isArtist">
              <b-row class="field-row mt-3">
                <div>
                  <label for="phone" class="contribute-title-one mb-1"
                    >Phone</label
                  >

                  <ToolTip
                    content="If you wish to be contacted personally or for commercial inquiries. This information can be confidential."
                  ></ToolTip>
                </div>

                <b-form-input
                  id="phone"
                  v-model="relatedData.phone"
                  type="text"
                  placeholder="(ex. (604) 509-6995)"
                ></b-form-input>
              </b-row>

              <div class="website-container mt-3">
                <div>
                  <label class="contribute-title-one">Awards</label>
                  <ToolTip
                    content="Show the list of Awards that this Artist have achieved. Add as many as you want."
                  ></ToolTip>
                </div>

                <div
                  v-for="(award, index) in relatedData.awardsList"
                  :key="index"
                  class="site-input-container"
                >
                  <b-form-input
                    :id="`award-${index}`"
                    v-model="award.value"
                    type="text"
                    placeholder="(ex. 2010 Music Awards Pop Album of the Year)"
                  ></b-form-input>
                  <span
                    v-if="
                      (index !== 0 && relatedData.awardsList.length !== 1) ||
                        relatedData.awardsList.length > 1
                    "
                    class="site-btn"
                    @click="removeAward(index)"
                    >-</span
                  >
                  <span
                    v-if="index + 1 === relatedData.awardsList.length"
                    class="site-btn"
                    @click="addAward()"
                    >+</span
                  >
                </div>
              </div>
            </template>

            <b-row v-if="queryType === 'Public Art'" class="field-row mt-3">
              <div>
                <label for="copyright" class="contribute-title-one"
                  >Copyright</label
                >
                <ToolTip
                  content="If you wish your Artwork to be protected, a copyright tag will be included upon showing the Artwork."
                ></ToolTip>
              </div>

              <multiselect
                id="copyright"
                v-model="relatedData.copyright"
                placeholder="Select a Copyright"
                :options="copyrightOptions"
              ></multiselect>
            </b-row>

            <template v-if="queryType !== 'Event'">
              <div class="website-container mt-3">
                <div>
                  <label class="contribute-title-one">Website</label>
                  <ToolTip
                    content="If you wish to be contacted through social media for inquiries. Add as many as you want."
                  ></ToolTip>
                </div>

                <div
                  v-for="(site, index) in relatedData.websiteList"
                  :key="index"
                  class="site-input-container"
                >
                  <b-form-input
                    :id="`site-${index}`"
                    v-model="site.value"
                    type="text"
                    placeholder="(ex. http://facebook.com/johndoe)"
                  ></b-form-input>
                  <span
                    v-if="
                      (index !== 0 && relatedData.websiteList.length !== 1) ||
                        relatedData.websiteList.length > 1
                    "
                    class="site-btn"
                    @click="removeSite(index)"
                    >-</span
                  >
                  <span
                    v-if="index + 1 === relatedData.websiteList.length"
                    class="site-btn"
                    @click="addSite()"
                    >+</span
                  >
                </div>
              </div>
            </template>

            <div v-if="queryType === 'Event'" class="mt-3">
              <div>
                <label class="contribute-title-one">Event Date/Time</label>
                <ToolTip content="Enter the Event Date/Time."></ToolTip>
              </div>
              <b-form-datepicker
                id="event-datepicker"
                v-model="dateValue"
                today-button
                reset-button
                class="mt-2 mb-3"
                placeholder="Please pick a date for the Event"
              ></b-form-datepicker>

              <b-time
                id="event-timepicker"
                v-model="timeValue"
                locale="en"
                @context="onTimeContext"
              ></b-time>
            </div>

            <template v-if="isArtist">
              <b-row class="field-row mt-3">
                <label
                  class="d-inline-block contribute-title-one"
                  for="commercial-only"
                  >Are you interested in commercial inquiries?</label
                >
                <b-form-checkbox
                  id="commercial-only"
                  v-model="relatedData.commercial_only"
                  class="d-inline-block ml-2"
                  name="commercial-only"
                  value="accepted"
                  unchecked-value="not_accepted"
                >
                </b-form-checkbox>
              </b-row>

              <b-row class="field-row mt-3">
                <label
                  class="d-inline-block contribute-title-one"
                  for="contacted-only"
                  >Allow public to see your contact info?
                </label>
                <b-form-checkbox
                  id="contacted-only"
                  v-model="relatedData.contacted_only"
                  class="d-inline-block ml-2"
                  name="contacted-only"
                  value="accepted"
                  unchecked-value="not_accepted"
                >
                </b-form-checkbox>
              </b-row>
            </template>
            <h5 class="contribute-title-one mt-3 mb-1">
              {{
                isArtist
                  ? 'Bio / Artist Statement (required)'
                  : `${queryType} Description (required)`
              }}

              <ToolTip
                :content="
                  `Tell people more about this ${queryType}. You can add history, credit/acknowledgement, links, contact information, notes, etc.`
                "
              ></ToolTip>
            </h5>

            <div id="quill" ref="quill"></div>

            <MediaGallery :media-list="getMediaFiles" :type="queryType">
            </MediaGallery>
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
                <label for="languageSelector" class="contribute-title-one mb-1"
                  >Language</label
                >
                <b-form-select
                  id="languageSelector"
                  v-model="languageSelected"
                  :options="languageOptions"
                ></b-form-select>
              </b-col>
              <b-col xl="6">
                <label for="categorySelector" class="contribute-title-one mb-1"
                  >Category</label
                >
                <ToolTip
                  content="What would this location be classified as? This will help users find it. If you would like more categories added please see the information on the bottom of this page."
                ></ToolTip>
                <b-form-select
                  id="categorySelector"
                  v-model="categorySelected"
                  :options="categoryOptions"
                ></b-form-select>
              </b-col>
            </b-row>
            <b-row class="mt-3 mb-1">
              <b-col xl="12">
                <label for="communitySelect" class="contribute-title-one mb-1"
                  >Community</label
                >
                <multiselect
                  id="communitySelect"
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
              Description (required)

              <ToolTip
                content="Tell people more about this location. You can add history, credit/acknowledgement, links, contact information, notes, etc."
              ></ToolTip>
            </h5>
            <div id="quill" ref="quill"></div>
          </section>

          <template v-if="$route.query.id">
            <b-row class="delete-row-group">
              <div>
                <label for="delete-btn" class="contribute-title-warning"
                  >{{
                    `WARNING: Do you want to delete this ${
                      queryType ? queryType : 'placename'
                    }?`
                  }}
                </label>
                <ToolTip
                  content="By doing this your data will no longer be visible in the maps, and all data will no longer be available."
                ></ToolTip>
              </div>
              <b-button
                name="delete-btn"
                class="delete-btn"
                variant="warning"
                @click="showArchiveModal"
              >
                DELETE
              </b-button>
            </b-row>

            <b-modal v-model="showDeleteModal" hide-header @ok="handleDelete">{{
              `Are you sure you want to Delete "${place.name}"? All data, including medias will be no longer available.`
            }}</b-modal>
          </template>

          <hr />

          <section class="pl-3 pr-3">
            <b-row class="mt-3">
              <b-col xl="12">
                <b-alert
                  v-if="errors.length"
                  show
                  variant="warning"
                  dismissible
                  class="error-list"
                >
                  <ul>
                    <li v-for="err in errors" :key="err">{{ err }}</li>
                  </ul>
                </b-alert>
                <b-button block variant="danger" @click="submitType">{{
                  $route.query.id ? 'Update' : 'Save'
                }}</b-button>
              </b-col>
            </b-row>
          </section>

          <section>
            <div>
              <p class="text-center p-3">
                <br />
                For more categories please see
                <a
                  href="https://apps.gov.bc.ca/pub/bcgnws/featureTypes?outputFormat=pdf"
                  >this list</a
                >
                provided by BC Geographical Names and email us at
                <a
                  :href="
                    'mailto:maps@fpcc.ca?subject=FPCC Map: Categories Request'
                  "
                  >maps@fpcc.ca</a
                >.
              </p>
            </div>
          </section>
        </div>
      </div>
    </template>
  </div>
</template>

<script>
import AudioRecorder from '@/components/AudioRecorder.vue'
import ToolTip from '@/components/Tooltip.vue'
import Logo from '@/components/Logo.vue'
import MediaGallery from '@/components/MediaGallery.vue'
import {
  getApiUrl,
  getCookie,
  encodeFPCC,
  getLanguagesFromDraw,
  getMediaUrl,
  isValidEmail,
  isValidURL
} from '@/plugins/utils.js'
import ErrorScreen from '@/layouts/error.vue'

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
    MediaGallery,
    ErrorScreen
  },
  middleware: 'authenticated',
  data() {
    return {
      fileSrc: null,
      fileImg: null,
      taxonomySelected: [],
      artistSelected: [],
      publicArtSelected: [],
      copyrightOptions: [
        '',
        'Private Copyright',
        'Public Domain',
        'Creative Commons – Attribution',
        'Creative Commons – Attribution Share Alike',
        'Creative Commons – Attribution No Derivatives',
        'Creative Commons – Attribution Non-Commercial',
        'Creative Commons – Non-Commercial Share Alike',
        'Creative Commons – Non-Commercial No Derivatives',
        'Other'
      ],

      // Placename fields
      traditionalName: '',
      alternateName: '',
      timeContext: null,
      timeValue: '',
      dateContext: null,
      dateValue: '',
      isEmailValid: null,

      relatedData: {
        is_online: null,
        email: null,
        phone: null,
        organization_access: null,
        location: null,
        copyright: null,
        websiteList: [],
        awardsList: [],
        contacted_only: null,
        commercial_only: null
      },

      isLoading: false,
      showDeleteModal: false,
      quillEditor: null,
      place: null,
      showDismissibleAlert: true,
      content: '',
      languageSelected: null,
      languageUserSelected: null,
      languageNonBCUser: null,
      languageNonBC: null,
      otherCommunity: null,
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
      if (this.getTaxonomyId) {
        return this.taxonomies.filter(
          taxonomy =>
            taxonomy.parent === this.getTaxonomyId.id ||
            this.taxonomySelected.some(tax => taxonomy.parent === tax.id)
        )
      } else {
        return []
      }
    },
    queryMode() {
      return this.$route.query.mode
    },
    queryType() {
      return this.$route.query.type || 'poi'
    },
    isArtist() {
      return this.queryType === 'Artist'
    },
    isOrganization() {
      return this.queryType === 'Organization'
    },
    queryProfile() {
      return !!this.$route.query.profile
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    categories() {
      // Fetch parent of the taxonomy called Point of Interest
      // to be used for searching its child taxonomies
      const poiTaxonomy = this.taxonomies.find(
        taxonomy => taxonomy.name.toLowerCase() === 'point of interest'
      )
      return this.taxonomies.filter(taxonomy => {
        // Detect taxonomy name with parenthesis, and remove it
        const regExp = /\(([^)]+)\)/
        const matches = regExp.exec(taxonomy.name)
        if (
          taxonomy.parent === poiTaxonomy.id &&
          (matches === null || matches[1] === '1')
        ) {
          // removed parenthesis and the number from name
          taxonomy.name = taxonomy.name.replace(/ *\([^)]*\) */g, '')
          return taxonomy
        }
      })
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
    userDetail() {
      return this.$store.state.user.user
    },
    notAuthenticatedUser() {
      return (
        this.isLoggedIn &&
        this.userDetail.languages &&
        this.userDetail.languages.length === 0 &&
        this.userDetail.communities &&
        this.userDetail.communities.length === 0
      )
    },
    userGivenName() {
      return `${this.userDetail.first_name} ${this.userDetail.last_name}`
    },
    userNonBCLanguage() {
      return this.userDetail.non_bc_languages
        ? this.userDetail.non_bc_languages.map(lang => {
            return {
              id: lang,
              name: lang
            }
          })
        : []
    },
    isArtistProfileFound() {
      if (this.isLoggedIn) {
        const isArtistProfileFound = this.userDetail.placename_set.find(
          placename =>
            placename.kind === 'artist' &&
            this.userDetail.artist_profile &&
            placename.id === this.userDetail.artist_profile
        )
        return isArtistProfileFound
      } else {
        return {}
      }
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
    languageList() {
      const languageSet = this.languageSet
        .map(lang => {
          return {
            id: lang.id,
            name: lang.name
          }
        })
        .sort((a, b) => a.name.localeCompare(b.name))
      languageSet.unshift({
        id: 'others',
        name: 'Others (please specify...)'
      })
      return languageSet
    },
    languagesInFeature() {
      return this.$store.state.contribute.languagesInFeature
    },
    userCommunity() {
      return this.$store.state.user.user.communities
    },
    communities() {
      const communityList = this.$store.state.communities.communitySet.map(
        c => {
          return {
            name: c.name,
            id: c.id
          }
        }
      )
      communityList.unshift({
        id: 'others',
        name: 'Others (please specify...)'
      })

      return communityList
    },
    getMediaFiles() {
      return this.$store.state.file.fileList
    },
    getCookies() {
      return {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      }
    },
    isURLQueryValid() {
      return Object.entries(this.$route.query)
        .filter(query => query[0] !== 'id' && query[0] !== 'profile')
        .map(query => {
          if (query[0] === 'mode') {
            if (
              query[1] === 'point' ||
              query[1] === 'existing' ||
              query[1] === 'polygon' ||
              query[1] === 'line' ||
              query[1] === 'placename'
            ) {
              return true
            } else {
              return false
            }
          } else if (query[0] === 'type') {
            if (
              query[1] === 'Artist' ||
              query[1] === 'Event' ||
              query[1] === 'Public Art' ||
              query[1] === 'Organization'
            ) {
              return true
            } else {
              return false
            }
          } else {
            return false
          }
        })
        .every(result => result === true)
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

    if (query.id && query.type) {
      const now = new Date()
      const place = await $axios.$get(
        getApiUrl(`placename/${query.id}/?` + now.getTime())
      )

      let community = null
      if (place.community) {
        community = await $axios.$get(
          getApiUrl(`community/${place.community.id}/?` + now.getTime())
        )
        community = {
          name: community.name,
          id: place.community
        }
      }

      if (place.other_community && place.other_community !== '') {
        community = {
          id: 'others',
          name: 'Others (please specify...)'
        }
      }

      data = {
        place,
        traditionalName: place.name,
        alternateName: place.other_names,
        content: place.description,
        otherCommunity: place.other_community,
        categorySelected:
          place.taxonomies.length > 0 ? place.taxonomies[0].id : null,
        fileSrc: getMediaUrl(place.image),
        fileImg: null
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
            data.languageUserSelected = { id: language.id, name: language.name }
          }
        } catch (e) {
          console.error(e)
        }
      }

      if (place.non_bc_languages && place.non_bc_languages.length !== 0) {
        data.languageUserSelected = {
          id: 'others',
          name: 'Others (please specify...)'
        }
        data.languageNonBC = place.non_bc_languages[0]
      }

      // Store medias if exist
      if (place.medias.length !== 0) {
        store.commit('file/setNewMediaFiles', place.medias)
      }

      data.relatedData = {
        is_online: null,
        email: null,
        phone: null,
        organization_access: null,
        location: null,
        copyright: null,
        websiteList: [],
        awardsList: [],
        contacted_only: null,
        commercial_only: null
      }

      // Loop to Related data, and check data
      if (place.related_data.length !== 0) {
        place.related_data.map(related => {
          if (related.data_type === 'award') {
            data.relatedData.awardsList.push({
              id: related.id,
              value: related.value,
              isError: null
            })
          } else if (related.data_type === 'website') {
            data.relatedData.websiteList.push({
              id: related.id,
              value: related.value,
              isError: null
            })
          } else if (related.data_type === 'Event Date') {
            const date = new Date(related.value)
            data.dateValue = date.toISOString().slice(0, 10)
            data.timeValue = date.toTimeString().slice(0, 8)
          } else if (related.data_type === 'contacted_only') {
            data.relatedData.contacted_only = related.value.includes('true')
              ? 'accepted'
              : 'not_accepted'
          } else if (related.data_type === 'commercial_only') {
            data.relatedData.commercial_only = !related.value.includes('Not')
              ? 'accepted'
              : 'not_accepted'
          } else if (related.data_type === 'is_online') {
            data.relatedData.is_online = related.value.includes('Online')
              ? 'accepted'
              : 'not_accepted'
          } else {
            data.relatedData[related.data_type] = related.value
          }
        })
      }

      // Loop to Taxonomy, and append tag if exist
      if (place.taxonomies.length !== 0) {
        data.taxonomySelected = place.taxonomies.map(tax => {
          return {
            id: tax.id,
            name: tax.name
          }
        })
      }

      // Loop to Public Art, and append Public art if exist
      if (place.public_arts.length !== 0) {
        data.publicArtSelected = place.public_arts.map(art => {
          return {
            id: art.id,
            name: art.name
          }
        })
      }

      // Loop to Artist, and append if Artist exist
      if (place.artists.length !== 0) {
        data.artistSelected = place.artists.map(artist => {
          return {
            id: artist.id,
            name: artist.name
          }
        })
      }
    } else if (query.id) {
      const now = new Date()
      const place = await $axios.$get(
        getApiUrl(`placename/${query.id}/?` + now.getTime())
      )

      let community = null
      if (place.community) {
        community = await $axios.$get(
          getApiUrl(`community/${place.community.id}/?` + now.getTime())
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
        categorySelected:
          place.taxonomies.length > 0 ? place.taxonomies[0].id : null
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

    data.isServer = !!process.server
    return data
  },
  head() {
    return {
      meta: [
        {
          name: 'google-site-verification',
          content: 'wWf4WAoDmF6R3jjEYapgr3-ymFwS6o-qfLob4WOErRA'
        }
      ]
    }
  },
  mounted() {
    if (this.isLoggedIn) {
      if (
        (this.languageUserSelected === null || this.languageNonBC === null) &&
        !this.place
      ) {
        this.languageUserSelected =
          this.userDetail.languages.length !== 0
            ? this.userDetail.languages[0]
            : null
      }

      if (
        this.userNonBCLanguage.length !== 0 &&
        (this.place &&
          this.place.non_bc_languages &&
          this.place.non_bc_languages.length !== 0)
      ) {
        const previousLang = this.languageNonBC
        this.languageNonBC = { id: previousLang, name: previousLang }
      }

      this.initQuill()
      this.addAward()
      this.addSite()
      // Check if user has artist profile, if not, declare the values
      this.setArtistDetail()
      // Setup event details on form
      this.setEventDetails()

      this.$root.$on('resetValues', () => {
        this.resetData()
      })

      this.$root.$on('updateFileList', () => {
        this.$store.dispatch('file/getUploadMedia', this.place.id)
      })
    } else {
      this.$root.$emit(
        'toggleMessageBox',
        `You need to be logged in first, before proceeding.\n Press "OK" to proceed to Login/Register. `
      )
    }
  },
  methods: {
    isValidEmail,
    isValidURL,
    isQuillSupportedHTML(html) {
      let supported = true
      const supportedTags = [
        'H1',
        'H2',
        'H3',
        'P',
        'STRONG',
        'EM',
        'U',
        'OL',
        'UL',
        'LI',
        'BR'
      ]

      const container = document.createElement('div')
      container.innerHTML = html

      const tags = container.getElementsByTagName('*')
      for (let i = 0; i < tags.length; i++) {
        if (!supportedTags.includes(tags[i].tagName)) {
          supported = false
          break
        }
      }

      return supported
    },
    htmlToText(html) {
      // remove code brakes and tabs
      html = html.replace(/\n/g, '')
      html = html.replace(/\t/g, '')

      // keep html brakes and tabs
      html = html.replace(/<\/td>/g, '\t')
      html = html.replace(/<\/table>/g, '\n')
      html = html.replace(/<\/tr>/g, '\n')
      html = html.replace(/<\/p>/g, '\n')
      html = html.replace(/<\/div>/g, '\n')
      html = html.replace(/<\/h>/g, '\n')
      html = html.replace(/<br>/g, '\n')
      html = html.replace(/<br( )*\/>/g, '\n')

      // parse html into text
      const dom = new DOMParser().parseFromString(
        '<!doctype html><body>' + html,
        'text/html'
      )
      return dom.body.textContent
    },
    isUserPlacenameOwner() {
      if (this.isLoggedIn) {
        const isPlacenameFound = this.userDetail.placename_set.find(
          placename => {
            return placename.id === parseInt(this.$route.query.id)
          }
        )

        return !!isPlacenameFound
      } else {
        return false
      }
    },
    isUserPlacenameContributer() {
      const place = this.place
      const user = this.userDetail
      if (
        place &&
        place.artists &&
        place.artists.length !== 0 &&
        user.placename_set &&
        user.placename_set.length !== 0
      ) {
        const contributerID = place.artists.map(artist => artist.id)
        const isContributer = user.placename_set.some(placename =>
          contributerID.includes(placename.id)
        )

        return isContributer
      } else {
        return false
      }
    },
    showArchiveModal() {
      this.showDeleteModal = !this.showDeleteModal
    },
    async handleDelete(e) {
      e.preventDefault()
      await this.$axios.$delete(`${getApiUrl(`placename/${this.place.id}`)}`, {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      })

      this.$store.dispatch('user/setLoggedInUser')

      this.$root.$emit('refetchArtwork')
      // Delete all Medias in this Placename
      this.place.medias.forEach(async media => {
        await this.$axios.$delete(`${getApiUrl(`media/${media.id}`)}`, {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        })
      })

      this.$store.commit('file/setNewMediaFiles', [])

      this.$router.push({
        path: `/art`
      })
      this.$store.commit('sidebar/setDrawerContent', false)
    },
    resetData() {
      this.fileSrc = null
      this.fileImg = null
      this.taxonomySelected = []
      this.artistSelected = []
      this.traditionalName = ''
      this.alternateName = ''
      this.relatedData.email = null
      this.relatedData.phone = null
      this.relatedData.organization_access = null
      this.relatedData.location = null
      this.relatedData.copyright = null
      this.relatedData.websiteList = []
      this.addSite()
      this.relatedData.awardsList = []
      this.addAward()
      this.content = ''
      this.resetQuill()
      this.relatedData.contacted_only = null
      this.relatedData.commercial_only = null
      this.$store.commit('file/setNewMediaFiles', [])
      this.setArtistDetail()
      this.setEventDetails()

      const contributeContainer = document.querySelector(
        '#contribute-main-container'
      )
      if (contributeContainer) {
        contributeContainer.scrollTop = 0
      }
    },
    setArtistDetail() {
      if (
        this.userDetail &&
        this.queryMode !== 'existing' &&
        !this.isArtistProfileFound &&
        this.isArtist
      ) {
        this.traditionalName = this.userGivenName
        this.relatedData.email = this.userDetail.email
      }

      if (this.isArtist && this.queryMode !== 'existing') {
        this.relatedData.contacted_only = false
        this.relatedData.commercial_only = false
      }
    },
    setEventDetails() {
      if (this.queryType === 'Event' && this.queryMode !== 'existing') {
        this.dateValue = new Date().toISOString().slice(0, 10)
        this.timeValue = new Date().toTimeString().slice(0, 8)
        this.relatedData.is_online = false
      }
    },
    addSite() {
      this.relatedData.websiteList.push({
        value: null,
        isError: null
      })
    },
    removeSite(index) {
      this.relatedData.websiteList.splice(index, 1)
    },
    addAward() {
      this.relatedData.awardsList.push({
        value: null,
        isError: null
      })
    },
    removeAward(index) {
      this.relatedData.awardsList.splice(index, 1)
    },
    removeImg() {
      this.fileImg = null
      this.fileSrc = null
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
    placenamePlaceholder() {
      if (this.isArtist) {
        return '(ex. John Doe)'
      } else if (this.queryType === 'Event') {
        return '(ex. Art Museum Anniversary)'
      } else if (this.queryType === 'Public Art') {
        return '(ex. The Statue of David)'
      } else if (this.isOrganization) {
        return '(ex. Canadian Musuem)'
      }
    },
    getRequiredTitle() {
      const requiredText = []
      if (this.isLoggedIn) {
        requiredText.push('Please draw at least one feature from the map.')

        if (
          this.isLoggedIn &&
          !this.isArtistProfileFound &&
          this.isArtist &&
          this.queryProfile
        ) {
          requiredText.push(
            'You need to create your Artist profile before uploading Artwork.'
          )
        }
      } else {
        requiredText.push('Please Login/Register.')
        requiredText.push('This feature requires you to be logged in.')
      }

      return requiredText
    },
    contributeTitle() {
      if (this.$route.query.id) {
        return `Edit ${this.queryType ? this.queryType : 'Placename'}`
      } else {
        return `${this.queryType ? this.queryType : 'Placename'} Creation`
      }
    },
    thumbnailPlaceholder() {
      if (this.isArtist) {
        return require(`@/assets/images/artist_icon.svg`)
      } else if (this.queryType === 'Event') {
        return require(`@/assets/images/event_icon.svg`)
      } else if (this.queryType === 'Public Art') {
        return require(`@/assets/images/public_art_icon.svg`)
      } else if (this.queryType === 'Organization') {
        return require(`@/assets/images/organization_icon.svg`)
      }
    },
    filePlaceholder() {
      return this.place && this.place.image && this.fileSrc
        ? getMediaUrl(this.fileSrc)
        : 'choose a thumbnail image'
    },
    initQuill() {
      if (document.querySelector('#quill')) {
        require('quill/dist/quill.snow.css')
        const Quill = require('quill')
        const container = this.$refs.quill
        const editor = new Quill(container, {
          theme: 'snow'
        })

        const quillSupported = this.isQuillSupportedHTML(this.content)

        if (quillSupported) {
          // If the format is supported by quill, we allow
          // the editor to retain its original formatting.
          const delta = editor.clipboard.convert(this.content)
          editor.setContents(delta, 'silent')
        } else {
          // We clean the data by wiping out its HTML nature and
          // replacing it with bare text with escape sequences
          editor.setText(this.htmlToText(this.content))
        }

        this.quillEditor = editor
      }
    },
    resetQuill() {
      this.quillEditor.setText('')
    },
    removeQuill() {
      // Removes an element from the document
      const element = document.querySelector('.ql-toolbar')
      element.parentNode.removeChild(element)
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
      } catch (e) {}
    },
    submitType(e) {
      this.isLoading = true
      if (this.queryMode === 'placename' || this.queryType) {
        this.submitPlacename(e)
      } else {
        this.submitContribute(e)
      }
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
        // If there's nothing on the editor, make
        // description blank to force an error
        if (this.quillEditor.getText().trim() === '') {
          this.content = ''
        } else {
          this.content = this.quillEditor.root.innerHTML
        }
      } else {
        return
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

      const formData = new FormData()
      formData.append('name', this.tname)
      formData.append('common_name', this.wname)
      formData.append('description', this.content)
      formData.append('community', community_id)
      formData.append('language', this.languageSelected)
      formData.append('taxonomies', [this.categorySelected])
      formData.append('community_only', this.communityOnly === 'accepted')

      // Append Audio if necessary
      if (audio) {
        formData.append('audio_file', audio)
      }

      if (this.drawnFeatures.length) {
        formData.append('geom', JSON.stringify(this.drawnFeatures[0].geometry))
      }

      if (this.$route.query.id) {
        id = this.$route.query.id

        try {
          const modified = await this.$axios.$patch(
            `/api/placename/${id}/`,
            formData,
            this.getAPIConfig()
          )
          id = modified.id
        } catch (e) {
          this.isLoading = false
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )
          return
        }
      } else {
        // Append status if creation
        formData.append('status', status)

        try {
          const created = await this.$axios.$post(
            '/api/placename/',
            formData,
            this.getAPIConfig()
          )
          id = created.id
        } catch (e) {
          this.isLoading = false
          console.error(Object.entries(e.response.data))
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )

          return
        }
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
    },

    getAPIConfig() {
      return {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        },
        onUploadProgress: progressEvent => {
          const { loaded, total } = progressEvent
          const percentCompleted = Math.round((loaded * 100) / total)
          console.log(`${loaded}KB uploaded of ${total}KB`)

          if (this.callProgressModal) {
            this.callProgressModal(percentCompleted)
          }
        }
      }
    },

    async submitPlacename(e) {
      let id
      this.capitalizeTraditionalName()

      const headers = this.getCookies
      this.errors = []
      if (!this.drawnFeatures.length && !this.place) {
        this.errors.push('Please choose a location first.')
        return
      }

      if ((this.queryType === 'Public Art' || 'Artist') && !this.fileSrc) {
        this.isLoading = false
        this.errors.push('Thumbnail: Please upload an image.')
        return
      }

      let community_id = null
      if (this.community && this.community.id !== 'others') {
        community_id = this.community.id
      }

      let language_id = null
      if (
        this.languageUserSelected &&
        this.languageUserSelected.id !== 'others'
      ) {
        language_id = this.languageUserSelected.id
      }

      let non_bc_language = null
      if (
        this.languageUserSelected &&
        (this.languageUserSelected.id === 'others' && this.languageNonBC)
      ) {
        non_bc_language =
          this.userNonBCLanguage.length !== 0
            ? [this.languageNonBC.name]
            : [this.languageNonBC]
      }

      let status = 'UN'
      if (this.isLangAdmin || this.isStaff || this.isSuperUser) {
        status = 'UN'
      }
      if (this.quillEditor) {
        // If there's nothing on the editor, make
        // description blank to force an error
        if (this.quillEditor.getText().trim() === '') {
          this.content = ''
        } else {
          this.content = this.quillEditor.root.innerHTML
        }
      } else {
        return
      }

      const data = {
        name: this.traditionalName,
        other_names: this.alternateName,
        description: this.content,
        kind:
          this.queryType === 'Public Art'
            ? 'public_art'
            : this.queryType.toLowerCase(),
        community: community_id,
        other_community: this.otherCommunity,
        language: language_id,
        community_only: false,
        non_bc_languages: non_bc_language,
        status
      }

      if (this.drawnFeatures.length) {
        data.geom = this.drawnFeatures[0].geometry
      }

      // if on edit mode
      if (this.$route.query.id) {
        // Append patch data

        id = this.$route.query.id
        const appendedData = { ...data, ...this.getPatchData(id) }
        try {
          const modified = await this.$axios.$patch(
            `/api/placename/${id}/`,
            appendedData,
            this.getAPIConfig()
          )

          if (modified) {
            // Upload Placename Thumbnail if changed
            const thumbnailResult = this.uploadPlacenameThumbnail(id, headers)

            // Upload new medias added
            const mediaResult = this.uploadMedias(id)

            // If finish, redirect to Placename
            if (mediaResult || thumbnailResult) {
              this.redirectToPlacename()
            }
          }
        } catch (e) {
          this.isLoading = false
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )
        }
      } else {
        try {
          const created = await this.$axios.$post(
            '/api/placename/',
            data,
            this.getAPIConfig()
          )
          id = created.id

          // If Placename is successfully created, then PATCH data
          if (created) {
            // Patch placename thumbnail
            this.uploadPlacenameThumbnail(id, headers)

            // Update the User artist's profile if artist creation
            if (this.queryProfile) {
              this.patchUserData(id, headers)
            }

            // PATCH DATA AFTER POSTING
            const data1 = this.getPatchData(id)

            // UPLOAD MEDIAS
            this.uploadMedias(id)

            try {
              const modified = await this.$axios.$patch(
                `/api/placename/${id}/`,
                data1,
                headers
              )

              // If finish, redirect to Placename
              if (modified) {
                this.redirectToPlacename()
              }
            } catch (e) {
              this.isLoading = false
              this.errors = this.errors.concat(
                Object.entries(e.response.data).map(e => {
                  return e[0] + ': ' + e[1]
                })
              )
            }
          }
        } catch (e) {
          this.isLoading = false
          console.error(Object.entries(e.response.data))
          this.errors = this.errors.concat(
            Object.entries(e.response.data).map(e => {
              return e[0] + ': ' + e[1]
            })
          )
        }
      }
    },
    postRelatedData(id) {
      let relatedData = []
      if (this.queryType === 'Event') {
        this.relatedData['Event Date'] = `${this.dateValue} ${this.timeValue}`
      }

      const filteredRelatedData = Object.entries(this.relatedData).filter(
        data => {
          if (data[0] === 'websiteList' || data[0] === 'awardsList') {
            return data[1].length !== 0
          } else if (data[1] === null) {
            return false
          } else if (data[1] === '') {
            return false
          } else if (data[1].length !== 0) {
            return true
          }
        }
      )

      // if on edit mode
      relatedData = filteredRelatedData.map(field => {
        let value = ''
        // Set return Values
        if (field[0] === 'contacted_only') {
          value = field[1] === 'accepted' ? 'contact_true' : 'contacted_false'
        } else if (field[0] === 'commercial_only') {
          value =
            field[1] === 'accepted'
              ? 'Interested in Commercial Inquiry'
              : 'Not interested in Commercial Inquiry'
        } else if (field[0] === 'is_online') {
          value = field[1] === 'accepted' ? 'Online Event' : 'Physical Event'
        } else {
          value = field[1]
        }

        // Checks if related data contains this field
        const isFieldFound = this.place
          ? !!this.place.related_data.find(rel => rel.data_type === field[0])
          : false

        // For existing related data, go inside
        if (this.$route.query.id && isFieldFound) {
          const related = this.place.related_data.find(
            data => data.data_type === field[0]
          )

          const { data_type, label, is_private, placename } = related
          return {
            data_type,
            label,
            value,
            is_private,
            placename
          }
        }
        // For  new related data that doesnt exist in database
        else if (!isFieldFound) {
          // if element is array, get values one by one
          if (field[0] === 'websiteList' || field[0] === 'awardsList') {
            return field[1]
              .filter(data => data.value !== null)
              .map(data => {
                return {
                  data_type: field[0] === 'websiteList' ? 'website' : 'award',
                  label: field[0] === 'websiteList' ? 'Website(s)' : 'Award(s)',
                  value: data.value,
                  is_private: false,
                  placename: id
                }
              })
          } else {
            let is_private = false
            let label = ''

            // Set Privacy values
            if (field[0] === 'contacted_only') {
              is_private = true
            } else {
              is_private = false
            }

            // Set Label Return Values
            if (field[0] === 'organization_access') {
              label = 'Organization Access'
            } else if (field[0] === 'commercial_only') {
              label = 'Commercial Inquiry'
            } else if (field[0] === 'is_online') {
              label = 'Event Type'
            } else {
              label = field[0].charAt(0).toUpperCase() + field[0].slice(1)
            }

            return {
              data_type: field[0],
              label,
              value,
              is_private,
              placename: id
            }
          }
        }
      })

      const listElement = []
      const noListData = relatedData.filter(data => {
        if (Array.isArray(data)) {
          data.map(value => {
            listElement.push(value)
          })
        } else {
          return data
        }
      })

      return [...listElement, ...noListData]
    },
    getPatchData(id) {
      const artistList = this.artistSelected.map(artist => artist.id)
      const publicArt = this.publicArtSelected.map(art => art.id)
      const taxoList = this.taxonomySelected.map(taxo => taxo.id)

      return {
        related_data: this.postRelatedData(id),
        artists: artistList,
        public_arts: publicArt,
        taxonomies: taxoList
      }
    },
    uploadMedias(id) {
      const values = this.getMediaFiles
        .map(media => {
          delete media.id
          delete media.type

          media.placename = id

          return media
        })
        .map(async file => {
          if (file.creator || file.status) {
            // if media has been created by a creator, it means its existing, so do nothing
          } else {
            const formData = new FormData()
            formData.append('name', file.name)
            formData.append('description', file.description)
            formData.append('file_type', file.file_type)
            formData.append('community_only', file.community_only)
            formData.append('placename', id)
            formData.append(
              'is_artwork',
              !!(this.isArtist || this.queryType === 'Public Art')
            )
            if (file.url) {
              formData.append('url', file.url)
            }
            if (file.media_file) {
              formData.append('media_file', file.media_file)
            }

            const dataObj = {
              formData,
              callProgressModal: this.callProgressModal
            }

            try {
              const result = await this.$store.dispatch(
                'file/uploadMedia',
                dataObj
              )
              return result
            } catch (e) {}
          }
        })

      return values
    },
    async uploadPlacenameThumbnail(id, headers) {
      if (
        (this.place && this.fileSrc !== getMediaUrl(this.place.image)) ||
        this.fileImg !== null
      ) {
        const formDatas = new FormData()
        formDatas.append('image', this.fileImg === null ? '' : this.fileImg)

        const result = await this.$axios.$patch(
          `/api/placename/${id}/`,
          formDatas,
          headers
        )

        return result
      }
    },
    async patchUserData(id, header) {
      const data = {
        artist_profile: id
      }
      const result = await this.$axios.$patch(
        getApiUrl(`user/${this.userDetail.id}/`),
        data,
        header
      )
      return result
    },
    redirectToPlacename() {
      if (this.getMediaFiles.length !== 0) {
        this.$root.$emit('refetchArtwork')
      }

      location.href = `/art/${encodeFPCC(this.traditionalName)}`
    },
    callProgressModal(value) {
      this.$root.$emit('initiateLoadingModal', value)
    },

    capitalizeTraditionalName() {
      this.traditionalName = this.traditionalName
        .toLowerCase()
        .split(' ')
        .map(word => word.charAt(0).toUpperCase() + word.slice(1))
        .join(' ')
    }
  },

  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/setDrawerContent', false)
      vm.$root.$emit('resetMap')
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
.error-list ul {
  margin-bottom: 0;
}
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

.contribute-title-warning {
  color: #721c24;
  font-weight: bold;
  font-size: 0.85em;
  padding: 0;
  margin: 0;
}

.contribute-form-container {
  min-height: 92vh;
}
.required-overlay {
  display: flex;
  align-items: flex-start;
  justify-content: center;
  position: absolute;
  top: 0;
  left: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  z-index: 50;
  right: 0;

  & > * {
    position: sticky;
    top: 40vh;
    width: 80%;
    height: fit-content;
  }

  ul {
    padding-left: 0.5em;
    margin-bottom: 0;
  }
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
  font-size: 16px !important;
}

#quill font {
  font-size: 16px !important;
}

#quill p {
  margin-bottom: 16px;
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

.field-row-group {
  display: flex;
  flex-direction: column;
  padding: 0 1em;
}

.delete-row-group {
  display: flex;
  flex-direction: column;
  padding: 0 1.5em;
  margin: 6em 0;

  .delete-btn {
    width: 50%;
    color: #721c24;
  }
}

.form-control::placeholder {
  color: #adadad;
  display: inline-block;
  font-size: 14px;
  margin-bottom: 10px;
  padding-top: 2px;
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

.organization-info {
  display: block;
  background-color: rgba(0, 0, 0, 0.5);
  border-radius: 0.25rem;
  text-align: left;
  margin: 1em;
}
</style>
