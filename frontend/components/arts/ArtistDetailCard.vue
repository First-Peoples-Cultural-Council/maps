<template>
  <div class="arts-detail-card">
    <ArtistBanner>
      <template v-slot:header>
        <img class="artist-header" src="@/assets/images/sample.jpg" />
        <div class="fpcc-card-more-art" @click.prevent="handleReturn">
          <img
            v-if="!hover"
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
      </template>
      <template v-slot:body>
        <div class="arts-artist-content">
          <img class="artist-profile" src="@/assets/images/sample-dp.jpg" />
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
            <span>Artist</span>
            <span>Visual</span>
            <span>Painter</span>
            <span>Carver</span>
          </div>
        </div>
      </template>
    </ArtistBanner>
  </div>
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
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {
    handleReturn() {
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
}
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
  background-color: var(--color-beige, #f4eee9);
  display: flex;
  align-items: center;
  position: absolute;
  top: 0;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}

.fpcc-card-more-art {
  padding: 0.3em;
  font-size: 0.7em;
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

.artist-header {
  object-fit: cover;
  object-position: center;
  width: 100%;
  height: 100px;
}

.artist-profile {
  width: 100px;
  height: 100px;
  border-radius: 100%;
  border: 5px solid white;
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
  margin: 0.5em;
  width: inherit;
}

.artist-tags-container span {
  flex: 0 1;
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
</style>
