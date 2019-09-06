<template>
  <no-ssr>
    <DetailSideBar>
      <template v-slot:badges>
        <h5 class="color-gray font-08 p-0 m-0 d-none header-mobile">
          Point Of Interest:
          <span class="font-weight-bold">{{ place.name }}</span>
        </h5>
      </template>
      <div>
        <div>
          <PlacesDetailCard
            :id="place.id"
            :name="place.name"
            :server="isServer"
            :audio-file="getMediaUrl(place.audio_file, isServer)"
          ></PlacesDetailCard>
          <hr class="sidebar-divider" />
          <Filters class="mb-2"></Filters>
        </div>
        <section class="mt-4 ml-4 mr-4">
          <p v-if="place.creator" class="font-08">
            Uploaded by
            <nuxt-link
              class="color-gray"
              :to="'/profile/' + place.creator.id"
              >{{ getCreatorName() }}</nuxt-link
            >
            <b-button
              v-if="uid === place.creator.id"
              class="btn btn-primary ml-2 font-09"
              size="sm"
              variant="dark"
              @click="edit"
            >
              Edit
            </b-button>
          </p>
        </section>
        <hr v-if="place.creator" />
        <section class="mt-4 ml-4 mr-4">
          <div v-if="place.description">
            <h5 class="font-08 text-uppercase color-gray">Description</h5>
            <p class="font-08">{{ place.description }}</p>
          </div>
          <div v-if="place.category">
            <h5 class="font-08 text-uppercase color-gray">Category</h5>
            <p class="font-08">{{ place.category_obj.name }}</p>
          </div>
          <div v-if="place.community">
            <h5 class="font-08 text-uppercase color-gray">Community</h5>
            <p class="font-08">{{ place.community.name }}</p>
          </div>
          <div v-if="place.common_name">
            <h5 class="font-08 text-uppercase color-gray">Common Name</h5>
            <p class="font-08">{{ place.common_name }}</p>
          </div>
          <div v-if="place.other_names">
            <h5 class="font-08 text-uppercase color-gray">Other Names</h5>
            <p class="font-08">{{ place.other_names }}</p>
          </div>
          <div v-if="place.status">
            <h5 class="font-08 text-uppercase color-gray">Status</h5>
            <p class="font-08">{{ place.status }}</p>
          </div>
        </section>
        <hr />
        <section class="m-1 ml-4 mr-4">
          <div v-if="isLoggedIn">
            <h5 class="mt-4 font-08 text-uppercase color-gray">Upload Media</h5>
            <FileUploader :place-id="place.id"></FileUploader>
          </div>
        </section>

        <section v-if="medias && medias.length > 0" class="mt-4 ml-4 mr-4">
          <h5 class="font-08 text-uppercase color-gray mb-3">
            {{ medias.length }} Uploaded Media
          </h5>

          <ul
            v-for="media in medias"
            :key="'media' + media.id"
            class="m-0 p-0 mb-4 list-style-none up-media-list"
          >
            <li v-if="media.name">
              <span class="font-08 color-gray">Name: </span>
              <span class="font-08">{{ media.name }}</span>
            </li>
            <li v-if="media.description && media.description !== 'null'">
              <span class="font-08 text-uppercase color-gray"
                >Description:</span
              >
              <span class="font-08">{{ media.description }}</span>
            </li>
            <li
              v-if="getGenericFileType(media.file_type) === 'image'"
              class="mt-2 d-flex justify-content-center"
            >
              <img
                :src="getMediaUrl(media.media_file, isServer)"
                :alt="media.name"
                style="max-height: 300px; display: block; width: auto; height: 100%;"
                @click="handleImageClick($event, media)"
              />
            </li>

            <li v-if="getGenericFileType(media.file_type) === 'audio'">
              <audio controls class="uploaded-audio">
                <source
                  :src="getMediaUrl(media.media_file, isServer)"
                  :type="media.file_type"
                />
                <p>
                  Your browser doesn't support HTML5 audio. Here is a
                  <a :href="getMediaUrl(media.media_file, isServer)"
                    >link to the audio</a
                  >
                  instead.
                </p>
              </audio>
            </li>
            <li
              v-if="getGenericFileType(media.file_type) === 'other'"
              class="word-break-all d-flex justify-content-center"
            >
              <b-button
                variant="dark"
                size="sm"
                class="mt-2"
                :href="getMediaUrl(place.audio_file, isServer)"
                >Download</b-button
              >
            </li>
          </ul>
        </section>
      </div>
    </DetailSideBar>
  </no-ssr>
</template>

<script>
import PlacesDetailCard from '@/components/places/PlacesDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'

import {
  getApiUrl,
  encodeFPCC,
  getMediaUrl,
  getGenericFileType
} from '@/plugins/utils.js'
import FileUploader from '@/components/FileUploader.vue'

export default {
  components: {
    PlacesDetailCard,
    Filters,
    DetailSideBar,
    FileUploader
  },
  data() {
    return {}
  },
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    uid() {
      const user = this.$store.state.user.user
      return user && user.id
    }
  },
  watch: {
    place(newPlace, oldPlace) {
      if (newPlace !== oldPlace) this.setupMap()
    }
  },
  async asyncData({ params, $axios, store }) {
    // TODO: it's better to call /placename_by_name or something (new back-end api)
    const now = new Date()
    const places = (await $axios.$get(
      getApiUrl('placename-geo/?timestamp=' + now.getTime())
    )).features
    const geo_place = places.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.placename
      }
    })
    const place = await $axios.$get(
      getApiUrl(`placename/${geo_place.id}/?${now.getTime()}`)
    )

    const isServer = !!process.server
    return {
      geo_place,
      place,
      isServer,
      medias: place.medias
    }
  },
  mounted() {},
  created() {
    this.setupMap()
    this.$root.$on('fileUploaded', r => {
      this.medias.push(r)
    })
    // We don't always catch language routing updates, so also zoom to language on create.
  },
  methods: {
    handleImageClick(e, media) {
      require('basiclightbox/dist/basicLightbox.min.css')
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(`<img src="${getMediaUrl(media.media_file, this.isServer)}">`)
        .show()
    },
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          zoomToPoint({ map, geom: this.geo_place.geometry, zoom: 13 })
        }
        map.setFilter('fn-places-highlighted', ['==', 'name', this.place.name])
      })
    },
    getCreatorName() {
      return (
        this.place.creator.first_name ||
        this.place.creator.username.split('__')[0]
      )
    },
    edit() {
      this.$router.push('/contribute?id=' + this.place.id)
    },
    getMediaUrl,
    getGenericFileType
  },
  head() {
    return {
      title: this.place.name,
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.place.description
        }
      ]
    }
  }
}
</script>
<style>
.up-media-list {
  border: 1px solid rgba(0, 0, 0, 0.15);
  padding: 1em !important;
  border-radius: 0.5em;
}
.uploaded-audio {
  width: 100%;
  margin-top: 1em;
}
</style>
