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
      target="event-icon-container"
      placement="bottom"
      triggers="click"
      :show.sync="showEvents"
    >
      <div class="event-list-container">
        <EventCard />
      </div>
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
  width: 350px;
  max-width: 350px;
  max-height: 800px;
}

.event-list-container {
  width: 330px;
  max-height: 750px;
  overflow-y: auto;
  margin: 0.5rem 0.75rem;
}
</style>
