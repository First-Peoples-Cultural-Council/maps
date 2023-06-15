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

<style lang="scss">
.modal-container {
  position: fixed;
  background-color: rgba(40, 40, 40, 0.7);
  top: 0;
  left: 0;
  width: 100vw;
  height: 100vh;
  z-index: 500000;
  overflow: hidden;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  font-weight: 800;
  font-size: 16px;

  .information-modal {
    background-color: white;
    border-radius: 5px;
    overflow: hidden;
    max-width: 500px;
    font-weight: normal;
    display: flex;
    flex-direction: column;

    .information-modal-header {
      display: flex;
      align-items: center;
      background: url('../assets/images/logo_background.png');
      padding: 16px 24px;

      .logo-container {
        display: flex;
        align-items: flex-start;
        flex-direction: column;
        background-size: cover;
        background-position: center;
        text-transform: uppercase;
        font: Medium 20px/22px;
        letter-spacing: 1px;

        p {
          margin: 0;
          font-size: 0.7em;
          letter-spacing: 0.65px;
          font: Medium 13px/22px;
        }
      }
    }

    .information-modal-body {
      overflow: auto;
      margin-bottom: 16px;

      p {
        margin: 16px 24px;
        line-height: 1.75;
      }

      p:last-child {
        margin-bottom: 0;
      }
    }

    .information-modal-footer {
      display: flex;
      flex-direction: row;
      justify-content: flex-end;
      padding: 16px 24px;
      padding-top: 0;

      .information-modal-btn {
        background: url('../assets/images/logo_background.png');
        background-size: cover;
        border: 0px solid #ddd5cc;
        border-radius: 3em;
        cursor: pointer;
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
    }
  }

  @media screen and (max-width: 516px) {
    .information-modal {
      max-width: 90vw;
      max-height: 90vh;
    }

    .information-modal-footer {
      .information-modal-btn {
        margin: auto;
      }
    }
  }
}
</style>
