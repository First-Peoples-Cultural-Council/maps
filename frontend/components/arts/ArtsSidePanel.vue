<template>
  <div class="arts-right-panel">
    <div class="panel-field-container">
      <span class="panel-field-title">Hi-Resolution Photos</span>
      <div class="arts-img-pagination">
        <div class="arts-img-item" @click="openGallery(0)">
          <img src="@/assets/images/arts/img-1.jpg" />
        </div>
        <div class="arts-img-item" @click="openGallery(1)">
          <img src="@/assets/images/arts/img-2.jpg" />
        </div>
        <div class="arts-img-item" @click="openGallery(2)">
          <img src="@/assets/images/arts/img-3.jpg" />
        </div>
        <div class="arts-img-item" @click="openGallery(3)">
          <img src="@/assets/images/arts/img-4.jpg" />
        </div>
      </div>
    </div>

    <div v-show="showGallery" id="gallery-modal" class="gallery-modal">
      <img
        class="btn-close"
        src="@/assets/images/close_icon.svg"
        alt="Close"
        @click="closeGallery"
      />

      <div class="gallery-carousel-container">
        <button
          class="previous-btn"
          :disabled="canNavigatePrevious"
          @click="previousSlide"
        >
          <img src="@/assets/images/return_icon_hover.svg" />
        </button>

        <div class="carousel-gallery-container">
          <div class="artist-gallery-detail">
            <img
              class="artist-img-small"
              src="@/assets/images/arts/img-1.jpg"
            />
            <div class="gallery-title">
              <span>Hi-res Photos</span>
              <span>By Patrick Kelly</span>
            </div>
            <img class="art-type" src="@/assets/images/arts/img-1.jpg" />
          </div>
          <b-carousel
            id="carousel-no-animation"
            ref="galleryCarousel"
            class="carousel-gallery"
            no-animation
          >
            <b-carousel-slide
              class="slide-image"
              img-src="@/assets/images/arts/img-1.jpg"
            >
            </b-carousel-slide>
            <b-carousel-slide
              class="slide-image"
              img-src="@/assets/images/arts/img-2.jpg"
            >
            </b-carousel-slide>
            <b-carousel-slide
              class="slide-image"
              img-src="@/assets/images/arts/img-3.jpg"
            >
            </b-carousel-slide>
            <b-carousel-slide
              class="slide-image"
              img-src="@/assets/images/arts/img-4.jpg"
            >
            </b-carousel-slide>
          </b-carousel>
        </div>

        <button :disabled="canNavigateNext" @click="nextSlide">
          <img src="@/assets/images/go_icon_hover.svg" />
        </button>
      </div>

      <div class="gallery-img-pagination">
        <div
          :class="`arts-img-item ${currentIndex === 0 ? 'is-selected' : ''}`"
          @click="selectCurrentIndex(0)"
        >
          <img src="@/assets/images/arts/img-1.jpg" />
        </div>

        <div
          :class="`arts-img-item ${currentIndex === 1 ? 'is-selected' : ''}`"
          @click="selectCurrentIndex(1)"
        >
          <img src="@/assets/images/arts/img-2.jpg" />
        </div>
        <div
          :class="`arts-img-item ${currentIndex === 2 ? 'is-selected' : ''}`"
          @click="selectCurrentIndex(2)"
        >
          <img src="@/assets/images/arts/img-3.jpg" />
        </div>
        <div
          :class="`arts-img-item ${currentIndex === 3 ? 'is-selected' : ''}`"
          @click="selectCurrentIndex(3)"
        >
          <img src="@/assets/images/arts/img-4.jpg" />
        </div>
      </div>
    </div>

    <div class="panel-field-container">
      <span class="panel-field-title">Youtube Video Title Goes Here</span>
      <iframe
        width="560"
        height="315"
        src="https://www.youtube.com/embed/7PXLPzcIydw"
        frameborder="0"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
      ></iframe>
    </div>

    <div class="panel-field-container">
      <span class="panel-field-title">Sound Cloud title Goes Here</span>
      <iframe
        width="100%"
        height="166"
        scrolling="no"
        frameborder="no"
        allow="autoplay"
        src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/41395010&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"
      ></iframe>
    </div>
  </div>
</template>

<script>
export default {
  Components: {},
  data() {
    return {
      imgIndex: 0,
      showGallery: false
    }
  },
  computed: {
    currentIndex() {
      return this.imgIndex
    },
    canNavigatePrevious() {
      return this.imgIndex === 0
    },
    canNavigateNext() {
      return this.imgIndex === 3
    }
  },
  methods: {
    openGallery(index) {
      this.showGallery = true
      this.imgIndex = index
      if (this.$refs.galleryCarousel) {
        this.selectCurrentIndex(index)
      }
    },
    selectCurrentIndex(index) {
      this.imgIndex = index
      this.$refs.galleryCarousel.setSlide(index)
    },
    nextSlide() {
      this.imgIndex += 1
      this.$refs.galleryCarousel.setSlide(this.imgIndex)
    },
    previousSlide() {
      this.imgIndex -= 1
      this.$refs.galleryCarousel.setSlide(this.imgIndex)
    },
    closeGallery() {
      this.showGallery = false
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
  padding: 0 0.5em;
  border: 1px solid red;
}
.panel-field-container {
  display: flex;
  flex-direction: column;
  width: 100%;
  padding: 1.5em 1em;
  border-bottom: 1px solid #e4e4e4;
}
.arts-right-title {
  display: flex;
  flex-direction: column;
  margin: 1em;
}
.panel-field-title {
  color: #707070;
  font-size: 23px;
  font-weight: bold;
  font-size: 23px;
}

.arts-img-pagination,
.gallery-img-pagination {
  display: flex;
  width: 100%;
  justify-content: center;
}

.arts-img-item {
  width: 145x;
  height: 145px;
  margin: 0.5em;
  opacity: 1;
  border: 5px solid #fff;
  transition: border 0.2s ease-in;
}

.arts-img-item img {
  width: 135px;
  height: 135px;
}

.gallery-carousel-container {
  display: flex;
  justify-content: space-between;
  width: 100vw;
  padding: 0 2em;
}

.carousel-gallery-container {
  flex-basis: 60%;
  margin: 2em;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.carousel-gallery {
  width: 100%;
  height: 600px;
}

.artist-gallery-detail {
  position: relative;
  width: 100%;
  background-color: #fff;
  border-top-left-radius: 0.5em;
  border-top-right-radius: 0.5em;
  display: flex;
  justify-content: flex-start;
  align-items: center;
  padding: 0.5em;
}

.art-type {
  position: absolute;
  right: 0.5em;
  width: 30px;
  height: 30px;
  justify-self: flex-end;
}

.gallery-title {
  display: flex;
  flex-direction: column;
  justify-content: center;
}

.artist-img-small {
  width: 50px;
  height: 50px;
  border-radius: 100%;
}

.slide-image {
  width: 100%;
  height: 100%;
}

.slide-image > img {
  width: 100%;
  height: 600px;
}
.is-selected {
  border: 5px solid #b57936;
}

.gallery-carousel-container button {
  background: rgba(0, 0, 0, 0);
  border: 0;

  img {
    width: 50px;
    height: 50px;
  }
  &:focus {
    border: 0;
  }

  &:disabled {
    opacity: 0.4;
  }
}

.btn-close {
  position: absolute;
  top: 2%;
  right: 1%;
  width: 20px;
  height: 20px;
}

.gallery-modal {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
  overflow-y: hidden;
  overflow-x: hidden;
  z-index: 50000;
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
@media (max-width: 992px) {
  .gallery-carousel-container {
    justify-content: center;
  }
  .gallery-carousel-container button {
    display: none;
  }
  .carousel-gallery {
    flex-basis: 100%;
  }
}
</style>
