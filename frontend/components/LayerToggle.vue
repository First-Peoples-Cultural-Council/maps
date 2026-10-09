<template>
  <div>
    <div class="cursor-pointer" @click="toggleLayer">
      <span class="font-08 d-inline-block"> {{ layer.name }}</span>
      <span class="float-right">
        <span v-if="id === 3" class="reserve-loading-slot">
          <b-spinner
            v-if="showReserveLoading"
            class="reserve-loading-spinner"
            label="Loading reserves"
          ></b-spinner>
        </span>
        <img v-if="on" src="@/assets/images/on.svg" alt="On" />
        <img v-else src="@/assets/images/off.svg" alt="Off" />
      </span>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    id: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      showReserveLoading: false
    }
  },
  computed: {
    layers() {
      return this.$store.state.layers.layers
    },
    layer() {
      return this.layers.find(l => l.id === this.id)
    },
    on() {
      return this.layer.active
    }
  },
  watch: {
    on(active) {
      if (!active) this.stopReserveLoading()
    }
  },
  beforeDestroy() {
    this.stopReserveLoading()
  },
  methods: {
    stopReserveLoading() {
      if (this.reserveLoadingCleanup) this.reserveLoadingCleanup()
      this.showReserveLoading = false
    },
    trackReserveLoading(map) {
      this.stopReserveLoading()

      const stop = () => this.stopReserveLoading()
      const onRender = () => {
        const reserveLayers = this.layer.layerNames.map(id => map.getLayer(id))
        const ready = reserveLayers.every(
          layer =>
            layer &&
            map.getLayoutProperty(layer.id, 'visibility') === 'visible' &&
            map.isSourceLoaded(layer.source)
        )
        if (ready) stop()
      }
      const onError = event => {
        if (
          !event.sourceId ||
          this.layer.layerNames.some(id => {
            const layer = map.getLayer(id)
            return layer && layer.source === event.sourceId
          })
        ) {
          stop()
        }
      }
      const delayTimer = setTimeout(() => {
        this.showReserveLoading = true
      }, 200)
      const timeoutTimer = setTimeout(stop, 15000)

      this.reserveLoadingCleanup = () => {
        clearTimeout(delayTimer)
        clearTimeout(timeoutTimer)
        map.off('render', onRender)
        map.off('error', onError)
        map.off('remove', stop)
        this.reserveLoadingCleanup = null
      }
      map.on('render', onRender)
      map.on('error', onError)
      map.on('remove', stop)
    },
    toggleLayer() {
      this.$eventHub.whenMap(map => {
        this.$store.commit('layers/toggleLayer', {
          layer: this.layer,
          map
        })

        if (this.id === 3) {
          if (this.on) this.trackReserveLoading(map)
          else this.stopReserveLoading()
        }

        if (this.layer.name === 'Sleeping Languages') {
          this.$eventHub.whenMap(map => {
            this.$root.$emit('updateData')
          })
        }
      })
    }
  }
}
</script>

<style scoped>
.reserve-loading-slot {
  display: inline-flex;
  width: 1rem;
  height: 0.75rem;
  vertical-align: middle;
}

.reserve-loading-spinner {
  width: 0.75rem;
  height: 0.75rem;
  border-width: 0.12rem;
}
</style>
