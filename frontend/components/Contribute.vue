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
                class="point-btn"
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
                class="point-btn"
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
                class="point-btn"
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
      <b-list-group class="placename-group-container">
        <b-list-group-item button class="mt-1" @click="validateArtist($event)">
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                class="point-btn"
                src="@/assets/images/artwork_icon.svg"
                alt="Add a line"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Upload Your Artwork (I'm an Artist)
              </div>
              This options lets you upload an Artwork. If you haven't created an
              Artist profile, you will be redirected to Artist creation.
            </div>
          </div></b-list-group-item
        >
        <b-list-group-item
          button
          @click="handlePlaceClick($event, 'placename', 'Event')"
        >
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                class="point-btn"
                src="@/assets/images/event_icon.svg"
                alt="Add a line"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add an Event
              </div>
              This option lets you create an Event. This event will be shown in
              the Arts Panel, and will also be shown in the maps.
            </div>
          </div></b-list-group-item
        >
        <b-list-group-item
          button
          @click="handlePlaceClick($event, 'placename', 'Public Art')"
        >
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                class="point-btn"
                src="@/assets/images/public_art_icon.svg"
                alt="Add a line"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add a Public Art
              </div>
              This option lets you create a Public Art. This Public Art will be
              shown in the Arts Panel, and will also be shown in the maps.
            </div>
          </div></b-list-group-item
        >
        <b-list-group-item
          button
          @click="handlePlaceClick($event, 'placename', 'Organization')"
        >
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                class="point-btn"
                src="@/assets/images/organization_icon.svg"
                alt="Add a line"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add an Organization
              </div>
              This option lets you create an Organization. This Organization
              will be shown in the Arts Panel, and will also be shown in the
              maps.
            </div>
          </div></b-list-group-item
        >
      </b-list-group>
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
      return this.userPlacenames.find(placename => placename.kind === 'artist')
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    },
    userPlacenames() {
      return this.$store.state.user.user.placename_set
    }
  },
  mounted() {
    console.log(this.validatedArtist)
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

.point-btn {
  width: 51px;
  height: 51px;
}

.contribute-container button:hover {
  color: white !important;
}

#contribute-modal .modal-body {
  padding: 0;
  margin: 0;
}

.placename-group-container {
  position: absolute;
  top: 294px;
}
</style>
