<template>
  <div class="cursor-pointer hide-mobile event-main-container">
    <nav id="event-icon-container">
      <span>EVENTS</span>
      <img
        src="@/assets/images/event_icons.svg"
        alt="Menu"
        class="navbar-icon"
      />
    </nav>
    <b-popover
      id="event-popover-container"
      target="event-icon-container"
      placement="bottom"
      triggers="click"
      :show.sync="showEvents"
    >
      <div class="event-list-container">
        <EventCard />
        <EventCard />
        <EventCard />
        <EventCard />
      </div>
    </b-popover>
  </div>
</template>

<script>
import EventCard from '@/components/EventCard.vue'
import { getApiUrl } from '@/plugins/utils.js'
export default {
  components: {
    EventCard
  },
  data() {
    return {
      showEvents: false
    }
  },
  computed: {
    arts() {
      return this.$store.state.arts.arts
        .filter(art => art.properties.kind === 'event')
        .slice(0, 7)
    }
  },
  mounted() {
    const url = `${getApiUrl('arts')}/event`

    const loaded = this.$store.dispatch('arts/isKindLoaded', 'event')
    const artsIds = this.$store.dispatch('arts/getArtsGeoIds')

    if (!loaded) {
      // Fetch Arts
      const data = this.$axios.$get(url)

      if (data) {
        // Set data with name for clarity
        const artsSet = data.features
        const arts = artsSet.filter(datum => artsIds.includes(datum.id)) // Filtered based on map bounds

        // Set language stores
        this.$store.commit('arts/setStore', [...this.arts, ...artsSet]) // All data
        this.$store.commit('arts/set', [...this.arts, ...arts]) // Updating data based on map
      }
    }
  },
  updated() {
    console.log('EVENTS', this.arts)
  }
}
</script>

<style lang="scss" scoped>
#event-icon-container {
  display: flex;
  justify-content: space-evenly;
  align-items: center;
  background-color: white;
  padding: 0.8em;
  z-index: 50;
  margin-right: 0.5em;
  box-shadow: 0px 3px 6px #00000022;
  border: 1px solid #beb2a5;
  border-radius: 2em;
  color: #151515;
  font: Bold 15px/18px Proxima Nova;

  & > * {
    margin: 0 0.25em;
  }
  .arts-container & {
    margin-right: 0.25em !important;
    width: 45px;
    height: 45px;
  }

  .arts-container & > span {
    display: none;
  }

  @media (max-width: 1200px) {
    & {
      width: 45px;
      height: 45px;
      margin-right: 0.25em;
    }
    span {
      display: none;
    }
  }
}

.navbar-icon {
  width: 23px;
  height: 23px;
  line-height: 0;
  padding: 0;
  margin: 0;
}

.popover {
  width: 425px !important;
  max-width: 425px !important;
  height: 650px;
  max-height: 650px;
}

.popover-body {
  padding: 0;
}

.event-list-container {
  overflow-y: auto;
  display: flex;
  flex-direction: column;
  justify-content: flex-start;
  align-items: center;
  height: 650px;
  max-height: 650px;
}
</style>
