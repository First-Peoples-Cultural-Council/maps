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
              This options lets you upload an Artwork under your Artist profile.
              If you haven't created an Artist profile, you will be redirected
              to Artist creation.
            </div>
          </div></b-list-group-item
        >
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
              This option lets you create an Artist. This Artist will be shown
              in the Arts Panel.
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
              the Arts Panel.
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
              shown in the Arts Panel.
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
              will be shown in the Arts Panel.
            </div>
          </div></b-list-group-item
        >
      </b-list-group>
    </b-modal>
    <MessageBox
      v-if="showMessage"
      :show-modal="showMessage"
      :message="
        `You cannot add an Artwork, you need to create your Artist profile before uploading Artwork. You will be redirected to
          Artist Creation. If done, you will be able to upload Artwork under your name.`
      "
      :toggle-modal="toggleMessageBox"
    ></MessageBox>
    <UploadModal :id="validatedArtist.id" :type="'placename'"></UploadModal>
  </div>
</template>

<script>
import MessageBox from '@/components/MessageBox.vue'
import UploadModal from '@/components/UploadModal.vue'
import { encodeFPCC } from '@/plugins/utils.js'

export default {
  components: {
    MessageBox,
    UploadModal
  },
  data() {
    return {
      showMessage: false,
      showContributeModal: false
    }
  },
  computed: {
    validatedArtist() {
      if (this.userDetail.placename_set) {
        const foundUserArtist = this.userDetail.placename_set.find(
          placename =>
            placename.kind === 'artist' &&
            placename.name ===
              `${this.userDetail.first_name} ${this.userDetail.last_name}`
        )
        const getAllArtist = this.userDetail.placename_set.filter(
          placename => placename.kind === 'artist'
        )
        return getAllArtist.length ? foundUserArtist || false : false
      } else {
        return false
      }
    },

    userDetail() {
      return this.$store.state.user.user
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
      if (this.$route.name === 'index-art' && this.isDrawerShown) {
        this.$store.commit('sidebar/setDrawerContent', false)
      }
      this.$root.$emit('closeEventPopover')
      this.showContributeModal = !this.showContributeModal
    },
    toggleMessageBox() {
      this.showMessage = !this.showMessage
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
      // This solution is temporary
      // window.location.href = `/contribute?mode=${data}`
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
      // This solution is temporary
      // window.location.href = `/contribute?mode=${data}&type=${type}`
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
        this.showMessage = true
      }
      // If has Artist profile, redirect to Profile, then add Media
      else {
        this.$router.push({
          path: `/art/${encodeFPCC(this.validatedArtist.name)}`,
          query: {
            upload_artwork: true
          }
        })

        this.$store.commit('sidebar/setDrawerContent', false)

        // Decide for UploadModal popup time
        const timeOut = this.$route.name === 'index-art-art' ? 0 : 1500
        setTimeout(() => {
          this.$root.$emit('openUploadModal')
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
