<template>
  <div>
    <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
    <h5 class="color-gray font-08 p-0 m-0 d-none header-mobile">
      Point Of Interest:
      <span class="font-weight-bold">{{ place.name }}</span>
    </h5>
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
      <section class="mt-3 ml-4 mr-4">
        <div v-if="place.status === 'FL'" class="mb-2">
          <b-badge variant="danger">Flagged</b-badge>
        </div>
        <div v-if="place.status === 'UN'" class="mb-2">
          <b-badge variant="info">Unverified</b-badge>
          <FlagModal
            :id="place.id"
            class="float-right"
            type="placename"
            title="Flag Point Of Interest"
          ></FlagModal>
        </div>
        <div v-if="place.status === 'VE'" class="mb-2">
          <b-badge variant="primary">Verified</b-badge>
          <FlagModal
            :id="place.id"
            class="float-right"
            type="placename"
            title="Flag Point Of Interest"
          ></FlagModal>
        </div>
        <div v-if="isPTV">
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
        <div v-if="place.community" class="mb-4">
          <CommunityCard
            :name="community.name"
            @click.native="
              $router.push({ path: `/content/${encodeFPCC(community.name)}` })
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

      <section v-if="medias && medias.length > 0" class="mt-4 ml-4 mr-4">
        <h5 class="font-08 text-uppercase color-gray mb-3">
          {{ medias.length }} Uploaded Media
        </h5>

        <div v-for="media in medias" :key="'media' + media.id" class="mb-4">
          <Media :media="media" :server="isServer"></Media>
          <hr class="mb-2" />
        </div>
      </section>
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
    Media
  },
  data() {
    return {
      showUploadModal: false
    }
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
    },
    isPTV() {
      return this.ptv.find(p => p.id === this.place.id)
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
    const place = await $axios.$get(
      getApiUrl(`placename/${geo_place.id}?timestamp=${now.getTime()}`)
    )

    let community = null
    if (place.community) {
      community = await $axios.$get(getApiUrl(`community/${place.community}/`))
    }

    const ptv = await $axios.$get(getApiUrl('placename/list_to_verify/'))

    const isServer = !!process.server
    return {
      geo_place,
      place,
      isServer,
      medias: place.medias,
      community,
      ptv
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
          this.ptv = this.ptv.filter(p => p.id !== tv.id)
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
