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
    <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
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
        :approval="isStaff || isSuperUser"
      ></UserDetailCard>
      <section class="ml-2 mr-2 mt-2">
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
        <div
          v-if="user.placename_set && user.placename_set.length > 0"
          class="mt-3"
        >
          <h5 class="color-gray font-08 text-uppercase font-weight-bold mb-0">
            Contributions
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
          <div v-if="savedLocations.length > 0">
            <h5
              class="color-gray font-08 text-uppercase font-weight-bold mb-0 mt-3"
            >
              Saved Locations
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

export default {
  components: {
    UserDetailCard,
    LanguageDetailBadge,
    PlacesCard
  },
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    savedLocations() {
      return this.favourites.filter(f => f.favourite_type === 'saved_location')
    },
    isStaff() {
      return this.$store.state.user.user.is_staff
    },
    isSuperUser() {
      return this.$store.state.user.user.is_superuser
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
  async asyncData({ params, $axios, store }) {
    const user = await $axios.$get(
      getApiUrl(`user/${params.id}/?timestamp=${new Date().getTime()}`)
    )

    const favourites = await $axios.$get(
      getApiUrl(`favourite?timestamp${new Date().getTime()}/`)
    )
    console.log('User', user)
    return { user, favourites }
  },
  mounted() {
    console.log('mounted, user=', this.user)
  },
  methods: {
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
    encodeFPCC
  }
}
</script>

<style scoped></style>
