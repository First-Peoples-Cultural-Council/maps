<template>
  <div>
    <div v-if="user && isOwner" class="profile-container">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          User: <b-badge variant="primary">{{ getUserName() }}</b-badge>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div
        class="hide-mobile pb-4"
        :class="{ 'content-mobile': mobileContent }"
      >
        <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
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

        <UserDetailCard
          :id="user.id"
          :name="getUserName()"
          :art-image="getUserImg()"
          type="none"
          :edit="isAdmin()"
          :approval="isLangAdmin && isOwner"
          :handle-return="handleReturn"
        ></UserDetailCard>
        <section class="mt-2 pl-3 pr-3">
          <div
            v-if="
              isLoggedIn &&
                isOwner &&
                listOfLanguages &&
                listOfLanguages.length === 0 &&
                user.communities &&
                user.communities.length === 0
            "
          >
            <b-alert variant="danger" show
              >Please select your community and language by clicking
              <router-link :to="`/profile/edit/${user.id}`"
                >here</router-link
              ></b-alert
            >
          </div>
          <div v-if="isLoggedIn && isOwner && !isArtistProfileExist()">
            <b-alert variant="danger" show
              >{{
                artistProfilePlaceholder()
                  ? `Select a Artist Profile from Artists that you're handling, by clicking `
                  : 'Please create your artist profile by clicking'
              }}
              <router-link
                :to="
                  `${
                    artistProfilePlaceholder()
                      ? `/profile/edit/${user.id}`
                      : `/contribute?mode=placename&type=Artist&profile=true`
                  }`
                "
                >here</router-link
              ></b-alert
            >
          </div>
          <div v-if="placenameSet.length === 0">
            <b-alert variant="danger" show
              >You haven't Contributed anything in the map. Please contribute by
              clicking
              <a href="#" @click="openContributeModal">here</a>
            </b-alert>
          </div>
          <div v-if="isStaff && isSuperUser && isLoggedIn">
            <b-alert variant="success" show
              >You're an admin. Open admin page
              <a href="/admin" target="_blank">here</a>
            </b-alert>
          </div>
          <div
            v-if="
              (user.languages && user.languages.length > 0) ||
                (user.non_bc_languages && user.non_bc_languages.length > 0)
            "
          >
            <h5 class="color-gray font-08 text-uppercase font-weight-bold mb-0">
              Spoken Languages
            </h5>
            <LanguageDetailBadge
              v-for="lang in listOfLanguages"
              :key="`badge-${lang.id ? lang.name : lang}`"
              :content="lang.id ? lang.name : lang"
              class="mr-2 cursor-pointer"
              @click.native="redirectToLanguage(lang)"
            ></LanguageDetailBadge>
          </div>
          <div
            v-if="user.communities && user.communities.length > 0"
            class="mt-3"
          >
            <h5 class="color-gray font-08 text-uppercase font-weight-bold mb-0">
              Communities
            </h5>
            <LanguageDetailBadge
              v-for="comm in user.communities"
              :key="`badge${comm.id}`"
              :content="comm.name"
              class="mr-2 cursor-pointer"
              @click.native="
                $router.push({ path: '/content/' + encodeFPCC(comm.name) })
              "
            ></LanguageDetailBadge>
          </div>

          <h5
            v-if="placenameSet.length > 0"
            class="color-gray font-08 text-uppercase font-weight-bold mb-2 mt-2"
          >
            Contributions ({{ placenameSet.length }})
          </h5>
          <template v-for="place in placenameSet">
            <!-- Render this card if not Art Placename -->
            <PlacesCard
              v-if="place.kind === '' || place.kind === 'poi'"
              :key="`place-${place.name}-${place.id}`"
              :place="{ properties: place }"
              class="mt-1 hover-left-move"
              @click.native="
                $router.push({ path: '/place-names/' + encodeFPCC(place.name) })
              "
            ></PlacesCard>
            <!-- Render this card if Art Placename -->
            <ArtsCard
              v-else
              :key="`place-${place.name}-${place.id}`"
              :name="place.name"
              :kind="place.kind"
              class="mt-1 hover-left-move"
              @click.native="
                $router.push({
                  path: `/art/${encodeFPCC(place.name)}`
                })
              "
            ></ArtsCard>
          </template>

          <div v-if="savedLocations.length > 0 && isOwner">
            <h5
              class="color-gray font-08 text-uppercase font-weight-bold mb-3 mt-3"
            >
              Saved Locations ({{ savedLocations.length }})
            </h5>

            <LocationItem
              v-for="sl in savedLocations"
              :key="`sl-${sl.id}`"
              :item="sl"
            ></LocationItem>
          </div>

          <div v-if="isOwner">
            <h5
              v-if="placeFavourites.length"
              class="color-gray font-08 text-uppercase font-weight-bold mb-0 mt-3"
            >
              Favourites ({{ placeFavourites.length }})
            </h5>
            <div v-for="f in placeFavourites" :key="`fav${f.id}`">
              <PlacesCard
                :place="{ properties: f.placename_obj }"
                class="mt-3 hover-left-move"
                @click.native="
                  $router.push({
                    path: '/place-names/' + encodeFPCC(f.placename_obj.name)
                  })
                "
              ></PlacesCard>
            </div>
          </div>
          <div v-if="isOwner && notifications && notifications.length > 0">
            <h5
              class="color-gray font-08 text-uppercase font-weight-bold mb-3 mt-3"
            >
              Notifications ({{ notifications.length }})
            </h5>
            <div
              v-for="(notification, index) in notifications"
              :key="`notification${index}`"
              class="mt-2"
            >
              Name: {{ notification.name }}
              <div v-if="notification.language">
                <LanguageCard
                  class="mb-3 hover-left-move"
                  :name="notification.language_obj.name"
                  :color="notification.language_obj.color"
                  @click.native.prevent="
                    $router.push({
                      path: `/languages/${encodeFPCC(
                        notification.language_obj.name
                      )}`
                    })
                  "
                ></LanguageCard>
              </div>
              <div v-if="notification.community">
                <CommunityCard
                  class="mt-3 hover-left-move"
                  :name="notification.community_obj.name"
                  :community="notification.community_obj"
                  @click.native.prevent="
                    $router.push({
                      path: `/content/${encodeFPCC(
                        notification.community_obj.name
                      )}`
                    })
                  "
                ></CommunityCard>
              </div>
            </div>
          </div>
        </section>
        <ArtsDrawer
          :art="artDetails"
          :artist-profile="user.artist_profile"
          class="sidebar-side-panel hide-mobile"
          :class="{
            'hide-scroll-y': isGalleryShown
          }"
        ></ArtsDrawer>
      </div>
    </div>
    <ErrorScreen v-else></ErrorScreen>
  </div>
</template>

<script>
import UserDetailCard from '@/components/user/UserDetailCard.vue'
import { getApiUrl, encodeFPCC, getMediaUrl } from '@/plugins/utils.js'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import Logo from '@/components/Logo.vue'
import ErrorScreen from '@/layouts/error.vue'
import ArtsDrawer from '@/components/arts/ArtsDrawer.vue'
import LocationItem from '@/components/LocationItem.vue'

export default {
  components: {
    UserDetailCard,
    LanguageDetailBadge,
    PlacesCard,
    LanguageCard,
    CommunityCard,
    Logo,
    ArtsCard,
    ErrorScreen,
    ArtsDrawer,
    LocationItem
  },
  computed: {
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    },
    isLangAdmin() {
      return this.$store.state.user.user.administrator_set.length > 0
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    savedLocations() {
      return this.favourites.filter(f => f.favourite_type === 'saved_location')
    },
    isStaff() {
      return (this.$store.state.user.user || {}).is_staff
    },
    isSuperUser() {
      return this.$store.state.user.user.is_superuser
    },
    favourites() {
      return this.$store.state.places.favourites
    },
    placeFavourites() {
      return this.favourites.filter(f => f.favourite_type === 'favourite')
    },
    notifications() {
      return this.$store.state.user.notifications
    },
    getContributedPublicArt() {
      const placenameSet = this.user.placename_set
      if (placenameSet && placenameSet.length !== 0) {
        const getPlacenameId = placenameSet
          .filter(place => place.kind === 'artist')
          .map(place => place.id)
        return this.allArts.filter(art => {
          if (art.kind === 'public_art' && art.artists.length !== 0) {
            return art.artists.some(ar => getPlacenameId.includes(ar))
          }
        })
      } else {
        return []
      }
    },
    placenameSet() {
      const placenameSet = [
        ...this.user.placename_set,
        ...this.getContributedPublicArt
      ]
      return placenameSet.sort((a, b) => a.kind.localeCompare(b.kind))
    },
    listOfLanguages() {
      const { languages, non_bc_languages } = this.user
      if (
        (languages && languages.length > 0) ||
        (non_bc_languages && non_bc_languages.length > 0)
      ) {
        const bcLanguages = languages && languages.length !== 0 ? languages : []
        const nonBCLanguages =
          non_bc_languages && non_bc_languages.length !== 0
            ? non_bc_languages
            : []

        return [...bcLanguages, ...nonBCLanguages]
      } else {
        return []
      }
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    },
    isGalleryShown() {
      return this.$store.state.sidebar.showGallery
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/set', false)
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('sidebar/set', false)
    if (this.isDrawerShown) {
      this.$store.commit('sidebar/setDrawerContent', false)
    }
    next()
  },
  async asyncData({ params, $axios, store, dispatch }) {
    const user = await $axios.$get(
      getApiUrl(`user/${params.id}/?timestamp=${new Date().getTime()}`)
    )

    const authUser = await $axios.$get(
      getApiUrl(`user/auth?timestamp=${new Date().getTime()}/`)
    )

    const artistProfiles = user.placename_set.filter(
      placename => placename.kind === 'artist'
    )

    let allArts = []

    if (artistProfiles && artistProfiles.length !== 0) {
      const artistQueryArray = []
      artistProfiles.forEach(profile => {
        artistQueryArray.push(`${profile.id}`)
      })

      const artistQuery = artistQueryArray.join(',')
      allArts =
        artistQueryArray.length > 0
          ? await $axios.$get(
              getApiUrl(`art-search?artists=${artistQuery}&format=json`)
            )
          : []
    }

    let artDetails = null
    if (user.artist_profile) {
      artDetails = await $axios.$get(
        getApiUrl('placename/' + user.artist_profile)
      )
    }

    store.commit('arts/setCurrentPlacename', artDetails)

    let isOwner = false
    if (authUser.is_authenticated === true) {
      if (parseInt(params.id) === authUser.user.id) {
        isOwner = true
      }

      await store.dispatch('user/getNotifications', {
        isServer: !!process.server
      })
      await store.dispatch('places/getFavourites')
    }

    return { user, isOwner, allArts, artDetails }
  },
  mounted() {
    console.log(this.artDetails)
    const arts = this.artDetails
    if (
      arts &&
      ((arts.medias && arts.medias.length !== 0) ||
        (arts.public_arts && arts.public_arts.length !== 0))
    ) {
      this.$store.commit('sidebar/setDrawerContent', true)
    }
  },
  methods: {
    encodeFPCC,
    redirectToLanguage(lang) {
      if (lang.id) {
        this.$router.push({ path: '/languages/' + encodeFPCC(lang.name) })
      }
    },
    isArtistProfileExist() {
      return !!this.user.artist_profile
    },
    artistProfilePlaceholder() {
      const { placename_set } = this.user
      const artistProfiles = placename_set.filter(
        placename => placename.kind === 'artist'
      )

      return artistProfiles.length !== 0
    },
    isAdmin() {
      return this.user && this.user.id === this.$store.state.user.user.id
    },
    getUserName() {
      return (
        this.user &&
        (`${this.user.first_name} ${this.user.last_name}` ||
          this.user.username.split('__')[0])
      )
    },
    getUserImg() {
      return this.user.image
        ? getMediaUrl(this.user.image)
        : require(`@/assets/images/artist_icon.svg`)
    },
    handleLocation(e, sl) {
      this.$eventHub.whenMap(map => {
        zoomToPoint({
          map,
          geom: sl.point,
          zoom: sl.zoom
        })
      })
    },
    async removeLocation(e, sl) {
      const data = {
        favourite: sl
      }
      await this.$store.dispatch('user/removeSavedLocation', data)
    },
    handleReturn() {
      this.$router.push({ path: '/languages' })
    },
    openContributeModal() {
      this.$root.$emit('openContributeModal')
    }
  }
}
</script>

<style lang="scss">
.placename-list-container {
  display: flex;
  flex-wrap: wrap;

  .placename-container {
    flex: 0 0 32%;
    height: 150px;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    border-radius: 0.25em;
    box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
    background-clip: border-box;
    border: 1px solid rgba(0, 0, 0, 0.125);
    box-sizing: border-box;
    margin-right: 1%;

    img {
      object-fit: cover;
      width: 100%;
      height: 85px;
    }

    .placename-details {
      display: flex;
      flex-direction: column;
      margin: 0 0.5em 0.5em 0.5em;
    }
  }

  .add-placename {
    justify-content: center;
    align-items: center;
    text-align: center;
    img {
      width: 30px;
      height: 30px;
    }
  }
}
</style>
