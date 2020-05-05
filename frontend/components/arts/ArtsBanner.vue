<template>
  <ArtistBanner>
    <template v-slot:header>
      <img class="artist-header" :src="getMediaUrl(artistBanner)" />
      <div class="fpcc-card-more" @click.prevent="handleReturn">
        <img class="ml-1" src="@/assets/images/return_icon_hover.svg" />
        <span class="ml-1 font-weight-bold">Return</span>
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
          <h5 class="item-title">
            {{ name }}
          </h5>
          <h5 class="item-subtitle">
            {{ arttype | art_type }}
          </h5>
        </div>
        <div class="artist-tags-container">
          <span
            v-for="tag in tags"
            :key="tag.name"
            @click="redirectToHome(tag.name)"
            >{{ tag.name }}</span
          >
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
import { getMediaUrl } from '@/plugins/utils.js'

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
    redirectToHome(name) {
      this.$store.commit('arts/setFilter', this.arttype)
      this.$store.commit('arts/setTaxonomyTag', [name])
      this.resetState()
      this.$router.push({
        path: '/art'
      })
    },
    handleReturn() {
      this.resetState()

      if (this.server) {
        this.$router.push({
          path: '/art'
        })
      } else {
        this.$router.go(-1)
      }
    },
    resetState() {
      this.$store.commit('sidebar/setDrawerContent', false)
      this.$store.commit('sidebar/setMobileContent', false)
    },
    artistImg() {
      return (
        getMediaUrl(this.artImage) || require(`@/assets/images/artist_icon.svg`)
      )
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
.fpcc-card-more {
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  position: absolute;
  right: 0;
  top: 30%;
  width: 90px;
  height: 35px;
  background-color: #b47a2b;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
  z-index: 50000;
  padding: 1em;
}

.fpcc-card-more:hover {
  color: white;
  background-color: #454545;
}

.fpcc-card-more img {
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
  left: 2%;
  display: flex;
  justify-content: center;
  align-items: center;
}

.artist-more-btn {
  font: Regular 14px/17px Proxima Nova;
  color: #707070;
  margin-bottom: 1em;
}

.artist-more-btn img {
  margin-left: 1em;
}

.fpcc-card {
  border: 0;
  box-shadow: none;
}

.artist-header {
  object-fit: cover;
  width: 100%;
  height: 125px;
  background-color: #03333a;
  border: none;
  outline: none;
  padding: 0;
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
  margin-top: 0.5em;
}

.artist-tags-container span {
  cursor: pointer;
  flex: 0 1 auto;
  background: #707070;
  border-radius: 2rem;
  text-transform: uppercase;
  font: Bold 12px/15px Proxima Nova;
  color: #ffffff;
  padding: 2px 8px;
  margin: 0.25em;
  text-align: center;
}

.artist-tags-container span:hover {
  color: #fff;
  background-color: #545b62;
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
  object-fit: cover;
  border-radius: 100%;
  border: 5px solid white;
  background-color: #fff;
  position: absolute;
  top: 40px;
  z-index: 5000;
}
</style>
