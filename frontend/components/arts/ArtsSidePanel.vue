<template>
  <div class="arts-right-panel">
    <span>Hi-res Photos</span>
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
    <b-carousel
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
    </b-carousel>
    <iframe
      width="560"
      height="315"
      src="https://www.youtube.com/embed/7PXLPzcIydw"
      frameborder="0"
      allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen
    ></iframe>

    <iframe
      width="100%"
      height="166"
      scrolling="no"
      frameborder="no"
      allow="autoplay"
      src="https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/41395010&color=%23ff5500&auto_play=false&hide_related=false&show_comments=true&show_user=true&show_reposts=false&show_teaser=true"
    ></iframe>
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
  flex-direction: column;
  justify-content: center;
  align-items: flex-start;
  width: 100%;
  height: 100%;
  margin: 0 0.2em 0 1em;
  box-sizing: border-box;
  box-shadow: 0 0 2.5px rgb(0, 0, 0);
  padding: 0.5em;
}

.arts-right-title {
  display: flex;
  flex-direction: column;
  margin: 1em;
  border-bottom: 1px solid rgb(0, 0, 0, 0.2);
}

.arts-img-pagination {
  display: flex;
  padding-bottom: 0.5em;
  border-bottom: 1px solid rgba(0, 0, 0, 0.2);
}
.arts-img-item img {
  width: 100px;
  height: 100px;
  display: block;
}
.arts-img-item {
  width: 100px;
  height: 100px;
  margin: 0.5em;
  opacity: 0.4;
  box-sizing: border-box;
}

.carousel-gallery {
  margin: 2em;
}

.slide-image {
  width: 500px;
  height: 500px;
  overflow: hidden;
}
.is-selected {
  opacity: 1;
  border: 5px solid #fff;
  box-shadow: 0 0 4px #ccc;
}
</style>
