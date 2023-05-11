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
import * as Cookies from 'js-cookie'

export default {
  methods: {
    handleClick(e) {
      Cookies.set('fpmap_info_modal_understood', true, {
        expires: new Date().getTime() + 30 * 24 * 60 * 60 * 1000
      })
      this.$root.$emit('hideInformationModal')
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
