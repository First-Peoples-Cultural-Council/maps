<template>
  <div class="arts-right-panel">
    <div class="panel-header">
      <img class="artist-img-small" src="@/assets/images/arts/img-1.jpg" />
      <div class="panel-details">
        <span>Patrick Kelly</span>
        <span>Hope (Status Krew)</span>
        <div>Check Profile</div>
      </div>
      <div class="panel-close-btn">
        <img src="@/assets/images/go_icon_hover.svg" alt="Go" />
        Close
      </div>
    </div>
    <b-row class="m-1">
      <b-col lg="12" xl="12" md="6" sm="6">
        <ArtistCard class="mt-3 hover-left-move" :layout="'landscape'">
        </ArtistCard>
      </b-col>
      <b-col lg="12" xl="12" md="6" sm="6">
        <ArtistCard class="mt-3 hover-left-move" :layout="'landscape'">
        </ArtistCard>
      </b-col>
      <b-col lg="12" xl="12" md="6" sm="6">
        <ArtistCard class="mt-3 hover-left-move" :layout="'landscape'">
        </ArtistCard>
      </b-col>
    </b-row>
  </div>
</template>

<script>
import ArtistCard from '@/components/arts/ArtistCard.vue'

export default {
  components: {
    ArtistCard
  },
  data() {
    return {
      imgIndex: 0,
      showGallery: false
    }
  }
}
</script>

<style lang="scss">
.arts-right-panel {
  display: flex;
  background: #f9f9f9 0% 0% no-repeat padding-box;
  flex-direction: column;
  justify-content: flex-start;
  align-items: flex-start;
  height: 100%;
  box-shadow: 0px 3px 6px #00000029;
  border: 1px solid #d7d7de;
}

.panel-header {
  width: 100%;
  display: flex;
  justify-content: flex-start;
  padding: 1em;
  position: relative;
  border: 1px solid red;
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

.panel-close-btn {
  position: absolute;
  right: 0;
  width: 30%;
  background-color: #b57936;
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 1em;
  border-bottom-left-radius: 1em;
  color: #fff;
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
</style>
