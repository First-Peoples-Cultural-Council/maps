<template>
  <div>
    <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
    <div v-if="user && user.is_staff" class="ml-3 mr-3">
      <div v-if="nothingToVerify" class="mt-2">
        <b-alert show>Nothing to approve</b-alert>
      </div>
      <div v-if="placesToVerify && placesToVerify.length > 0" class="mt-2">
        <h5 class="font-1 color-dark-gray">Places Waiting For Verification</h5>
        <div v-for="ptv in placesToVerify" :key="`ptv${ptv.id}`" class="mb-3">
          <PlacesCard
            :name="{ properties: { name: ptv.name } }"
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
                block
                variant="dark"
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
              <b-button
                block
                variant="danger"
                size="sm"
                @click="
                  handleApproval($event, ptv, {
                    reject: true,
                    type: 'placename'
                  })
                "
                >Reject</b-button
              >
            </b-col>
          </b-row>
        </div>
      </div>

      <div v-if="mediaToVerify && mediaToVerify.length > 0">
        <h5 class="color-dark-gray font-1">Media Waiting For Verification</h5>
        <div v-for="mtv in mediaToVerify" :key="`mtv${mtv.id}`" class="mb-4">
          <div>
            Place {{ mtv.place }}
            <Media :media="mtv"></Media>
            <b-row no-gutters class="mt-2">
              <b-col xl="6" class="pr-1">
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
                <b-button
                  variant="danger"
                  block
                  size="sm"
                  @click="
                    handleApproval($event, mtv, {
                      reject: true,
                      type: 'media'
                    })
                  "
                  >Reject</b-button
                >
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
              <b-button
                @click="
                  handleUser($event, utv, {
                    reject: 'reject'
                  })
                "
                >Reject</b-button
              >
            </li>
          </ul>
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

export default {
  components: {
    Logo,
    PlacesCard,
    Media
  },
  computed: {
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
  created() {
    this.$root.$on('media_deleted', id => {
      this.$store.dispatch('user/getMediaToVerify')
    })
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
