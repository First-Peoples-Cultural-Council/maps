<template>
  <div class="arts-right-panel">
    <div class="panel-field-container">
      <span class="panel-field-title">Hi-Resolution Photos</span>
      <div class="arts-img-pagination">
        <div
          :class="`arts-img-item ${currentIndex === 0 ? 'is-selected' : ''}`"
          @click="selectCurrentIndex(0)"
        >
          <img src="@/assets/images/arts/img-1.jpg" />
        </div>
        <div class="arts-img-item" @click="selectCurrentIndex(1)">
          <img src="@/assets/images/arts/img-2.jpg" />
        </div>
        <div class="arts-img-item" @click="selectCurrentIndex(2)">
          <img src="@/assets/images/arts/img-3.jpg" />
        </div>
        <div class="arts-img-item" @click="selectCurrentIndex(3)">
          <img src="@/assets/images/arts/img-4.jpg" />
        </div>
      </div>
    </div>

    <!-- <b-carousel
      id="carousel-no-animation"
      ref="galleryCarousel"
      class="carousel-gallery"
      no-animation
      indicators
    >
      <b-carousel-slide
        class="slide-image"
        caption="First Slide"
        img-src="@/assets/images/arts/img-1.jpg"
      >
      </b-carousel-slide>
      <b-carousel-slide
        class="slide-image"
        caption="Second Slide"
        img-src="@/assets/images/arts/img-2.jpg"
      ></b-carousel-slide>
      <b-carousel-slide
        class="slide-image"
        caption="Second Slide"
        img-src="@/assets/images/arts/img-3.jpg"
      ></b-carousel-slide>
      <b-carousel-slide
        class="slide-image"
        caption="Second Slide"
        img-src="@/assets/images/arts/img-4.jpg"
      ></b-carousel-slide>
    </b-carousel> -->
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
      imgIndex: 0
    }
  },
  computed: {
    currentIndex() {
      return this.imgIndex
    }
  },
  methods: {
    selectCurrentIndex(index) {
      this.$refs.galleryCarousel.setSlide(index)
    }
  }
}
</script>

<style>
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
.arts-img-item img {
  width: 135px;
  height: 135px;
  display: block;
}
.arts-img-item {
  width: 135px;
  height: 135px;
  margin: 0.5em;
  opacity: 1;
  box-sizing: border-box;
  border: 5px solid #fff;
  box-shadow: 0 0 4px #ccc;
}

.carousel-gallery {
  margin: 2em;
}

.slide-image {
  width: 500px;
  height: 500px;
  overflow: hidden;
}
</style>
