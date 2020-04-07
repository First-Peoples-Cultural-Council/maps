<template>
  <ArtistBanner>
    <template v-slot:header>
      <img class="artist-header" :src="artistBanner" />
      <div class="fpcc-card-more-art" @click.prevent="handleReturn">
        <img class="ml-1" src="@/assets/images/return_icon_hover.svg" />
      </div>
      <div
        class="collapse-btn show-mobile"
        @click.prevent="
          $store.commit('sidebar/setMobileContent', !isMobileContent)
        "
      >
        <img
          v-if="!isMobileContent"
          src="@/assets/images/arrow_down_icon.svg"
        />
        <img v-else src="@/assets/images/arrow_up_icon.svg" />
      </div>
      <img class="artist-profile" :src="artistImg()" />
    </template>
    <template v-slot:body>
      <div class="arts-artist-content">
        <div class="artist-title">
          <h5 class="font-09 m-05 p-0 color-gray font-weight-bold art-name">
            {{ name }}
          </h5>
          <h5
            class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
          >
            {{ arttype | art_type }}
          </h5>
        </div>
        <div class="artist-tags-container">
          <span v-for="tag in tags" :key="tag.name">{{ tag.name }}</span>
        </div>

        <span
          v-if="isMobileContent"
          class="artist-more-btn"
          @click.stop.prevent="toggleCollapse"
          >{{ `${isCollapse ? 'Less' : 'More'} about ${name}` }}
          <img v-if="!isCollapse" src="@/assets/images/arrow_down_icon.svg" />
          <img v-else src="@/assets/images/arrow_up_icon.svg" />
        </span>
      </div>
    </template>
  </ArtistBanner>
</template>

<script>
import ArtistBanner from '@/components/arts/ArtistBanner.vue'
export default {
  components: {
    ArtistBanner
  },
  filters: {
    art_type(d) {
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
    artImage: {
      type: String,
      default: ''
    },
    tags: {
      type: Array,
      default: () => {
        return {}
      }
    },
    media: {
      type: Object,
      default: () => {
        return {}
      }
    }
  },
  data() {
    return {
      hover: false,
      collapseContent: false
    }
  },
  computed: {
    isCollapse() {
      return this.$store.state.sidebar.collapseDetail
    },
    showDrawer() {
      return this.$store.state.sidebar.isArtsMode
    },
    artistBanner() {
      return this.media ? this.media.media_file || this.media.image : ''
    },
    isMobileContent() {
      return this.$store.state.sidebar.mobileContent
    }
  },
  methods: {
    handleReturn() {
      if (this.showDrawer) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }

      if (this.server) {
        this.$router.push({
          path: '/art'
        })
      } else {
        this.$router.go(-1)
      }
    },
    artistImg() {
      return this.artImage || require(`@/assets/images/artist_icon.svg`)
    },
    toggleCollapse() {
      this.$store.commit('sidebar/toggleCollapse', !this.isCollapse)
    }
  }
}
</script>

<style scoped>
.arts-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.arts-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more-art {
  background-color: rgba(255, 255, 255, 0);
  display: flex;
  align-items: center;
  position: absolute;
  top: 1em;
  left: 1em;
  height: 35px;
  justify-content: center;
  padding: 0.3em;
  font-size: 0.7em;
  color: #fff;
  text-shadow: white 0px 0px 10px;
  cursor: pointer;
}

.fpcc-card-more-art:hover {
  color: white;
}

.fpcc-card-more-art img {
  display: inline-block;
  width: 15px;
  height: 15px;
}

.collapse-btn {
  width: 35px;
  height: 35px;
  background: #ffffff 0% 0% no-repeat padding-box;
  border: 1px solid #dedee4;
  position: absolute;
  border-radius: 100%;
  top: 30%;
  right: 2%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.artist-more-btn {
  font: Regular 14px/17px Proxima Nova;
  color: #707070;
  margin-bottom: 1em;
}

.fpcc-card {
  border: 0;
  box-shadow: none;
}

.artist-header {
  object-fit: cover;
  width: 100%;
  height: 110px;
  background-color: black;
}

.artist-title {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
}

.artist-tags-container {
  display: flex;
  flex-wrap: wrap;
  justify-content: center;
  width: inherit;
  padding: 1em;
}

.artist-tags-container span {
  flex: 0 1 auto;
  background: #707070;
  border-radius: 2rem;
  color: #fff;
  text-transform: uppercase;
  padding: 2px 5px;
  font-weight: 800;
  font-size: 0.6em;
  margin: 0.25em;
  text-align: center;
}

.arts-artist-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-items: center;
  position: relative;
}

.artist-profile {
  width: 135px;
  height: 135px;
  border-radius: 100%;
  border: 5px solid white;
  position: absolute;
  top: 40px;
  z-index: 5000;
}
</style>
