<template>
  <div
    v-if="isNavigating"
    class="navigating-indicator"
    role="status"
    aria-live="polite"
  >
    <div class="navigating-indicator-pill">
      <b-spinner small label="Loading"></b-spinner>
      <span>Loading…</span>
    </div>
  </div>
</template>

<script>
export default {
  computed: {
    isNavigating() {
      return this.$store.state.sidebar.isNavigating
    }
  }
}
</script>

<style>
/* Zero-height sticky wrapper: stays in view while the sidebar scrolls without shifting content. */
.navigating-indicator {
  position: sticky;
  top: 40%;
  z-index: 30;
  display: flex;
  align-items: flex-start;
  justify-content: center;
  height: 0;
  overflow: visible;
  pointer-events: none;
}

.navigating-indicator-pill {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.5rem 1rem;
  border-radius: 999px;
  background: #fff;
  color: #03333a;
  font-size: 0.875rem;
  font-weight: 600;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
  animation: navigating-fade-in 0.15s ease-out 0.08s both;
}

.navigating-indicator-pill .spinner-border {
  color: #b47a2b;
}

/* Delay the dim slightly so fast (cached) navigations don't flash. */
.is-navigating .sidebar-content,
.is-navigating #side-inner-collapse > :not(.navigating-indicator),
.is-navigating .route-child-container {
  opacity: 0.45;
  pointer-events: none;
  transition: opacity 0.15s ease-out 0.08s;
}

@keyframes navigating-fade-in {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>
