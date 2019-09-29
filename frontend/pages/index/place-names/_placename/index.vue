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
            :audio-file="getMediaUrl(place.audio_file, isServer)"
            :allow-edit="isPlaceOwner()"
            variant="md"
            :delete-place="isPlaceOwner()"
            :status="place.status"
          ></PlacesDetailCard>
          <hr class="sidebar-divider" />
          <Filters class="mb-2"></Filters>
        </div>
        <section class="mt-3 ml-4 mr-4">
          <div>
            <div
              v-if="creator"
              class="cursor-pointer mb-2"
              @click="handleCreatorClick($event, creator)"
            >
              <b-badge variant="primary"
                >Uploaded By: <a>{{ creator.username }}</a></b-badge
              >
            </div>
            <div class="d-flex align-items-center">
              <FlagModal
                :id="place.id"
                class="d-inline-block"
                type="placename"
                title="Report"
              ></FlagModal>
              <Favourite class="d-inline-block ml-2"></Favourite>
            </div>
          </div>
          <div v-if="isPTV" class="mt-2">
            <b-row no-gutters class="mt-2 mb-4">
              <b-col xl="6" class="pr-1">
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
              <b-col xl="6" class="pl-1">
                <b-button
                  variant="danger"
                  block
                  size="sm"
                  @click="
                    handleApproval($event, place, {
                      reject: true,
                      type: 'placename'
                    })
                  "
                  >Reject</b-button
                >
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
          <div v-if="place.description">
            <h5 class="font-08 text-uppercase color-gray">Description</h5>
            <p class="font-08">{{ place.description }}</p>
          </div>
          <div v-if="place.category">
            <h5 class="font-08 text-uppercase color-gray">Category</h5>
            <p class="font-08">{{ place.category_obj.name }}</p>
          </div>

          <div v-if="place.common_name">
            <h5 class="font-08 text-uppercase color-gray">Common Name</h5>
            <p class="font-08">{{ place.common_name }}</p>
          </div>
          <div v-if="place.other_names">
            <h5 class="font-08 text-uppercase color-gray">Other Names</h5>
            <p class="font-08">{{ place.other_names }}</p>
          </div>
        </section>
        <hr />
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
              type="placename"
            ></Media>
            <div v-if="isMTV(media, mediaToVerify)">
              <b-row no-gutters class="mt-2">
                <b-col xl="6" class="pr-1">
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
                <b-col xl="6" class="pl-1">
                  <b-button
                    variant="danger"
                    block
                    size="sm"
                    @click="
                      handleApproval($event, media, {
                        reject: true,
                        type: 'media'
                      })
                    "
                    >Reject</b-button
                  >
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

import {
  getApiUrl,
  encodeFPCC,
  getMediaUrl,
  getGenericFileType
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
    Favourite
  },
  data() {
    return {
      showUploadModal: false,
      closeOverlayContent: false
    }
  },
  computed: {
    placeCommunity() {
      return this.$store.state.places.placeCommunity
    },
    place() {
      return this.$store.state.places.place
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

        if (this.user.id === m.creator.id) {
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
      if (newPlace !== oldPlace) this.setupMap()
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

    await store.dispatch('places/getPlace', {
      id: geo_place.id
    })

    await store.dispatch('places/getPlaceMedias', {
      id: geo_place.id
    })

    await store.dispatch('user/getPlacesToVerify')
    await store.dispatch('user/getMediaToVerify')

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
  },
  created() {
    this.setupMap()
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
