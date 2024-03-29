<template>
  <div
    class="user-main-card"
    @mouseover.prevent="handleMouseOver"
    @mouseleave="handleMouseLeave"
  >
    <div class="user-card" :class="{ 'user-card-white': variant == 'white' }">
      <div class="user-card-header">
        <div
          class="user-icon-container"
          :style="'background-color:' + color"
          :class="{ 'icon-sm': icon === 'small' }"
        >
          <img src="@/assets/images/user_icon.svg" alt="community" />
        </div>
      </div>
      <div class="user-card-body">
        <div>
          <h5 class="field-names">
            {{ getName() }}
          </h5>
          <h5 class="field-kinds">
            {{ userToVerify.community.name }}
          </h5>
        </div>
      </div>
    </div>

    <div class="user-btn-container">
      <b-button
        variant="dark"
        block
        size="sm"
        @click="
          submitUserVerification(userToVerify, {
            userToVerify: 'verify'
          })
        "
        >Verify</b-button
      >
      <Reject
        :id="userToVerify.id"
        type="community"
        :member="userToVerify"
      ></Reject>
    </div>
  </div>
</template>

<script>
import Reject from '@/components/RejectModal.vue'

export default {
  components: {
    Reject
  },
  props: {
    userToVerify: {
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
      const user = this.userToVerify.user
      if (user.first_name === '' || user.last_name === '') {
        return user.username
      } else {
        return `${user.first_name} ${user.last_name}`
      }
    },
    async submitUserVerification(toVerify) {
      await this.$store.dispatch('user/verifyMember', {
        user_id: toVerify.user.id,
        community_id: toVerify.community.id
      })
    },
    handleMouseOver() {
      this.hover = true
      this.$eventHub.revealArea(this.userToVerify.community.point)
    },
    handleMouseLeave() {
      this.hover = false
      this.$eventHub.doneReveal()
    }
  }
}
</script>

<style lang="scss">
.user-main-card {
  display: flex;
  flex-direction: column;
  border: 1px solid #ebe6dc;
  padding: 0.5em 0em 0.5em 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);
  cursor: pointer;

  &:hover {
    border: 1px solid #b57936;
  }
}

.user-card {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  width: 100%;

  display: table;
  height: 100%;
}
.user-card-header {
  display: table-cell;
  vertical-align: middle;
  width: 10%;
}
.user-card-body {
  display: table-cell;
  vertical-align: middle;
  width: 75%;
  padding-right: 0.5em;
}
.user-card-footer {
  display: table-cell;
  vertical-align: middle;
  width: 55px;
}

.user-card-white {
  background-color: White;
}

.user-icon-container {
  border-radius: 50%;
  height: 30px;
  width: 30px;
}
.user-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}

.user-icon-container.icon-sm {
  width: 30px;
  height: 30px;
}

.user-btn-container {
  display: flex;
  margin-top: 0.5em;

  & > * {
    flex: 0 0 25%;
    margin-right: 0.25em;
    font-size: 0.8em;
  }
}
</style>
