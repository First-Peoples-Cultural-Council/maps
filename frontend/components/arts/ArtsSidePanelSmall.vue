<template>
  <div class="arts-right-panel">
    <div class="panel-header">
      <div class="panel-close-btn">
        <img src="@/assets/images/go_icon_hover.svg" alt="Go" />
        Close
      </div>
    </div>
    <div v-for="artist in listOfArtists" :key="artist.id" class="panel-artist">
      <img class="artist-img-small" :src="artist.image" />
      <div class="panel-details">
        <span>{{ artist.name }}</span>
        <div>Check Profile</div>
      </div>
    </div>
    <b-row class="m-1 media-list-container">
      <b-col
        v-for="media in listOfMedias"
        :key="media.id"
        lg="12"
        xl="12"
        md="6"
        sm="6"
      >
        <MediaCard
          class="mt-3 hover-left-move"
          :media="media"
          :geometry="art.geometry"
        >
        </MediaCard>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import MediaCard from '@/components/MediaCard.vue'

export default {
  components: {
    MediaCard
  },
  props: {
    art: {
      type: Object,
      default: () => {
        return {}
      }
    }
  },
  data() {
    return {
      imgIndex: 0,
      showGallery: false
    }
  },
  computed: {
    listOfArtists() {
      return this.art.properties.artists
    },
    listOfMedias() {
      return this.art.properties.medias
    }
  },
  mounted() {
    console.log('ARTS SIDE PANEL', this.art)
  }
}
</script>

<style lang="scss">
.arts-right-panel {
  display: flex;
  background: #f9f9f9 0% 0% no-repeat padding-box;
  box-shadow: 0px 3px 6px #00000029;
  border: 1px solid #d7d7de;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  height: 100%;
}

.panel-header {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  padding: 1em;
  position: relative;
}

.panel-details {
  display: flex;
  flex-direction: column;
  justify-content: center;
  box-sizing: content-box;
  margin-left: 0.5em;
}

.panel-details div {
  background-color: #b57936;
  border-radius: 3em;
  color: #fff;
  padding: 0.2em;
  text-align: center;
}

.panel-artist {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  padding: 1em;
}

.panel-close-btn {
  position: absolute;
  right: 0;
  width: 20%;
  background-color: #953920;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: space-around;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
  z-index: 50000;
}

.artist-img-small {
  width: 50px;
  height: 50px;
  border-radius: 100%;
}

.panel-item-list {
  display: flex;
  flex-direction: column;
  padding: 0.5em;
}

.media-list-container {
  width: 100%;
}
</style>
