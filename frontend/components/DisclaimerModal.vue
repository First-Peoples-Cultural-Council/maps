<template>
  <div class="modal-container">
    <div class="information-modal">
      <div class="information-modal-header">
        <img
          src="@/assets/images/symbol@2x.png"
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
          FPCC does not take responsibility for the content uploaded to the
          First Peoples’ Map of B.C. We ask that users do not upload content to
          the map that may be considered sensitive or controversial. Examples of
          sensitive and/or controversial content include sacred words, songs,
          stories, ceremonial objects, and sites; ancestral burial sites;
          heritage sites on contested territories; personal information;
          pictograph, petroglyphs, and dinosaur trackways, etc.
        </p>
      </div>
      <div class="information-modal-footer">
        <button class="information-modal-btn" @click="handleClick">
          I UNDERSTAND, CONTINUE TO UPLOAD
        </button>
      </div>
    </div>
  </div>
</template>

<script>
import * as Cookies from 'js-cookie'

export default {
  methods: {
    handleClick(e) {
      Cookies.set('fpmap_info_disclaimer_understood', true, {
        expires: new Date().getTime() + 30 * 24 * 60 * 60 * 1000
      })

      this.$root.$emit('toggleDisclaimerModal')
      this.$root.$emit('toggleContributeModal')
    }
  }
}
</script>
