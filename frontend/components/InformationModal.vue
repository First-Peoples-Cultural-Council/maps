<template>
  <div class="modal-container">
    <div class="information-modal">
      <div class="information-modal-header">
        <img
          src="../assets/images/symbol@2x.png"
          alt="Language Map Of British Columbia"
          height="auto"
          width="50"
        />
        <div
          style="color: white; font-size: 1.2em;"
          class="logo-container font-weight-bold ml-3"
        >
          First Peoples'
          <p class="mb-0">Map of B.C.</p>
        </div>
      </div>
      <div class="information-modal-body">
        <p>
          Welcome to the First Peoples’ Map of British Columbia! The linguistic
          information on this map is sourced from rounds of consultation with
          B.C. First Nations, and all other information is contributed by map
          users about themselves and their own communities. The First Peoples’
          Cultural Council entrusts the accuracy, reliability, and growth of
          this map to artists and Knowledge Keepers who add and maintain their
          own interactive map points representing their First Nations languages,
          arts and heritage. This map is not intended to represent the
          territorial boundaries of any First Nation; please consult individual
          nations regarding legal or official boundaries.
        </p>
        <p>
          For more information, read more about the
          <a
            href="https://firstvoices.atlassian.net/wiki/spaces/FPM/pages/1933324"
            target="_blank"
            >history of the FPCC map</a
          >.
        </p>
      </div>
      <div class="information-modal-footer">
        <button class="information-modal-btn" @click="handleClick">
          I UNDERSTAND, TAKE ME TO THE MAP
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    handleClick(e) {
      // Data expires after 30 days
      localStorage.setItem(
        'fpmap_info_modal_agreement_expiry_date',
        new Date().getTime() + 30 * 24 * 60 * 60 * 1000
      )
      this.$root.$emit('hideInformationModal')
    }
  }
}
</script>
