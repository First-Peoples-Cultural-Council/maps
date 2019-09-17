<template>
  <client-only>
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
            :allow-edit="isPlaceOwner()"
            variant="md"
            :delete-place="isPlaceOwner()"
          ></PlacesDetailCard>
          <hr class="sidebar-divider" />
          <Filters class="mb-2"></Filters>
        </div>
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
            <h5 class="mt-4 font-08 text-uppercase color-gray">
              Upload Media

              <ToolTip
                content="Add relevant audio, images, links to YouTube videos, and PDF files. You can add multiple files."
              ></ToolTip>
            </h5>
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
              <div class="d-flex justify-content-between align-items-center">
                <div>
                  <span class="font-08 color-gray"
                    >Name: {{ media.name }}
                  </span>
                </div>
                <FlagModal :id="media.id"></FlagModal>
              </div>
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
                style="max-width: 100%; display: block; width: auto; height: auto;"
                class="cursor-pointer"
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
  </client-only>
</template>

<script>
import PlacesDetailCard from '@/components/places/PlacesDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import ToolTip from '@/components/Tooltip.vue'
import FlagModal from '@/components/Flag/FlagModal.vue'
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
    FileUploader,
    ToolTip,
    FlagModal
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
    isPlaceOwner() {
      if (this.place.creator) {
        if (this.uid === this.place.creator.id) return true
      }
      return false
    },
    handleImageClick(e, media) {
      require('basiclightbox/dist/basicLightbox.min.css')
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(`<img src="${getMediaUrl(media.media_file, this.isServer)}">`, {
          closable: true
        })
        .show()
    },
    setupMap() {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          if (this.geo_place.geometry.type === 'Point') {
            zoomToPoint({ map, geom: this.geo_place.geometry, zoom: 13 })
          }
          if (this.geo_place.geometry.type === 'Polygon') {
            map.fitBounds(
              [
                this.geo_place.geometry.coordinates[0][0],
                this.geo_place.geometry.coordinates[0][2]
              ],
              { padding: 30 }
            )
          }
          if (this.geo_place.geometry.type === 'LineString') {
            const coordinates = this.geo_place.geometry.coordinates
            const mapboxgl = require('mapbox-gl')
            const bounds = coordinates.reduce(function(bounds, coord) {
              return bounds.extend(coord)
            }, new mapboxgl.LngLatBounds(coordinates[0], coordinates[0]))
            map.fitBounds(bounds, {
              padding: 30
            })
          }
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

.basicLightbox:after {
  content: '';
  position: absolute;
  top: 1.8rem;
  right: 1.8rem;
  width: 2em;
  height: 2em;
  background: url('/close.svg');
  background-size: contain;
  background-repeat: no-repeat;
  cursor: pointer;
}
</style>
