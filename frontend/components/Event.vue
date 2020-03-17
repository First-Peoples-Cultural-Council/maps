<template>
  <div class="navbar-container cursor-pointer hide-mobile">
    <nav id="event-icon-container">
      <span>NEXT EVENTS</span>
      <img src="@/assets/images/menu_icon.svg" alt="Menu" class="navbar-icon" />
    </nav>
    <b-popover
      target="event-icon-container"
      placement="bottom"
      triggers="click"
      :show.sync="showEvents"
    >
      <EventCard />
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
  }
}
</script>

<style lang="scss" scoped>
#event-icon-container {
  position: fixed;
  top: 10px;
  right: 100px;
  background-color: white;
  padding: 1em;
  z-index: 50;
  border: 1px solid #ddd5cc;
  border-radius: 2em;
  color: #7b7b7b;
  font-size: 13px;
  font-weight: bold;
  display: flex;
  justify-content: space-evenly;

  & > * {
    margin: 0 0.25em;
  }
}

.navbar-icon {
  display: inline-block;
  width: 15px;
  height: 15px;
  line-height: 0;
  padding: 0;
  margin: 0;
}
.popover {
  width: 350px;
  max-width: 350px;
  max-height: 800px;
  overflow-y: auto;
}

.popover-body {
}
</style>
