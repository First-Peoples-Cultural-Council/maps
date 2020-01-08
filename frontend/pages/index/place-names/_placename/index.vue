<template>
  <div class="w-100">
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        Point Of Interest:
        <span class="font-weight-bold">{{ place.name }}</span>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>
    <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
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
          <PlacesDetailCard
            :id="place.id"
            :name="place.name"
            :server="isServer"
            :audio-file="getMediaUrl(audio_obj.audio_file, isServer)"
            :allow-edit="isPlaceOwner()"
            variant="md"
            :delete-place="isPlaceOwner()"
            :status="place.status"
          ></PlacesDetailCard>
        </div>
        <section class="mt-3 ml-4 mr-4 ">
          <div class="mb-2">
            <b-row>
              <b-col xs="6">
                <div
                  v-if="creator"
                  class="cursor-pointer mb-2"
                  @click="handleCreatorClick($event, creator)"
                >
                  <div class="place-sub-header">Uploaded By</div>
                  <div class="place-sub-content">{{ getCreatorName() }}</div>
                </div>
              </b-col>
              <b-col xs="6">
                <div v-if="place.category">
                  <div
                    class="font-08 text-uppercase color-gray place-sub-header"
                  >
                    Category
                  </div>
                  <div class="font-08 place-sub-content">
                    {{ place.category_obj.name }}
                  </div>
                </div>
              </b-col>
            </b-row>
          </div>
          <div>
            <div v-if="place.description">
              <h5 class="font-08 text-uppercase color-gray">Description</h5>
              <p class="font-08">{{ place.description }}</p>
            </div>
          </div>
          <div>
            <b-row no-gutters class="mb-2">
              <b-col xl="6">
                <FlagModal
                  v-if="place.status !== 'FL' && place.status !== 'VE'"
                  :id="place.id"
                  type="placename"
                  title="Report"
                  class="mr-1"
                ></FlagModal>
              </b-col>
              <b-col xl="6">
                <Favourite
                  v-if="isLoggedIn"
                  :id="place.id"
                  :favourited="isFavourited"
                  :favourite="favourite"
                  :num-favourites="place.favourites.length"
                  type="placename"
                  class="ml-1"
                ></Favourite>
              </b-col>
            </b-row>
          </div>
          <div v-if="isPTV" class="mt-2">
            <b-row no-gutters class="mt-2 mb-4">
              <b-col xs="6" class="pr-1">
                <b-button
                  variant="dark"
                  block
                  size="sm"
                  @click="
                    handleApproval($event, place, {
                      verify: true,
                      type: 'placename'
                    })
                  "
                  >Verify</b-button
                >
              </b-col>
              <b-col xs="6" class="pl-1">
                <Reject :id="place.id" type="placename"></Reject>
              </b-col>
            </b-row>
          </div>
          <div v-if="placeCommunity" class="mb-4">
            <CommunityCard
              :name="placeCommunity.name"
              :community="placeCommunity"
              @click.native="
                $router.push({
                  path: `/content/${encodeFPCC(placeCommunity.name)}`
                })
              "
            ></CommunityCard>
          </div>
          <div v-if="placeLanguage" class="mb-4">
            <LanguageCard
              class="hover-left-move"
              :name="placeLanguage.name"
              :color="placeLanguage.color"
              @click.native.prevent="
                $router.push({
                  path: `/languages/${encodeFPCC(placeLanguage.name)}`
                })
              "
            ></LanguageCard>
          </div>

          <div v-if="place.common_name">
            <h5 class="font-08 text-uppercase color-gray">Common Name</h5>
            <p class="font-08">{{ place.common_name }}</p>
          </div>
          <div v-if="place.other_names">
            <h5 class="font-08 text-uppercase color-gray">Other Names</h5>
            <p class="font-08">{{ place.other_names }}</p>
          </div>
          <div v-if="place.community_only">
            <h5 class="font-08 text-uppercase color-gray font-weight-bold">
              Community Only
            </h5>
          </div>
        </section>
        <hr class="sidebar-divider" />
        <Filters class="mb-4"></Filters>
        <section class="m-1 ml-4 mr-4">
          <div v-if="isLoggedIn">
            <UploadTool :id="place.id" type="placename"></UploadTool>
          </div>
        </section>
        <section
          v-if="mediasFiltered && mediasFiltered.length > 0"
          class="mt-4 ml-4 mr-4"
        >
          <h5 class="font-08 text-uppercase color-gray mb-3">
            {{ mediasFiltered.length }} Uploaded Media
          </h5>

          <div
            v-for="media in mediasFiltered"
            :key="'media' + media.id"
            class="mb-4"
          >
            <Media
              :media="media"
              :server="isServer"
              :delete="isMediaCreator(media, user)"
              :community-only="media.community_only"
              type="placename"
            ></Media>
            <div v-if="isMTV(media, mediaToVerify)">
              <b-row no-gutters class="mt-2">
                <b-col xs="6" class="pr-1">
                  <b-button
                    variant="dark"
                    block
                    size="sm"
                    @click="
                      handleApproval($event, media, {
                        verify: true,
                        type: 'media'
                      })
                    "
                    >Verify</b-button
                  >
                </b-col>
                <b-col xs="6" class="pl-1">
                  <Reject :id="media.id" type="media" :media="media"></Reject>
                </b-col>
              </b-row>
            </div>
            <hr class="mb-2" />
          </div>
        </section>
      </div>
    </div>
  </div>
</template>

<script>
import PlacesDetailCard from '@/components/places/PlacesDetailCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import Filters from '@/components/Filters.vue'
import FlagModal from '@/components/Flag/FlagModal.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import Logo from '@/components/Logo.vue'
import UploadTool from '@/components/UploadTool.vue'
import Media from '@/components/Media.vue'
import Favourite from '@/components/Favourite.vue'
import Reject from '@/components/RejectModal.vue'
import LanguageCard from '@/components/languages/LanguageCard.vue'

import {
  getApiUrl,
  encodeFPCC,
  getMediaUrl,
  getGenericFileType,
  makeMarker
} from '@/plugins/utils.js'

export default {
  components: {
    PlacesDetailCard,
    Filters,
    FlagModal,
    CommunityCard,
    Logo,
    UploadTool,
    Media,
    Favourite,
    Reject,
    LanguageCard
  },
  data() {
    return {
      showUploadModal: false,
      closeOverlayContent: false
    }
  },
  watchQuery: true,
  computed: {
    isFavourited() {
      return !!this.favourites.find(f => f.place === this.place.id)
    },
    favourite() {
      return this.favourites.find(f => f.place === this.place.id)
    },
    favourites() {
      return this.$store.state.places.favourites
    },
    placeLanguage() {
      return this.$store.state.places.placeLanguage
    },
    placeCommunity() {
      return this.$store.state.places.placeCommunity
    },
    place() {
      return this.$store.state.places.place
    },
    audio_obj() {
      return this.$store.state.places.audio_obj
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    creator() {
      return this.place.creator
    },
    medias() {
      return this.$store.state.places.medias
    },
    mediaToVerify() {
      return this.$store.state.user.mediaToVerify
    },
    mediasFiltered() {
      return this.medias.filter(m => {
        if (this.isStaff) {
          return true
        }

        if (this.isSuperUser) {
          return true
        }

        if (this.isLangAdmin) {
          return true
        }
        if (!m.creator || this.user.id === m.creator.id) {
          return true
        }

        if (m.status !== 'FL' && m.status !== 'RE') {
          return true
        }

        return false
      })
    },
    isStaff() {
      return this.user.is_staff
    },
    isLangAdmin() {
      return (
        this.$store.state.user.user.administrator_set &&
        this.$store.state.user.user.administrator_set.length > 0
      )
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
    },
    uid() {
      const user = this.$store.state.user.user
      return user && user.id
    },
    isPTV() {
      return this.ptv.find(p => p.id === this.place.id)
    },
    ptv() {
      return this.$store.state.user.placesToVerify
    }
  },
  watch: {
    place(newPlace, oldPlace) {
      if (newPlace !== oldPlace) {
        console.log('new Place', newPlace)
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
  },
  mounted() {
    this.$root.$on('fileUploaded', r => {
      this.$store.dispatch('places/getPlaceMedias', {
        id: this.place.id
      })
      this.$store.dispatch('user/getMediaToVerify')
    })
    console.log('Place', this.place)
  },
  created() {
    this.setupMap(this.geo_place.geometry)
    // We don't always catch language routing updates, so also zoom to language on create.
  },
  methods: {
    isMTV(media, mtv) {
      return mtv.find(m => m.id === media.id)
    },
    isMediaCreator(media, user) {
      return user.id === media.creator
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
.place-sub-header {
  color: #707070;
  font-size: 0.7em;
  text-transform: uppercase;
}
.place-sub-content {
  background-color: #efeae2;
  display: inline-block;
  color: #707070;
  margin: 0;
  font-size: 0.7em;
  padding: 0.1em 0.6em;
  font-weight: bold;
  border-radius: 0.5em;
}
</style>
