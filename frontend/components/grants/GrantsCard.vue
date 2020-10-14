<template>
  <div class="grants-card">
    <div>
      <h5 class="grant-title">
        {{ grant.properties.name }}
      </h5>
      <div class="grant-tag-container">
        <span class="grant-tag">
          Organization and Collectives
        </span>
        <span class="grant-tag-date"> 2019 </span>
      </div>
    </div>

    <div class="grant-card-more">
      <img v-if="!hover" src="@/assets/images/go_icon_hover.svg" alt="Go" />
      <img v-else src="@/assets/images/go_icon_hover.svg" alt="Go" />
    </div>
  </div>
</template>

<script>
export default {
  components: {},
  props: {
    grant: {
      type: Object,
      default: () => {
        return {}
      }
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    },
    go: {
      type: Boolean,
      default: true
    },
    variant: {
      type: String,
      default: 'normal'
    },
    icon: {
      default: 'large',
      type: String
    }
  },
  data() {
    return {
      hover: false
    }
  },
  methods: {}
}
</script>

<style lang="scss">
.grants-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  width: 100%;
  height: 100%;
  border: 1px solid #ebe6dc;
  padding: 0.5em 0em 0.5em 0.5em;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);

  .grant-title {
    font: Bold 16px/18px Proxima Nova;
    color: #707070;
    margin: 0.1em;
    padding: 0;
  }

  &:hover {
    border: 1px solid #b57936;

    .fpcc-card-more {
      background-color: #00333a;
    }
  }
}

.grant-tag-container {
  display: flex;
  margin: 1em 0;

  & > span {
    margin-right: 1em;
    border-radius: 20px;
    padding: 5px 10px;
    font-size: 0.8em;
    font-weight: 800;
  }

  .grant-tag {
    background-color: #7d6799;
    color: #fff;
  }

  .grant-tag-date {
    background-color: #ddd4c6;
    color: #000;
  }
}
</style>
