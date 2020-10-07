<template>
  <div>
    <div v-if="geo_place" class="w-100">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          GRANTS:
          <span class="font-weight-bold">{{ place.name }}</span>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
        <Logo :logo-alt="1" class="cursor-pointer hide-mobile"></Logo>
        <div>
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
          <div>
            <GrantsDetailCard
              :id="place.id"
              :name="place.name"
              :server="isServer"
              :audio-file="audioFile ? getMediaUrl(audioFile, isServer) : null"
              :allow-edit="isPlaceOwner()"
              variant="md"
              :delete-place="isPlaceOwner()"
              :status="place.status"
            ></GrantsDetailCard>
          </div>

          <hr class="sidebar-divider" />
          <Filters class="mb-4"></Filters>
        </div>
      </div>
    </div>
    <ErrorScreen v-else></ErrorScreen>
  </div>
</template>

<script>
import GrantsDetailCard from '@/components/grants/GrantsDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import Logo from '@/components/Logo.vue'
import ErrorScreen from '@/layouts/error.vue'

import {
  getApiUrl,
  encodeFPCC,
  getMediaUrl,
  getGenericFileType,
  makeMarker
} from '@/plugins/utils.js'

export default {
  components: {
    GrantsDetailCard,
    Filters,
    Logo,
    ErrorScreen
  },
  data() {
    return {
      showUploadModal: false,
      closeOverlayContent: false
    }
  },
  beforeRouteLeave(to, from, next) {
    this.$root.$emit('stopPlaceAudio')
    next()
  },
  watchQuery: true,
  computed: {
    placeLanguage() {
      return this.$store.state.places.placeLanguage
    },
    placeCommunity() {
      return this.$store.state.places.placeCommunity
    },
    place() {
      return this.$store.state.places.place
    },

    isStaff() {
      return this.user.is_staff
    },
    isSuperUser() {
      return this.user.is_superuser
    },
    user() {
      return this.$store.state.user.user
    },
    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    }
  },
  watch: {
    place(newPlace, oldPlace) {
      if (newPlace !== oldPlace) {
        // console.log('new Place', newPlace)
        this.setupMap(newPlace.geom)
      }
    }
  },
  async asyncData({ params, $axios, store }) {
    // TODO: it's better to call /placename_by_name or something (new back-end api)
    const now = new Date()
    const places = (await $axios.$get(
      getApiUrl('placename-geo?timestamp=' + now.getTime())
    )).features
    const geo_place = places.find(a => {
      if (a.properties.name) {
        return encodeFPCC(a.properties.name) === params.placename
      }
    })

    if (geo_place) {
      await Promise.all([
        store.dispatch('places/getPlace', {
          id: geo_place.id
        }),
        store.dispatch('places/getPlaceMedias', {
          id: geo_place.id
        }),
        store.dispatch('user/getPlacesToVerify'),
        store.dispatch('user/getMediaToVerify')
      ])

      if (store.state.user.isLoggedIn) {
        await Promise.all([store.dispatch('places/getFavourites')])
      }

      const isServer = !!process.server
      return {
        geo_place,
        isServer
      }
    }
  },
  mounted() {
    this.$root.$on('fileUploadedPlaces', r => {
      this.$store.dispatch('places/getPlaceMedias', {
        id: this.place.id
      })
      this.$store.dispatch('user/getMediaToVerify')
    })
  },
  created() {
    if (this.geo_place) {
      // We don't always catch language routing updates, so also zoom to language on create.
      this.setupMap(this.geo_place.geometry)
    }
  },
  methods: {
    isMTV(media, mtv) {
      return mtv.find(m => m.id === media.id)
    },
    isMediaCreator(media, user) {
      if (media.creator && user) {
        return user.id === media.creator.id || user.id === media.creator
      }
    },
    handleCreatorClick(e, creator) {
      this.$router.push({
        path: `/profile/${creator.id}`
      })
    },
    encodeFPCC,
    async handleApproval(e, tv, { verify, reject, type }) {
      const data = {
        tv,
        verify,
        reject,
        type
      }
      const result = await this.$store.dispatch('user/approve', data)
      if (result.request && result.request.status === 200) {
        if (type === 'placename') {
          this.$store.dispatch('user/getPlacesToVerify')
          await this.$store.dispatch('places/getPlace', {
            id: this.place.id
          })
        }
        if (type === 'media') {
          this.$store.dispatch('user/getMediaToVerify')
          this.$store.dispatch('places/getPlaceMedias', {
            id: this.place.id
          })
        }
      } else {
        console.error(result)
      }
    },
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
    setupMap(geom) {
      this.$eventHub.whenMap(map => {
        if (this.$route.hash.length <= 1) {
          if (geom.type === 'Point') {
            zoomToPoint({ map, geom, zoom: 13 })
          }
          if (geom.type === 'Polygon') {
            map.fitBounds([geom.coordinates[0][0], geom.coordinates[0][2]], {
              padding: 30
            })
          }
          if (geom.type === 'LineString') {
            const coordinates = geom.coordinates
            const mapboxgl = require('mapbox-gl')
            const bounds = coordinates.reduce(function(bounds, coord) {
              return bounds.extend(coord)
            }, new mapboxgl.LngLatBounds(coordinates[0], coordinates[0]))
            map.fitBounds(bounds, {
              padding: 30
            })
          }
        }

        makeMarker(
          this.geo_place.geometry,
          'poi_icon.svg',
          'place-marker'
        ).addTo(map)
      })
    },
    getCreatorName() {
      if (!this.creator.first_name && !this.creator.last_name) {
        return this.creator.username.split('__')[0]
      }

      if (this.creator.first_name && !this.creator.last_name) {
        return this.creator.first_name
      }

      if (!this.creator.first_name && this.creator.last_name) {
        return this.creator.last_name
      }

      if (this.creator.first_name && this.creator.last_name) {
        return `${this.creator.first_name} ${this.creator.last_name}`
      }
    },
    edit() {
      this.$router.push('/contribute?id=' + this.place.id)
    },
    getMediaUrl,
    getGenericFileType,
    getHeaderTitle() {
      return this.place ? this.place.name : 'Placename page not found'
    }
  },
  head() {
    return {
      title: this.getHeaderTitle(),
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: this.place
            ? this.place.description
            : 'Placename page not found.'
        }
      ]
    }
  }
}
</script>
<style></style>
