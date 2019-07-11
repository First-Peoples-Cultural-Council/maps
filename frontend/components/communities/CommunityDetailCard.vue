<template>
  <div class="community-detail-card">
    <Card>
      <template v-slot:header>
        <div
          class="community-detail-icon-container"
          :style="'background-color:' + color"
        >
          <img src="@/assets/images/community_icon.svg" alt="community" />
        </div>
      </template>
      <template v-slot:body>
        <div>
          <div>
            <h5
              class="font-07 m-0 p-0 color-gray text-uppercase font-weight-normal"
            >
              community
            </h5>
            <h5
              class="font-09 m-0 p-0 color-gray text-uppercase font-weight-bold"
            >
              {{ name }}
            </h5>
          </div>
          <div class="d-inline-block" @click.prevent.stop="handlePronounce">
            <CardBadge content="Pronounce"></CardBadge>
          </div>
          <div class="d-inline-block">
            <CardBadge
              v-b-modal="'share-embed-modal'"
              content="Share & Embed"
              type="share"
            ></CardBadge>
            <b-modal
              id="share-embed-modal"
              ok-title="Close"
              :ok-only="true"
              :hide-header="true"
              title="BootstrapVue"
              cancel="false"
            >
              <div class="share-embed-modal-contents">
                <h4>Share</h4>
                <p>
                  <code>{{ url }}</code>
                  <b-button
                    size="sm"
                    class="d-block mt-2"
                    variant="primary"
                    @click="copyToClip"
                    >Click To Copy</b-button
                  >
                </p>
                <h4 class="mt-4">Embed</h4>
                <p>
                  <code>{{ iframe }}</code>
                </p>
                <b-button
                  size="sm"
                  class="d-block mt-2"
                  variant="primary"
                  @click="copyToClip"
                  >Click To Copy</b-button
                >
              </div>
            </b-modal>
          </div>
        </div>
      </template>
      <template v-slot:footer>
        <div
          class="fpcc-card-more"
          @click.prevent="handleReturn"
          @mouseover.prevent="handleMouseOver"
          @mouseleave="handleMouseLeave"
        >
          <img
            v-if="!hover"
            class="ml-1"
            src="@/assets/images/return_icon.svg"
            alt="Go"
          />
          <img
            v-else
            class="ml-1"
            src="@/assets/images/return_icon_hover.svg"
            alt="Go"
          />
          <span class="ml-1 font-weight-bold">Return</span>
        </div>
      </template>
    </Card>
  </div>
</template>

<script>
import Card from '@/components/Card.vue'
import CardBadge from '@/components/CardBadge.vue'
export default {
  components: {
    Card,
    CardBadge
  },
  props: {
    name: {
      type: String,
      default: ''
    },
    color: {
      type: String,
      default: 'RGB(255, 255, 255)'
    }
  },
  data() {
    return {
      hover: false,
      origin: ''
    }
  },
  computed: {
    url() {
      return `${this.origin}${this.$route.fullPath}`
    },
    iframe() {
      return `<iframe src="${this.origin}${this.$route.fullPath}"></iframe>`
    }
  },
  mounted() {
    this.origin = window.location.origin
  },
  methods: {
    handlePronounce() {
      console.log('Pronounce')
    },
    handleReturn() {
      this.$router.push({
        path: '/first-nations'
      })
    },
    handleMouseOver() {
      this.hover = true
    },
    handleMouseLeave() {
      this.hover = false
    },
    copyToClip() {}
  }
}
</script>

<style scoped>
.community-detail-card {
  cursor: pointer;
}
.community-detail-icon-container {
  background-color: black;
  border-radius: 50%;
  height: 43px;
  width: 43px;
}
.community-detail-icon-container img {
  display: inline-block;
  width: 100%;
  height: 100%;
}
.fpcc-card-more {
  background-color: var(--color-beige);
  display: flex;
  align-items: center;
  height: 35px;
  justify-content: center;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
}

.fpcc-card-more {
  padding: 0.3em;
  font-size: 0.7em;
}

.fpcc-card-more:hover {
  color: white;
  background-color: var(--color-darkgray);
}

.fpcc-card-more img {
  display: inline-block;
  width: 15px;
  height: 15px;
}

.fpcc-card {
  border: 0;
  box-shadow: none;
}
</style>
