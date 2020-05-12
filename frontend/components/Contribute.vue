<template>
  <div class="contribute-container">
    <b-button v-b-modal.contribute-modal>Add to the Map</b-button>

    <b-modal
      id="contribute-modal"
      ref="c-modal"
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
        <div class="media-add-btn" @click="validateArtist($event)">
          <img
            class="add-btn"
            src="@/assets/images/artwork_icon.svg"
            alt="Zoom In"
          />
          Upload Your Artwork <span>(I'm an Artist)</span>
        </div>
        <div
          class="media-add-btn"
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
          class="media-add-btn"
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
      showMessage: false
    }
  },
  computed: {
    validatedArtist() {
      return false
    }
  },
  mounted() {
    this.$root.$on('openContributeModal', d => {
      this.showModal()
    })
  },
  methods: {
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
  bottom: -135px;
  display: flex;
  width: 100%;

  .media-add-btn {
    background: #fff;
    flex: 0 0 32.3%;
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

    .media-remove-btn {
      background-image: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PHN2ZyAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIiAgIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIgICB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiICAgeG1sbnM6aW5rc2NhcGU9Imh0dHA6Ly93d3cuaW5rc2NhcGUub3JnL25hbWVzcGFjZXMvaW5rc2NhcGUiICAgd2lkdGg9IjIwIiAgIGhlaWdodD0iMjAiICAgaWQ9InN2ZzU3MzgiICAgdmVyc2lvbj0iMS4xIiAgIGlua3NjYXBlOnZlcnNpb249IjAuOTErZGV2ZWwrb3N4bWVudSByMTI5MTEiICAgc29kaXBvZGk6ZG9jbmFtZT0idHJhc2guc3ZnIiAgIHZpZXdCb3g9IjAgMCAyMCAyMCI+ICA8ZGVmcyAgICAgaWQ9ImRlZnM1NzQwIiAvPiAgPHNvZGlwb2RpOm5hbWVkdmlldyAgICAgaWQ9ImJhc2UiICAgICBwYWdlY29sb3I9IiNmZmZmZmYiICAgICBib3JkZXJjb2xvcj0iIzY2NjY2NiIgICAgIGJvcmRlcm9wYWNpdHk9IjEuMCIgICAgIGlua3NjYXBlOnBhZ2VvcGFjaXR5PSIwLjAiICAgICBpbmtzY2FwZTpwYWdlc2hhZG93PSIyIiAgICAgaW5rc2NhcGU6em9vbT0iMjIuNjI3NDE3IiAgICAgaW5rc2NhcGU6Y3g9IjEyLjEyODE4NCIgICAgIGlua3NjYXBlOmN5PSI4Ljg0NjEzMDciICAgICBpbmtzY2FwZTpkb2N1bWVudC11bml0cz0icHgiICAgICBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjEiICAgICBzaG93Z3JpZD0idHJ1ZSIgICAgIGlua3NjYXBlOndpbmRvdy13aWR0aD0iMTAzMyIgICAgIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijc1MSIgICAgIGlua3NjYXBlOndpbmRvdy14PSIyMCIgICAgIGlua3NjYXBlOndpbmRvdy15PSIyMyIgICAgIGlua3NjYXBlOndpbmRvdy1tYXhpbWl6ZWQ9IjAiICAgICBpbmtzY2FwZTpzbmFwLXNtb290aC1ub2Rlcz0idHJ1ZSIgICAgIGlua3NjYXBlOm9iamVjdC1ub2Rlcz0idHJ1ZSI+ICAgIDxpbmtzY2FwZTpncmlkICAgICAgIHR5cGU9Inh5Z3JpZCIgICAgICAgaWQ9ImdyaWQ1NzQ2IiAgICAgICBlbXBzcGFjaW5nPSI1IiAgICAgICB2aXNpYmxlPSJ0cnVlIiAgICAgICBlbmFibGVkPSJ0cnVlIiAgICAgICBzbmFwdmlzaWJsZWdyaWRsaW5lc29ubHk9InRydWUiIC8+ICA8L3NvZGlwb2RpOm5hbWVkdmlldz4gIDxtZXRhZGF0YSAgICAgaWQ9Im1ldGFkYXRhNTc0MyI+ICAgIDxyZGY6UkRGPiAgICAgIDxjYzpXb3JrICAgICAgICAgcmRmOmFib3V0PSIiPiAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9zdmcreG1sPC9kYzpmb3JtYXQ+ICAgICAgICA8ZGM6dHlwZSAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vcHVybC5vcmcvZGMvZGNtaXR5cGUvU3RpbGxJbWFnZSIgLz4gICAgICAgIDxkYzp0aXRsZSAvPiAgICAgIDwvY2M6V29yaz4gICAgPC9yZGY6UkRGPiAgPC9tZXRhZGF0YT4gIDxnICAgICBpbmtzY2FwZTpsYWJlbD0iTGF5ZXIgMSIgICAgIGlua3NjYXBlOmdyb3VwbW9kZT0ibGF5ZXIiICAgICBpZD0ibGF5ZXIxIiAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCwtMTAzMi4zNjIyKSI+ICAgIDxwYXRoICAgICAgIHN0eWxlPSJjb2xvcjojMDAwMDAwO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7dmlzaWJpbGl0eTp2aXNpYmxlO2ZpbGw6IzAwMDAwMDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZTtzdHJva2Utd2lkdGg6MC45OTk5OTk4MjttYXJrZXI6bm9uZTtlbmFibGUtYmFja2dyb3VuZDphY2N1bXVsYXRlIiAgICAgICBkPSJtIDEwLDEwMzUuNzc0MyBjIC0wLjc4NDkyNTMsOGUtNCAtMS40OTY4Mzc2LDAuNDYwNiAtMS44MjAzMTI1LDEuMTc1OCBsIC0zLjE3OTY4NzUsMCAtMSwxIDAsMSAxMiwwIDAsLTEgLTEsLTEgLTMuMTc5Njg4LDAgYyAtMC4zMjM0NzUsLTAuNzE1MiAtMS4wMzUzODcsLTEuMTc1IC0xLjgyMDMxMiwtMS4xNzU4IHogbSAtNSw0LjU4NzkgMCw3IGMgMCwxIDEsMiAyLDIgbCA2LDAgYyAxLDAgMiwtMSAyLC0yIGwgMCwtNyAtMiwwIDAsNS41IC0xLjUsMCAwLC01LjUgLTMsMCAwLDUuNSAtMS41LDAgMCwtNS41IHoiICAgICAgIGlkPSJyZWN0MjQzOS03IiAgICAgICBpbmtzY2FwZTpjb25uZWN0b3ItY3VydmF0dXJlPSIwIiAgICAgICBzb2RpcG9kaTpub2RldHlwZXM9ImNjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2MiIC8+ICA8L2c+PC9zdmc+);
      background-color: #fff;
      width: 25px;
      height: 25px;
      position: absolute;
      bottom: 7.5px;
      right: 7.5px;
      border: 1px solid rgba(0, 0, 0, 0.125);
      border-radius: 0.25rem;
      padding: 0.25em;

      &:hover {
        border: 1px solid #f2a798;
        background-color: #fcedea !important;
      }
    }
  }
}
</style>
