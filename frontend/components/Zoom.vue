<template>
  <div class="zoom-container">
    <span class="zoomin" @click="zoomIn">
      <img src="@/assets/images/plus_icon.svg" alt="Zoom In" />
    </span>
    <span class="zoomout" @click="zoomOut">
      <img src="@/assets/images/minus_icon.svg" alt="Zoom Out" />
    </span>
  </div>
</template>

<script>
export default {
  computed: {
    mapinstance() {
      return this.$store.state.mapinstance.mapinstance
    }
  },
  methods: {
    zoomIn() {
      this.$eventHub.whenMap(map => {
        map.zoomIn()
      })
    },
    zoomOut() {
      this.$eventHub.whenMap(map => {
        map.zoomOut()
      })
    }
  }
}
</script>

<style>
.zoom-container {
  display: flex;
  align-items: center;
  background-color: white;
  border: 1px solid #ddd5cc;
  border-radius: 3em;
  cursor: pointer;
  padding: 0 0.5em;
  box-sizing: border-box;
}
.zoomin,
.zoomout {
  display: inline-block;
  line-height: 0;
  text-align: center;
  height: 100%;
  padding: 0.35em 0.5em;
}

.zoomin {
  border-right: 1px solid #ddd5cc;
}

.zoomin img,
.zoomout img {
  display: inline-block;
  width: 15px;
}
</style>
