<template>
  <div class="d-inline-block">
    <b-badge
      class="badge"
      :style="'background-color: ' + bgcolor"
      :class="'badge-' + mode"
    >
      <span class="badge-icon">
        <img :src="getImage" alt="Icon" />
      </span>
      <span class="badge-content">{{ content }}</span>
      <span class="badge-number">{{ number }}</span>
    </b-badge>
  </div>
</template>

<script>
export default {
  props: {
    content: {
      type: String,
      default: ''
    },
    number: {
      type: Number,
      default: 0
    },
    bgcolor: {
      type: String,
      default: '#707070'
    },
    image: {
      type: String,
      default: 'language_icon_white.svg'
    },
    type: {
      type: String,
      default: ''
    },
    mode: {
      type: String,
      default: 'neutral'
    }
  },
  computed: {
    getImage() {
      return {
        language: '/language_icon_white.svg',
        community: '/community_icon_white.svg',
        org: '/organization_icon_white.svg',
        event: '/event_icon_white.svg',
        part: '/language_icon_white.svg',
        poi: '/poi_icon_white.svg'
      }[this.type]
    }
  }
}
</script>

<style>
.badge {
  border-radius: 1em;
}
.badge-content {
  display: inline-block;
  margin: 0 0.25em;
  font-size: 1em;
}
.badge-number {
  display: inline-block;
  color: #c46257;
  background-color: white;
  height: 19px;
  width: 19px;
  text-align: center;
  border-radius: 50%;
  font-size: 0.8em;
  line-height: 19px;
}
.badge-icon {
  display: inline-block;
}
.badge-icon img {
  display: inline-block;
  width: 19px;
}

.badge-inactive {
  opacity: 0.5;
}

.badge-active {
  opacity: 1;
  box-shadow: 0px 1px 4px 2px rgba(0, 0, 0, 0.3);
}

@media (max-width: 992px) {
  .badge-icon {
    display: none;
  }

  .badge-content {
    display: inline-block;
    font-size: 0.8em;
  }
  .badge-number {
    font-size: 0.8em;
  }
}

@media (max-width: 574px) {
  .badge-icon {
    display: inline-block;
  }

  .badge-content {
    display: none;
  }
}
</style>
