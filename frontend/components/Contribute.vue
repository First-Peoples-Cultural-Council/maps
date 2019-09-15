<template>
  <div class="contribute-container">
    <b-button v-b-modal.contribute-modal>Contribute</b-button>

    <b-modal
      id="contribute-modal"
      ref="c-modal"
      hide-footer
      hide-header
      title="Contribute"
      s
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
        <!--
        <b-list-group-item button @click="handleClick($event, 'polygon')"
          ><div class="contribute-list-group-title">Add a polygon</div>
          <div>
            This option triggers drawing mode, where you will be able to draw a
            polygon to contribute
          </div></b-list-group-item
        >
        -->
      </b-list-group>
    </b-modal>
  </div>
</template>

<script>
export default {
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
    showModal() {
      this.$refs['c-modal'].show()
    },
    hideModal() {
      this.$refs['c-modal'].hide()
    }
  }
}
</script>

<style>
.contribute-container button {
  background: url('../assets/images/contribute_texture_color.svg');
  border: 1px solid #ddd5cc;
  border-radius: 0.5em;
  cursor: pointer;
  font-size: 0.75em;
  margin: 0;
  padding: 0.5em 2em;
  color: white;
  font-weight: 700;
  text-transform: uppercase;
}

.contribute-container .btn-secondary:focus {
  box-shadow: none !important;
}

.contribute-container .btn-secondary:hover {
  color: white !important;
  box-shadow: none !important;
  background-color: #3c110d !important;
  border: 1px solid #ddd5cc;
}

.contribute-container.show > .btn-secondary.dropdown-toggle {
  color: white !important;
  box-shadow: none !important;
  background-color: #3c110d !important;
  border: 1px solid #ddd5cc;
}

.contribute-container button:hover {
  color: white !important;
}

#contribute-modal .modal-body {
  padding: 0;
  margin: 0;
}
</style>
