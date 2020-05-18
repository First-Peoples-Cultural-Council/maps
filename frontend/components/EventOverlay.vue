<template>
  <div v-if="show">
    <div class="event-overlay-container">
      <div class="event-header-container">
        <img
          src="@/assets/images/event_icons.svg"
          alt="Event"
          class="event-icon"
        />
        <span>EVENTS</span>
        <img
          class="event-close-btn"
          src="@/assets/images/close_icon.svg"
          alt="Close"
          @click="closeEvent"
        />
      </div>

      <!-- Shows List of Events  -->
      <EventCard />
    </div>
  </div>
</template>
<script>
import EventCard from '@/components/EventCard.vue'
export default {
  components: {
    EventCard
  },
  props: {
    show: {
      default: false,
      type: Boolean
    }
  },
  methods: {
    closeEvent() {
      this.$root.$emit('toggleEventOverlay', true)
    }
  }
}
</script>
<style>
.event-overlay-container {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  width: 100%;
  height: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  z-index: 5000;
  background-color: white;
  padding: 1em;
}

.event-header-container {
  display: flex;
  align-items: center;
  justify-content: flex-start;
  position: relative;
}

.event-header-container span {
  font-weight: bold;
  font-size: 13px;
  letter-spacing: 0;
  color: #7b7b7b;
  margin: 5px 0 0 5px;
}

.event-icon {
  width: 25px;
  height: 25px;
}

.event-close-btn {
  position: absolute;
  right: 10px;
  width: 18px;
  height: 18px;
}
</style>
