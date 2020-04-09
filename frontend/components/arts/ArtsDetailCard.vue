<template>
  <div class="arts-detail-card">
    <div
      class="arts-detail-icon-container"
      :style="'background-color:' + color"
    >
      <img
        v-if="arttype.toLowerCase() === 'public_art'"
        src="@/assets/images/public_art_icon.svg"
        alt="Arts"
      />
      <img
        v-else-if="arttype.toLowerCase() === 'event'"
        src="@/assets/images/event_icon.svg"
        alt="Event"
      />
      <img
        v-else-if="arttype.toLowerCase() === 'artist'"
        src="@/assets/images/artist_icon.svg"
        alt="Event"
      />
      <img
        v-else-if="arttype.toLowerCase() === 'organization'"
        src="@/assets/images/organization_icon.svg"
        alt="Organization"
      />
    </div>

    <div class="arts-detail-text">
      <div>
        <h5 class="field-kind">
          {{ arttype | kind }}
        </h5>
        <h5 class="field-name">
          {{ name }}
        </h5>
      </div>
      <div class="artist-tags-container">
        <span v-for="tag in tags" :key="tag.name">{{ tag.name }}</span>
      </div>
    </div>

    <div class="fpcc-card-more-art" @click.prevent="handleReturn">
      <img
        v-if="hover"
        class="ml-1"
        src="@/assets/images/return_icon.svg"
        alt="Go"
      />
      <img
        v-else
        class="ml-1"
        src="@/assets/images/return_icon_hover.svg"
        alt="Go"
      />
      <span class="ml-1 font-weight-bold">Return</span>
    </div>
  </div>
</template>

<script>
export default {
  components: {},
  filters: {
    kind(d) {
      if (d === 'public_art') {
        return 'Public Art'
      }
      return d
    }
  },
  props: {
    name: {
      type: String,
      default: ''
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    },
    arttype: {
      type: String,
      default: 'Public Art'
    },
    server: {
      default: true,
      type: Boolean
    },
    tags: {
      type: Array,
      default: () => {
        return {}
      }
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {
    handleReturn() {
      this.$store.commit('sidebar/setDrawerContent', false)
      if (this.server) {
        this.$router.push({
          path: '/art'
        })
      } else {
        this.$router.go(-1)
      }
    }
  }
}
</script>

<style scoped>
.arts-detail-card {
  cursor: pointer;
  border-bottom: 3px solid #f9f9f9;
  display: flex;
  justify-content: flex-start;
  width: 100%;
  border: 1px solid #ebe6dc;
  padding: 1em 0 1em 1em;
  border-radius: 0.25em;
  position: relative;
}
.arts-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 50px;
  width: 50px;
}

.arts-detail-text {
  margin-left: 0.5em;
}
.arts-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more-art {
  width: 90px;
  background-color: #b47a2b;
  height: 35px;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
  z-index: 50000;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1em;
  position: absolute;
  right: 0;
  top: 25%;
}

.fpcc-card-more-art:hover {
  color: white;
  background-color: #454545;
}

.fpcc-card-more-art img {
  display: inline-block;
  width: 15px;
  height: 15px;
}

.fpcc-card {
  border: 0;
  box-shadow: none;
}

.field-kind {
  font: Bold 15px/18px Proxima Nova;
  color: #707070;
  opacity: 0.7;
  text-transform: uppercase;
  margin: 0.2em;
  padding: 0;
}

.field-name {
  font: Bold 16px/20px Proxima Nova;
  color: #707070;
  margin: 0.2em;
  padding: 0;
}
</style>
