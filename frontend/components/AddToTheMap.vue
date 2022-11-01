<template>
  <div
    v-if="!isEmbed"
    class="contribute-container"
    :class="{ 'hide-contribute': hideButton }"
  >
    <b-button @click="toggleModal">
      <span>Add to the Map</span>
      <img
        src="@/assets/images/plus_white.svg"
        alt="AddToTheMap"
        class="navbar-icon"
    /></b-button>

    <b-modal
      id="contribute-modal"
      ref="c-modal"
      v-model="showContributeModal"
      hide-footer
      hide-header
      title="AddToTheMap"
    >
      <b-list-group class="contribute-option-list">
        <!--<b-list-group-item button @click="handleClick($event, 'heritage')">
          <div class="contribute-list-group-title">Edit An Existing Place</div>
          <div>
            This option will take you to the heritages tab where you can select
            an existing place, and edit from there
          </div>
        </b-list-group-item>-->
        <b-list-group-item
          button
          @click="handlePlaceClick($event, 'placename', 'Artist')"
        >
          <div class="d-flex">
            <div class="d-flex align-items-center pr-3">
              <img
                class="point-btn"
                src="@/assets/images/artist_icon.svg"
                alt="Add a line"
              />
            </div>

            <div>
              <div class="contribute-list-group-title font-weight-bold">
                Add an Artist
              </div>
              This option lets you create an Artist.
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
              For more categories please see this list provided by BC
              Geographical Names and email us at <a href="#">maps@fpcc.ca.</a>
            </div>
          </div></b-list-group-item
        >

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
              This option lets you create an Event.
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
                Add Public Art
              </div>
              This option lets you create a Public Art.
            </div>
          </div></b-list-group-item
        >

        <b-list-group-item button @click="validateArtist($event)">
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
              This options lets you upload an Artwork under your Artist profile.
              If you haven't created an Artist profile, you will be redirected
              to Artist creation.
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
    </b-modal>
    <MessageBox></MessageBox>
    <UploadModal :id="validatedArtist.id" :type="'placename'"></UploadModal>
  </div>
</template>

<script>
import MessageBox from '@/components/MessageBox.vue'
import UploadModal from '@/components/UploadModal.vue'

export default {
  components: {
    MessageBox,
    UploadModal
  },
  data() {
    return {
      showContributeModal: false,
      hideButton: false
    }
  },
  computed: {
    validatedArtist() {
      if (this.user.placename_set) {
        const foundUserArtist = this.user.placename_set.find(
          placename =>
            placename.kind === 'artist' &&
            placename.id === this.user.artist_profile
        )
        const getAllArtist = this.user.placename_set.filter(
          placename => placename.kind === 'artist'
        )
        return getAllArtist.length ? foundUserArtist || false : false
      } else {
        return false
      }
    },
    isDrawerShown() {
      return this.$store.state.sidebar.isArtsMode
    }
  },
  destroyed() {
    window.removeEventListener('resize', this.widthChecker)
  },
  mounted() {
    this.$root.$on('checkDimension', () => {
      if (window.innerWidth <= 992) {
        this.hideButton = true
      }
    })
    this.checkWindowDimemsion()
    window.addEventListener('resize', this.checkWindowDimemsion)

    this.$root.$on('openContributeModal', d => {
      this.showModal()
    })
  },
  methods: {
    checkWindowDimemsion() {
      if (window.innerWidth <= 992 && this.$route.name === 'index-grants') {
        this.hideButton = true
      } else {
        this.hideButton = false
      }
    },
    toggleModal() {
      if (this.$route.name === 'index-art' && this.isDrawerShown) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }
      this.$root.$emit('closeEventPopover')
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
      this.$root.$emit('resetValues')
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
      this.$root.$emit('resetValues')
    },
    validateArtist($event) {
      this.hideModal()

      // If doesnt have Artist profile, redirect to Artist creation
      if (!this.validatedArtist) {
        this.$store.commit('contribute/setIsDrawMode', true)
        this.$router.push({
          path: '/contribute',
          query: {
            mode: 'placename',
            type: 'Artist',
            profile: true
          }
        })
        this.$root.$emit('resetValues')
      }
      // If has Artist profile, redirect to Profile, then add Media
      else {
        this.$router.push({
          path: `/profile/${this.user.id}`,
          query: {
            upload_artwork: true
          }
        })

        this.$store.commit('sidebar/setDrawerContent', false)

        // Decide for UploadModal popup time
        const timeOut = this.$route.name === 'index-profile-id' ? 0 : 1500
        setTimeout(() => {
          this.$root.$emit('openUploadModal', {
            id: this.validatedArtist.id,
            type: 'placename'
          })
        }, timeOut)
      }
    },
    getCurrentArtist() {},
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
  font-weight: 800;
  font-size: 15px;
  color: #ffffff;
  text-transform: uppercase;
  animation: shadowpulse 5s ease infinite;

  img {
    display: none;
    width: 25px;
    height: 25px;
  }
}

.hide-contribute {
  display: none !important;
}
// For Mobile View
@media screen and (max-width: 993px) {
  .contribute-container button {
    display: flex;
    justify-content: center;
    align-items: center;
    position: fixed;
    bottom: 2%;
    right: 2.75%;
    width: 50px;
    height: 55px;
    border-radius: 100%;
    z-index: 999;
    border: 0 !important;

    span {
      display: none;
    }

    img {
      display: block !important;
    }
  }

  .contribute-option-list {
    font-size: 13px;
    font-weight: 800;
  }
}

.point-btn {
  width: 51px;
  height: 51px;
}

.contribute-container button:hover {
  color: white !important;
}

#contribute-modal {
  z-index: 99999;
}

#contribute-modal .modal-body {
  padding: 0;
  margin: 0;
  z-index: 99999;
}
</style>
