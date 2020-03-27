<template>
  <div v-show="showGallery" id="gallery-modal" class="gallery-modal">
    <img
      class="btn-close"
      src="@/assets/images/close_icon_white.svg"
      alt="Close"
      @click="toggleGallery"
    />

    <div class="gallery-carousel-container">
      <div class="carousel-gallery-container">
        <div class="artist-gallery-detail">
          <img class="artist-img-small" src="@/assets/images/arts/img-1.jpg" />
          <div class="gallery-title">
            <span>Hi-res Photos</span>
            <span>By Patrick Kelly</span>
          </div>
          <img class="art-type" src="@/assets/images/arts/img-1.jpg" />
        </div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    showGallery: {
      type: Boolean,
      default: false
    },
    toggleGallery: {
      type: Function,
      default: () => {
        return {}
      }
    }
  }
}
</script>

<style>
.gallery-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100vw;
  height: 100vh;
  overflow-y: hidden;
  overflow-x: hidden;
  z-index: 500000;
  border: 1px solid red;
  background-color: rgba(0, 0, 0, 0.8);
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
}

.gallery-carousel-container {
  display: flex;
  justify-content: space-between;
  width: 100vw;
  padding: 0 2em;
}
.carousel-gallery {
  flex-basis: 60%;
  margin: 2em;
}
</style>
