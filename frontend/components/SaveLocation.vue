<template>
  <div class="share-embed-container">
    <h5 @click="toggleModal">Save Location</h5>
    <b-modal
      id="save-location-modal"
      v-model="show"
      ok-title="Close"
      :ok-only="true"
      :hide-header="true"
      title="BootstrapVue"
      cancel="false"
    >
      <div>
        <h4 class="mt-4">Save Current Location</h4>
        <label class="font-10" for="savetitle">Title</label>

        <b-form-input
          id="savetitle"
          v-model="saveTitle"
          class="font-10"
          placeholder="Enter Title (required)"
          :state="stateTitle"
          required
        ></b-form-input>
        <b-form-invalid-feedback id="title-feedback">
          Title is required
        </b-form-invalid-feedback>

        <label class="mt-3 font-10" for="savedescription">Description</label>
        <b-form-textarea
          id="savedescription"
          v-model="saveDescription"
          placeholder="Enter description"
          rows="3"
          max-rows="6"
          class="mt-2 mb-2 font-10"
        ></b-form-textarea>
        <p class="mt-2 mb-2 font-08 text-info">
          <i>
            NOTE: The Save Location function allows the system to memorize the
            current view of your map, including the zoom level. This is
            especially helpful when you want to monitor specific areas in the
            map only. These shortcuts are accessible in your profile (Click on
            your username at the upper right corner of the screen).
          </i>
        </p>
        <b-button
          size="sm"
          class="d-block mt-2 clipboard"
          variant="primary"
          data-clipboard-target="#iframeShare"
          @click="handleSave"
          >Save Location</b-button
        >
      </div>
    </b-modal>
  </div>
</template>

<script>
export default {
  data() {
    return {
      saveTitle: null,
      saveDescription: null,
      stateTitle: null,
      show: false
    }
  },
  computed: {
    lat() {
      return this.$store.state.mapinstance.lat
    },
    lng() {
      return this.$store.state.mapinstance.lng
    },
    zoom() {
      return this.$store.state.mapinstance.zoom
    }
  },
  methods: {
    toggleModal() {
      this.show = !this.show
      this.$store.commit('sidebar/setDrawerContent', false)
    },
    async handleSave() {
      this.show = false

      if (!this.saveTitle) {
        this.stateTitle = false
        return false
      }

      if (!this.lng || !this.lat) {
        this.$root.$emit('notification', {
          title: 'Failed To Save Location',
          message:
            'Latitude or Longitude is not defined. Please wait until the map has stopped moving',
          time: 1500,
          variant: 'danger'
        })
        return false
      }

      const point = {
        type: 'Point',
        coordinates: [this.lng, this.lat]
      }

      const data = {
        name: this.saveTitle,
        favourite_type: 'saved_location',
        description: this.saveDescription,
        point,
        zoom: parseInt(this.zoom)
      }

      const result = await this.$store.dispatch('user/saveLocation', data)
      if (result.status === 'failed') {
        this.$root.$emit('notification', {
          title: 'Failed',
          message: 'Location save failed (unspecified error)',
          time: 1500,
          variant: 'danger'
        })
        return false
      }
      if (
        result.request.status === 201 &&
        result.request.statusText === 'Created'
      ) {
        this.$root.$emit('notification', {
          title: 'Success',
          message: 'Location has been saved sucessfully',
          time: 1500,
          variant: 'success'
        })
        return true
      }
    }
  }
}
</script>

<style></style>
