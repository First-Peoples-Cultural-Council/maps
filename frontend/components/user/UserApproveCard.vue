<template>
  <div
    class="user-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <Card :variant="variant">
      <template v-slot:header>
        <div
          class="user-icon-container"
          :style="'background-color:' + color"
          :class="{ 'icon-sm': icon === 'small' }"
        >
          <img src="@/assets/images/community_icon.svg" alt="community" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <h5 class="field-kinds">
            {{ verify.community.name }}
          </h5>
          <h5 class="field-names">
            {{ getName() }}
          </h5>
        </div>
        <div class="user-btn-container">
          <b-button
            class="verify-btn"
            @click="
              handleUser($event, verify, {
                verify: 'verify'
              })
            "
            >Verify</b-button
          >
          <Reject :id="verify.id" type="community" :member="verify"></Reject>
        </div>
      </template>
      <template v-slot:footer> </template>
    </Card>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
import Reject from '@/components/RejectModal.vue'
import { getApiUrl, getCookie } from '@/plugins/utils.js'

export default {
  components: {
    Card,
    Reject
  },
  props: {
    verify: {
      type: Object,
      default: () => {
        return {}
      }
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    },
    go: {
      type: Boolean,
      default: true
    },
    variant: {
      type: String,
      default: 'normal'
    },
    icon: {
      default: 'large',
      type: String
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {
    getName() {
      const user = this.verify.user
      if (user.first_name === '' || user.last_name === '') {
        return user.username
      } else {
        return `${user.first_name} ${user.last_name}`
      }
    },
    async handleUser(e, tv, { verify, reject }) {
      const url = {
        verify: getApiUrl('community/verify_member/'),
        reject: getApiUrl('community/reject_member/')
      }
      await this.$axios.$patch(
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
      await this.$store.dispatch('user/getMembersToVerify')
      // console.log('Result', result)
    },
    handleMouseOver() {
      this.hover = true
      this.$eventHub.revealArea(this.verify.community.point)
    },
    handleMouseLeave() {
      this.hover = false
      this.$eventHub.doneReveal()
    }
  }
}
</script>

<style lang="scss">
.user-card {
  cursor: pointer;
}
.user-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 30px;
  width: 30px;
}
.user-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: #b47a2b;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
}
.fpcc-card:hover .fpcc-card-more {
  background-color: #00333a;
}

.user-icon-container.icon-sm {
  width: 30px;
  height: 30px;
}

.user-btn-container {
  display: flex;

  & > * {
    flex: 1 1 auto;
  }
  .verify-btn {
    padding: 0.25rem 0.5rem;
    font-size: 0.875rem;
    margin-right: 0.5em;
    border-radius: 0.2rem;
  }
}
</style>
