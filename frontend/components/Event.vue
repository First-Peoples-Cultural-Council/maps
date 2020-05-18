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
  height: auto;
  max-height: 650px;
}

.popover-body {
  padding: 0;
}
</style>
