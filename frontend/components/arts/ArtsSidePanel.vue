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

    <b-modal
      id="gallery-modal"
      v-model="showGallery"
      hide-footer
      hide-header
      centered
      size="xl"
      modal-class="modal-gallery"
      dialog-class="dialog-gallery"
      content-class="content-gallery"
    >
      <button class="btn-close">Close</button>
      <div class="gallery-carousel-container">
        <button :disabled="canNavigatePrevious" @click="previousSlide">
          <img src="@/assets/images/return_icon_hover.svg" alt="Go" />
        </button>

        <b-carousel
          id="carousel-no-animation"
          ref="galleryCarousel"
          class="carousel-gallery"
          no-animation
          :interval="false"
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
        <button :disabled="canNavigateNext" @click="nextSlide">
          <img src="@/assets/images/go_icon_hover.svg" />
        </button>
      </div>

      <div class="arts-img-pagination">
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
    </b-modal>

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
  width: 100%;
  height: 100%;
  box-shadow: 0px 3px 6px #00000029;
  border: 1px solid #d7d7de;
  padding: 0 0.5em;
}
.panel-field-container {
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

.arts-img-pagination {
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
  box-shadow: 0 0 4px #ccc;
  transition: border 0.2s ease-in;
}

.arts-img-item img {
  width: 135px;
  height: 135px;
}

.gallery-carousel-container {
  display: flex;
  justify-content: center;
  width: 100vw;
}
.carousel-gallery {
  flex-basis: 70%;
  margin: 2em;
}

.slide-image {
  width: 100%;
  height: 600px;
}

.slide-image > img {
  width: 100%;
  height: 600px;
}
.is-selected {
  border: 5px solid #b57936;
}

.content-gallery {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  width: 100vw;
  background: rgba(0, 0, 0, 0);
  border: 0;
}
.dialog-gallery {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-start;
  width: 100vw;
  height: 80vh;
  background: rgba(0, 0, 0, 0);
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
  top: 0;
  right: 5em;
  border: 1px solid red;
}
</style>
