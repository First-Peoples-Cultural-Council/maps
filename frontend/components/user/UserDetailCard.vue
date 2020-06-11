<template>
  <ArtistBanner>
    <template v-slot:header>
      <img class="artist-header" src="@/assets/images/default_banner.png" />
      <div class="fpcc-card-more" @click.prevent="handleReturn">
        <img class="ml-1" src="@/assets/images/return_icon_hover.svg" />
        <span class="ml-1 font-weight-bold">Return</span>
      </div>

      <img class="artist-profile" :src="artImage" />
    </template>
    <template v-slot:body>
      <div class="arts-artist-content">
        <div class="artist-title">
          <h5 class="item-title">
            {{ name }}
          </h5>
          <h5 class="item-subtitle">
            USER
          </h5>
        </div>
        <!-- <div class="artist-tags-container">
          <span
            v-for="tag in tags"
            :key="tag.name"
            @click="redirectToHome(tag.name)"
            >{{ tag.name }}</span
          >
        </div> -->

        <div v-if="edit && id" class="d-inline-block">
          <CardBadge
            content="Edit"
            type="edit"
            @click.native="
              $router.push({
                path: `/profile/edit/${id}`
              })
            "
          ></CardBadge>
        </div>
        <div v-if="approval && id" class="d-inline-block">
          <CardBadge
            content="Approval"
            type="edit"
            @click.native="
              $router.push({
                path: `/profile/approvals`
              })
            "
          ></CardBadge>
        </div>
      </div>
    </template>
  </ArtistBanner>
</template>

<script>
import CardBadge from '@/components/CardBadge.vue'
import ArtistBanner from '@/components/arts/ArtistBanner.vue'

export default {
  components: {
    CardBadge,
    ArtistBanner
  },
  props: {
    name: {
      type: String,
      default: ''
    },
    color: {
      type: String,
      default: 'RGB(0, 0, 0)'
    },
    detail: {
      type: Boolean,
      default: false
    },
    audioFile: {
      type: String,
      default: null
    },
    link: {
      type: String,
      default: ''
    },
    edit: {
      type: Boolean,
      default: null
    },
    id: {
      type: Number,
      default: null
    },
    approval: {
      type: Boolean,
      default: false
    },
    artImage: {
      type: String,
      default: ''
    },
    handleReturn: {
      type: Function,
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
  computed: {
    comingFromDetail() {
      return this.$store.state.languages.comingFromDetail
    }
  },
  methods: {
    handlePronounce() {
      this.audio = this.audio || new Audio(this.audioFile)
      if (this.audio.paused) {
        this.audio.play()
      } else {
        this.audio.pause()
      }
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
  background: #ddd4c6;
  border-radius: 2rem;
  color: #707070;
  text-transform: uppercase;
  font: Bold 12px/15px Proxima Nova;
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
  border: 5px solid #fff;
  background-color: #fff;
  position: absolute;
  top: 40px;
  z-index: 5000;
  box-shadow: 0 1px 1px rgba(0, 0, 0, 0.07);
}

.fpcc-card {
  border: 0;
  box-shadow: none;
}

.item-title {
  font: Bold 18px/22px Proxima Nova;
  color: #151515;
  margin: 0;
}

.item-subtitle {
  width: fit-content;
  font: Bold 15px/18px Proxima Nova;
  color: #707070;
  text-transform: capitalize;
  margin: 0;
}
</style>
