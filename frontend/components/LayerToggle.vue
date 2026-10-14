<template>
  <div>
    <div class="cursor-pointer" @click="toggleLayer">
      <span class="font-08 d-inline-block"> {{ layer.name }}</span>
      <span class="float-right">
        <span class="layer-loading-slot">
          <b-spinner
            v-if="showLoading"
            class="layer-loading-spinner"
            :label="'Loading ' + layer.name"
          ></b-spinner>
        </span>
        <img v-if="on" src="@/assets/images/on.svg" alt="On" />
        <img v-else src="@/assets/images/off.svg" alt="Off" />
      </span>
    </div>
  </div>
</template>

<script>
import isEqual from 'lodash/isEqual'

export default {
  props: {
    id: {
      type: Number,
      default: null
    }
  },
  data() {
    return {
      showLoading: false
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
    },
    isFilterToggle() {
      return this.layer.name === 'Sleeping Languages'
    }
  },
  watch: {
    on(active) {
      if (!active && !this.isFilterToggle) this.stopLoading()
    }
  },
  beforeDestroy() {
    this.stopLoading()
  },
  methods: {
    stopLoading() {
      if (this.loadingCleanup) this.loadingCleanup()
      this.showLoading = false
    },
    trackLoading(map) {
      this.stopLoading()

      const visibility = this.on ? 'visible' : 'none'
      const filter = this.on ? ['!=', 'name', ''] : ['!', ['get', 'sleeping']]

      const stop = () => this.stopLoading()
      const onRender = () => {
        const mapLayers = this.layer.layerNames
          .map(id => map.getLayer(id))
          .filter(Boolean)
        const ready =
          mapLayers.length > 0 &&
          mapLayers.every(layer => {
            const layerVisibility =
              map.getLayoutProperty(layer.id, 'visibility') || 'visible'
            const applied = this.isFilterToggle
              ? isEqual(map.getFilter(layer.id), filter)
              : layerVisibility === visibility
            return (
              applied &&
              (layerVisibility === 'none' ||
                !layer.source ||
                map.isSourceLoaded(layer.source))
            )
          })
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
        this.showLoading = true
      }, 200)
      const timeoutTimer = setTimeout(stop, 15000)

      this.loadingCleanup = () => {
        clearTimeout(delayTimer)
        clearTimeout(timeoutTimer)
        map.off('render', onRender)
        map.off('error', onError)
        map.off('remove', stop)
        this.loadingCleanup = null
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

        if (this.on || this.isFilterToggle) this.trackLoading(map)
        else this.stopLoading()

        if (this.isFilterToggle) {
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
.layer-loading-slot {
  display: inline-flex;
  width: 1rem;
  height: 0.75rem;
  vertical-align: middle;
}

.layer-loading-spinner {
  width: 0.75rem;
  height: 0.75rem;
  border-width: 0.12rem;
}
</style>
