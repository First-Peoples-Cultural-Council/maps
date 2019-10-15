<template>
  <div>
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        User: <b-badge variant="primary">{{ getUserName() }}</b-badge>
      </div>
      <div @click="$store.commit('sidebar/setMobileContent', true)">
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>
    <div class="hide-mobile pb-4" :class="{ 'content-mobile': mobileContent }">
      <div
        class="text-center d-none mobile-close"
        :class="{ 'content-mobile': mobileContent }"
        @click="$store.commit('sidebar/setMobileContent', false)"
      >
        <img class="d-inline-block" src="@/assets/images/arrow_down_icon.svg" />
      </div>
      <UserDetailCard
        :id="user.id"
        :name="getUserName()"
        type="none"
        :edit="isAdmin()"
        :approval="isLangAdmin"
      ></UserDetailCard>
      <section class="ml-2 mr-2 mt-2">
        <div
          v-if="
            isLoggedIn &&
              isOwner &&
              user.languages &&
              user.languages.length === 0 &&
              user.communities &&
              user.communities.length === 0
          "
        >
          <b-alert variant="danger" show
            >Please select your community or language by clicking
            <router-link :to="`/profile/edit/${user.id}`"
              >here</router-link
            ></b-alert
          >
        </div>
        <div v-if="user.languages && user.languages.length > 0">
          <h5 class="color-gray font-08 text-uppercase font-weight-bold mb-0">
            Spoken Languages
          </h5>
          <LanguageDetailBadge
            v-for="lang in user.languages"
            :key="`badge${lang.id}`"
            :content="lang.name"
            class="mr-2 cursor-pointer"
            @click.native="
              $router.push({ path: '/languages/' + encodeFPCC(lang.name) })
            "
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
          v-if="user.placename_set.length > 0"
          class="color-gray font-08 text-uppercase font-weight-bold mb-0 mt-2"
        >
          Contributions ({{ user.placename_set.length }})
        </h5>
        <PlacesCard
          v-for="place in user.placename_set"
          :key="`place${place.id}`"
          :place="{ properties: place }"
          class="mt-3 hover-left-move"
          @click.native="
            $router.push({ path: '/place-names/' + encodeFPCC(place.name) })
          "
        ></PlacesCard>
        <div v-if="savedLocations.length > 0 && isOwner">
          <h5
            class="color-gray font-08 text-uppercase font-weight-bold mb-0 mt-3"
          >
            Saved Locations ({{ savedLocations.length }})
          </h5>
          <div v-for="sl in savedLocations" :key="`sl${sl.id}`">
            <div v-if="sl.name">Name: {{ sl.name }}</div>
            <div v-if="sl.description">Description: {{ sl.description }}</div>
            <b-button
              variant="dark"
              size="sm"
              @click="handleLocation($event, sl)"
              >Go To Location</b-button
            >
            <b-button
              variant="dark"
              size="sm"
              @click="removeLocation($event, sl)"
              >Remove Location</b-button
            >
          </div>
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
            class="color-gray font-08 text-uppercase font-weight-bold mb-0 mt-3"
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
    </div>
  </div>
</template>

<script>
import UserDetailCard from '@/components/user/UserDetailCard.vue'
import { getApiUrl, encodeFPCC } from '@/plugins/utils.js'
import LanguageDetailBadge from '@/components/languages/LanguageDetailBadge.vue'
import PlacesCard from '@/components/places/PlacesCard.vue'
import { zoomToPoint } from '@/mixins/map.js'
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'

export default {
  components: {
    UserDetailCard,
    LanguageDetailBadge,
    PlacesCard,
    LanguageCard,
    CommunityCard
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
    }
  },
  beforeRouteEnter(to, from, next) {
    next(vm => {
      vm.$store.commit('sidebar/set', true)
    })
  },
  beforeRouteLeave(to, from, next) {
    this.$store.commit('sidebar/set', false)
    next()
  },
  async asyncData({ params, $axios, store, dispatch }) {
    const user = await $axios.$get(
      getApiUrl(`user/${params.id}/?timestamp=${new Date().getTime()}`)
    )

    const authUser = await $axios.$get(
      getApiUrl(`user/auth?timestamp=${new Date().getTime()}/`)
    )
    let isOwner = false
    if (authUser.is_authenticated === true) {
      if (parseInt(params.id) === authUser.user.id) {
        isOwner = true
      }
    }
    await store.dispatch('user/getNotifications', {
      isServer: !!process.server
    })
    await store.dispatch('places/getFavourites')
    return { user, isOwner }
  },
  mounted() {
    console.log('mounted, user=', this.user)
  },
  methods: {
    encodeFPCC,
    isAdmin() {
      return this.user && this.user.id === this.$store.state.user.user.id
    },
    getUserName() {
      return (
        this.user && (this.user.first_name || this.user.username.split('__')[0])
      )
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
      const result = await this.$store.dispatch(
        'user/removeSavedLocation',
        data
      )
      console.log('Location Remove Result', result)
    }
  }
}
</script>

<style scoped></style>
