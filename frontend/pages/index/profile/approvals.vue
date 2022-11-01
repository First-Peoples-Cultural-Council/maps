<template>
  <div>
    <div
      v-if="!mobileContent"
      class="content-collapse d-none content-mobile-title"
    >
      <div>
        <b-badge variant="primary">Expand To See Approvals</b-badge>
      </div>
      <div
        class="content-collapse-btn"
        @click="$store.commit('sidebar/setMobileContent', true)"
      >
        <img src="@/assets/images/arrow_up_icon.svg" />
      </div>
    </div>
    <div class="hide-mobile  " :class="{ 'content-mobile': mobileContent }">
      <div
        class="text-center d-none mobile-close"
        :class="{ 'content-mobile': mobileContent }"
        @click="$store.commit('sidebar/setMobileContent', false)"
      >
        <img class="d-inline-block" src="@/assets/images/arrow_down_icon.svg" />
      </div>
      <Logo :logo-alt="2" class="pt-2 pb-2 hide-mobile "></Logo>
      <UserDetailCard
        :id="user.id"
        :name="getUserName()"
        :art-image="getUserImg()"
        type="none"
        :handle-return="handleReturn"
      ></UserDetailCard>
      <div v-if="isLangAdmin" class="p-3 approval-container">
        <div v-if="nothingToVerify" class="mt-2">
          <b-alert show>Nothing to approve</b-alert>
        </div>
        <div v-else class="mt-1">
          <b-alert show>These items are waiting for Verification</b-alert>
        </div>
        <div v-if="placesToVerify && placesToVerify.length > 0" class="mt-2">
          <div>
            <PlacesCard
              v-for="ptv in placesToVerify"
              :key="`ptv${ptv.id}`"
              :place="{ properties: { name: ptv.name } }"
              class="mb-2"
              @click.native="
                $router.push({
                  path: `/place-names/${encodeFPCC(ptv.name)}`
                })
              "
            >
              <template v-slot:verify>
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
              </template>
              <template v-slot:reject>
                <Reject :id="ptv.id" type="placename"></Reject>
              </template>
            </PlacesCard>
          </div>
        </div>

        <div v-if="mediaToVerify && mediaToVerify.length > 0" class="mt-2 mb-2">
          <Media
            v-for="mtv in mediaToVerify"
            :key="`mtv${mtv.id}`"
            class="mb-3"
            :media="mtv"
            :community-only="mtv.community_only"
          >
            <template v-slot:verify>
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
            </template>

            <template v-slot:reject>
              <Reject :id="mtv.id" type="media" :media="mtv"></Reject>
            </template>
          </Media>
        </div>

        <div v-if="usersToVerify && usersToVerify.length > 0">
          <UserApproveCard
            v-for="utv in usersToVerify"
            :key="`utv${utv.id}`"
            class="mb-3"
            :user-to-verify="utv"
          ></UserApproveCard>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import Logo from '@/components/Logo.vue'
import { encodeFPCC, getMediaUrl } from '@/plugins/utils.js'
import PlacesCard from '@/components/places/PlacesCard.vue'
import Media from '@/components/Media.vue'
import Reject from '@/components/RejectModal.vue'
import UserApproveCard from '@/components/user/UserApproveCard.vue'
import UserDetailCard from '@/components/user/UserDetailCard.vue'

export default {
  components: {
    Logo,
    PlacesCard,
    Media,
    Reject,
    UserApproveCard,
    UserDetailCard
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
    handleReturn() {
      this.$router.push({ path: '/profile/' + this.user.id })
    }
  }
}
</script>
<style></style>
