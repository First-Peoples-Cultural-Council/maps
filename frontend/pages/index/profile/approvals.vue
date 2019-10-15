<template>
  <div>
    <div
      v-if="!mobileContent"
      class="justify-content-between align-items-center pl-2 pr-2 d-none content-mobile-title"
    >
      <div>
        <b-badge variant="primary">Expand To See Approvals</b-badge>
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
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile"></Logo>
      <div v-if="isLangAdmin" class="ml-3 mr-3">
        <div v-if="nothingToVerify" class="mt-2">
          <b-alert show>Nothing to approve</b-alert>
        </div>
        <div v-if="placesToVerify && placesToVerify.length > 0" class="mt-2">
          <h5 class="font-1 color-dark-gray">
            Places Waiting For Verification
          </h5>
          <div v-for="ptv in placesToVerify" :key="`ptv${ptv.id}`" class="mb-3">
            <PlacesCard
              :place="{ properties: { name: ptv.name } }"
              class="mb-2"
              @click.native="
                $router.push({
                  path: `/place-names/${encodeFPCC(ptv.name)}`
                })
              "
            ></PlacesCard>
            <b-row no-gutters>
              <b-col xs="6" class="pr-1">
                <b-button
                  variant="dark"
                  block
                  size="sm"
                  @click="
                    handleApproval($event, ptv, {
                      verify: true,
                      type: 'placename'
                    })
                  "
                  >Verify</b-button
                >
              </b-col>
              <b-col xs="6" class="pl-1">
                <Reject :id="ptv.id" type="placename"></Reject>
              </b-col>
            </b-row>
          </div>
        </div>

        <div v-if="mediaToVerify && mediaToVerify.length > 0">
          <h5 class="color-dark-gray font-1">Media Waiting For Verification</h5>
          <div v-for="mtv in mediaToVerify" :key="`mtv${mtv.id}`" class="mb-4">
            <div>
              Place {{ mtv.place }}
              <Media :media="mtv" :community-only="mtv.community_only"></Media>
              <b-row no-gutters class="mt-2">
                <b-col xs="6" class="pr-1">
                  <b-button
                    variant="dark"
                    block
                    size="sm"
                    @click="
                      handleApproval($event, mtv, {
                        verify: true,
                        type: 'media'
                      })
                    "
                    >Verify</b-button
                  >
                </b-col>
                <b-col xl="6" class="pl-1">
                  <Reject :id="mtv.id" type="media" :media="mtv"></Reject>
                </b-col>
              </b-row>
            </div>
          </div>
        </div>
        <div v-if="usersToVerify && usersToVerify.length > 0">
          <h5>Users Waiting For Verification</h5>
          <div v-for="utv in usersToVerify" :key="`utv${utv.id}`">
            <ul>
              <li>UserName: {{ utv.user.username }}</li>
              <li>First Name: {{ utv.user.first_name }}</li>
              <li>Last Name: {{ utv.user.last_name }}</li>
              <li>Community: {{ utv.community.name }}</li>
              <li>
                <b-button
                  @click="
                    handleUser($event, utv, {
                      verify: 'verify'
                    })
                  "
                  >Verify</b-button
                >
              </li>
              <li>
                <Reject :id="utv.id" type="community" :member="utv"></Reject>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Logo from '@/components/Logo.vue'
import { getApiUrl, getCookie, encodeFPCC } from '@/plugins/utils.js'
import PlacesCard from '@/components/places/PlacesCard.vue'
import Media from '@/components/Media.vue'
import Reject from '@/components/RejectModal.vue'

export default {
  components: {
    Logo,
    PlacesCard,
    Media,
    Reject
  },
  computed: {
    isLangAdmin() {
      return this.$store.state.user.user.administrator_set.length > 0
    },
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },
    placesToVerify() {
      return this.$store.state.user.placesToVerify
    },
    usersToVerify() {
      return this.$store.state.user.membersToVerify
    },
    mediaToVerify() {
      return this.$store.state.user.mediaToVerify
    },
    user() {
      const user = this.$store.state.user.user
      return user
    },
    nothingToVerify() {
      return (
        this.placesToVerify.length === 0 &&
        this.mediaToVerify.length === 0 &&
        this.usersToVerify.length === 0
      )
    }
  },
  asyncData({ params, $axios, store }) {
    return {
      isServer: !!process.server
    }
  },
  async fetch({ store }) {
    await Promise.all([
      store.dispatch('user/getPlacesToVerify'),
      store.dispatch('user/getMediaToVerify'),
      store.dispatch('user/getMembersToVerify')
    ])
  },
  methods: {
    encodeFPCC,
    async handleUser(e, tv, { verify, reject }) {
      const url = {
        verify: getApiUrl('community/verify_member/'),
        reject: getApiUrl('community/reject_member/')
      }
      const result = await this.$axios.$patch(
        url[verify || reject],
        {
          user_id: tv.user.id,
          community_id: tv.community.id
        },
        {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        }
      )
      if (result.message === 'Verified!' || result.messsage === 'Rejected!') {
        this.usersToVerify = this.usersToVerify.filter(u => u.id !== tv.id)
      }
      console.log('Result', result)
    },
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
        }
        if (type === 'media') {
          this.$store.dispatch('user/getMediaToVerify')
        }
      }
    }
  }
}
</script>
<style></style>
