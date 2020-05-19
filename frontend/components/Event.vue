<template>
  <div id="event-icon-container" class="hide-mobile">
    <span>EVENTS</span>
    <img src="@/assets/images/event_icons.svg" alt="Menu" class="menu-icon" />
    <b-popover
      target="event-icon-container"
      placement="bottom"
      triggers="click"
      :show.sync="showEvents"
    >
      <!-- Shows List of Events  -->
      <EventCard />
    </b-popover>
  </div>
</template>

<script>
import EventCard from '@/components/EventCard.vue'

export default {
  components: {
    EventCard
  },
  data() {
    return {
      showEvents: false
    }
  },
  mounted() {
    this.$root.$on('closeEventPopover', e => {
      this.showEvents = false
    })
  }
}
</script>

<style lang="scss" scoped>
#event-icon-container {
  cursor: pointer;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: white;
  padding: 0.6em;
  border-radius: 1.5em;
  z-index: 50;
  margin-right: 0.5em;
  box-shadow: 0px 3px 6px #00000022;
  border: 1px solid #beb2a5;
  color: #151515;
  font: Bold 15px/18px Proxima Nova;

  & > * {
    margin: 0 0.4em 0 0.2em;
  }

  .menu-icon {
    width: 18px;
    height: 18px;
  }

  .arts-container & {
    margin: 0 0.25em;
    width: 45px;
    height: 45px;
  }

  .arts-container & > span {
    display: none;
  }

  .arts-container & > .menu-icon {
    margin: 0;
  }

  @media (max-width: 1200px) {
    & {
      width: 45px;
      height: 45px;
      margin: 0 0.25em;
    }
    span {
      display: none;
    }
  }
}

.popover {
  width: 425px !important;
  max-width: 425px !important;
  height: auto;
  max-height: 650px;
}

.popover-body {
  padding: 0;
}
</style>
