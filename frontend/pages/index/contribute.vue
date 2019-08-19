<template>
  <div>
    <DetailSideBar :width="500">
      <section class="pr-2 pl-2">
        <label for="traditionalName">Traditional Name</label>
        <b-form-input id="traditionalName" type="text"></b-form-input>

        <label for="westernName">Western Name</label>
        <b-form-input id="westernName" type="text"></b-form-input>

        <b-row>
          <b-col xl="6">
            <label for="traditionalName">Language</label>
            <b-form-select
              v-model="selected"
              :options="options"
            ></b-form-select>
          </b-col>
          <b-col xl="6">
            <label for="traditionalName">Category</label>
            <b-form-select
              v-model="selected"
              :options="options"
            ></b-form-select>
          </b-col>
        </b-row>
        <!-- Text Editor -->
        <h5>Description</h5>
        <TuiEditor
          mode="wysiwyg"
          :options="{
            hideModeSwitch: true
          }"
          preview-style="vertical"
          height="300px"
        />

        <h5>Upload Files</h5>
        <b-form-file
          v-model="file"
          :state="Boolean(file)"
          placeholder="Choose a file or drop it here..."
          drop-placeholder="Drop file here..."
        ></b-form-file>
      </section>

      <hr />
      <section class="pl-2 pr-2">
        <b-row>
          <b-col xl="6">
            <b-button variant="primary">Preview</b-button>
          </b-col>
          <b-col xl="6">
            <b-button variant="primary">Cancel</b-button>
          </b-col>
        </b-row>
        <b-row>
          <b-col xl="12">
            <b-button variant="primary">Submit</b-button>
          </b-col>
        </b-row>
      </section>
    </DetailSideBar>
  </div>
</template>

<script>
import DetailSideBar from '@/components/DetailSideBar.vue'

export default {
  components: {
    DetailSideBar
  },
  data() {
    return {
      content: 'Hello World!'
    }
  }
}
</script>

<style></style>
