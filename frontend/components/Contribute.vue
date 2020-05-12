<template>
  <div class="contribute-container">
    <b-button @click="toggleModal">Add to the Map</b-button>

    <b-modal
      id="contribute-modal"
      ref="c-modal"
      v-model="showContributeModal"
      hide-footer
      hide-header
      title="Contribute"
    >
      <b-list-group>
        <!--<b-list-group-item button @click="handleClick($event, 'heritage')">
          <div class="contribute-list-group-title">Edit An Existing Place</div>
          <div>
            This option will take you to the heritages tab where you can select
            an existing place, and edit from there
          </div>
        </b-list-group-item>-->
        <b-list-group-item button @click="handleClick($event, 'point')">
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                src="@/assets/images/add_point_icon_big.svg"
                alt="Add a point"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add a point
              </div>
              This option triggers drawing mode, where you will be able to
              select a specific point to contribute
            </div>
          </div></b-list-group-item
        >
        <b-list-group-item button @click="handleClick($event, 'polygon')">
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                src="@/assets/images/add_area_icon_big.svg"
                alt="Add an area"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add an area
              </div>
              This option triggers drawing mode, where you will be able to draw
              a polygon to contribute
            </div>
          </div></b-list-group-item
        >

        <b-list-group-item button @click="handleClick($event, 'line')">
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                src="@/assets/images/add_area_icon_big.svg"
                alt="Add a line"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add a line
              </div>
              This option triggers drawing mode, where you will be able to draw
              a line to contribute
            </div>
          </div></b-list-group-item
        >
      </b-list-group>
      <div class="placename-btn-container">
        <div class="placename-add-btn" @click="validateArtist($event)">
          <img
            class="add-btn"
            src="@/assets/images/artwork_icon.svg"
            alt="Zoom In"
          />
          Upload Your Artwork <span>(I'm an Artist)</span>
        </div>
        <div
          class="placename-add-btn"
          @click="handlePlaceClick($event, 'placename', 'Event')"
        >
          <img
            class="add-btn"
            src="@/assets/images/event_icon.svg"
            alt="Event"
          />
          Add An Event
        </div>
        <div
          class="placename-add-btn"
          @click="handlePlaceClick($event, 'placename', 'Public Art')"
        >
          <img
            class="add-btn"
            src="@/assets/images/public_art_icon.svg"
            alt="Public Art"
          />
          Add A Public Art
        </div>
      </div>
    </b-modal>
    <MessageBox
      :show="showMessage"
      :message="
        `You Cannot Add An Artwork, you need to be registered. Redirecting to
          Artist Creation`
      "
    ></MessageBox>
  </div>
</template>

<script>
import MessageBox from '@/components/MessageBox.vue'
export default {
  components: {
    MessageBox
  },
  data() {
    return {
      showMessage: false,
      showContributeModal: false
    }
  },
  computed: {
    validatedArtist() {
      return false
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    }
  },
  mounted() {
    this.$root.$on('openContributeModal', d => {
      this.showModal()
    })
  },
  methods: {
    toggleModal() {
      if (this.isDrawerShown) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }
      this.showContributeModal = !this.showContributeModal
    },
    handleClick(e, data) {
      this.hideModal()
      if (data === 'heritage') {
        this.$router.push({
          path: '/heritages'
        })
        return
      }
      this.$store.commit('contribute/setIsDrawMode', true)
      this.$router.push({
        path: '/contribute',
        query: {
          mode: data
        }
      })
    },
    handlePlaceClick(e, data, type) {
      this.hideModal()
      this.$store.commit('contribute/setIsDrawMode', true)
      this.$router.push({
        path: '/contribute',
        query: {
          mode: data,
          type
        }
      })
    },
    validateArtist($event) {
      this.hideModal()
      if (this.validatedArtist) {
        this.$router.push({
          path: '/profile/' + this.$store.state.user.user.id
        })
      } else {
        this.handlePlaceClick($event, 'placename', 'Artist')
        this.showMessage = true
      }
    },
    showModal() {
      this.$refs['c-modal'].show()
    },
    hideModal() {
      this.$refs['c-modal'].hide()
    }
  }
}
</script>

<style lang="scss">
.contribute-container button {
  background: url('../assets/images/logo_background.png');
  background-size: cover;
  border: 0px solid #ddd5cc;
  border-radius: 3em;
  cursor: pointer;
  margin: 0;
  padding: 0.5em 2em;
  font: Bold 15px/18px Proxima Nova;
  color: #ffffff;
  text-transform: uppercase;
}

.contribute-container button:hover {
  color: white !important;
}

#contribute-modal .modal-body {
  padding: 0;
  margin: 0;
}

/* Placename Container */
.placename-btn-container {
  z-index: 999999;
  position: absolute;
  bottom: -127.5px;
  display: flex;
  width: 100%;

  .placename-add-btn {
    background: #fff;
    flex: 0 0 33%;
    position: relative;
    display: flex;
    flex-direction: column;
    justify-content: center;
    align-items: center;
    height: 125px;
    background-clip: border-box;
    border: 1px solid rgba(0, 0, 0, 0.125);
    margin-right: 0.3%;
    font-weight: 700;
    color: #495057;

    &:hover {
      cursor: pointer;
      background-color: #f8f9fa;
    }

    img {
      width: 120px;
      height: 120px;
      object-fit: cover;
    }

    .add-btn {
      width: 40px;
      height: 40px;
    }
  }
}
</style>
