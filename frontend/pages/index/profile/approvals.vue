<template>
  <div>
    <Logo :logo-alt="2" class="pt-2 pb-2"></Logo>
    <div v-if="user && user.is_staff">
      <div v-if="placesToVerify && placesToVerify.length > 0">
        <h5>Places Waiting For Verification</h5>
        <div
          v-for="ptv in placesToVerify"
          :key="`ptv${ptv.id}`"
          class="pr-2 pl-2"
        >
          <PlacesCard
            :name="ptv.name"
            class="mb-2"
            @click.native="
              $router.push({
                path: `/place-names/${encodeFPCC(ptv.name)}`
              })
            "
          ></PlacesCard>
          <ul>
            <li>
              <b-button
                @click="
                  handleApproval($event, ptv, {
                    verify: true,
                    type: 'placename'
                  })
                "
                >Verify</b-button
              >
            </li>
            <li>
              <b-button
                @click="
                  handleApproval($event, ptv, {
                    reject: true,
                    type: 'placename'
                  })
                "
                >Reject</b-button
              >
            </li>
          </ul>
        </div>
      </div>
      <div v-if="mediaToVerify && mediaToVerify.length > 0">
        <h5>Media Waiting For Verification</h5>
        <div v-for="mtv in mediaToVerify" :key="`mtv${mtv.id}`">
          <ul>
            <li>Name: {{ mtv.name }}</li>
            <li>
              <b-button
                @click="
                  handleApproval($event, mtv, {
                    verify: true,
                    type: 'media'
                  })
                "
                >Verify</b-button
              >
            </li>
            <li>
              <b-button
                @click="
                  handleApproval($event, mtv, {
                    reject: true,
                    type: 'media'
                  })
                "
                >Reject</b-button
              >
            </li>
          </ul>
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

export default {
  components: {
    Logo,
    PlacesCard
  },
  computed: {
    user() {
      const user = this.$store.state.user.user
      return user
    }
  },
  async asyncData({ params, $axios, store }) {
    const results = await Promise.all([
      $axios.$get(
        `${getApiUrl(
          `placename/list_to_verify?timestamp=${new Date().getTime()}/`
        )}`
      ),
      $axios.$get(
        `${getApiUrl(
          `media/list_to_verify?timestamp=${new Date().getTime()}/`
        )}`
      ),
      $axios.$get(
        `${getApiUrl(
          `community/list_member_to_verify?timestamp=${new Date().getTime()}/`
        )}`
      )
    ])

    return {
      placesToVerify: results[0],
      mediaToVerify: results[1],
      usersToVerify: results[2]
    }
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
      const mode = verify ? 'verify' : 'reject'
      const result = await this.$axios.$patch(
        `${getApiUrl(`${type}/${tv.id}/${mode}/`)}`,
        {
          status_reason: mode
        },
        {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        }
      )
      console.log('Result', result)
      if (
        result &&
        (result.message === 'Verified!' || result.message === 'Rejected!')
      ) {
        if (type === 'placename ') {
          this.placesToVerify = this.placesToVerify.filter(p => p.id !== tv.id)
        }

        if (type === 'media') {
          this.mediaToVerify = this.mediaToVerify.filter(m => m.id !== tv.id)
        }
      }
    }
  }
}
</script>
<style></style>
