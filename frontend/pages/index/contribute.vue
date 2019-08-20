<template>
  <div>
    <DetailSideBar :width="500">
      <div class="contribute-header pt-3 pb-3">
        <div>
          <h4 class="text-uppercase contribute-title mr-2">
            You are contributing to
          </h4>
        </div>
        <section class="pl-2 pr-2">
          <b-row no-gutters>
            <b-col xl="6" class="pr-1"
              ><LanguageCard
                :go="false"
                variant="white"
                icon="small"
                name="diiɁdiitidq"
              ></LanguageCard
            ></b-col>
            <b-col xl="6" class="pl-1"
              ><CommunityCard
                :go="false"
                variant="white"
                icon="small"
                name="diiɁdiitidq"
              ></CommunityCard
            ></b-col>
          </b-row>
        </section>
      </div>
      <section class="pr-3 pl-3">
        <label for="traditionalName" class="contribute-title-one mt-3"
          >Traditional Name</label
        >
        <b-form-input id="traditionalName" type="text"></b-form-input>

        <label for="westernName" class="contribute-title-one mt-3"
          >Western Name</label
        >
        <b-form-input id="westernName" type="text"></b-form-input>

        <b-row class="mt-3">
          <b-col xl="6">
            <label for="traditionalName" class="contribute-title-one"
              >Language</label
            >
            <b-form-select
              v-model="selected"
              :options="options"
            ></b-form-select>
          </b-col>
          <b-col xl="6">
            <label for="traditionalName" class="contribute-title-one"
              >Category</label
            >
            <b-form-select
              v-model="selected"
              :options="options"
            ></b-form-select>
          </b-col>
        </b-row>
        <!-- Text Editor -->
        <h5 class="contribute-title-one mt-3">Description</h5>
        <TuiEditor
          mode="wysiwyg"
          :options="{
            hideModeSwitch: true
          }"
          preview-style="vertical"
          height="300px"
        />

        <h5 class="mt-3">Upload Files</h5>
        <b-form-file
          v-model="file"
          :state="Boolean(file)"
          placeholder="Choose a file or drop it here..."
          drop-placeholder="Drop file here..."
        ></b-form-file>
      </section>

      <hr />
      <section class="pl-3 pr-3">
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
import LanguageCard from '@/components/languages/LanguageCard.vue'
import CommunityCard from '@/components/communities/CommunityCard.vue'

export default {
  components: {
    DetailSideBar,
    LanguageCard,
    CommunityCard
  },
  data() {
    return {
      content: 'Hello World!'
    }
  }
}
</script>

<style>
.contribute-header {
  background-color: #f4f0eb;
}
.contribute-title {
  background-color: #591d14;
  color: white;
  font-size: 0.8em;
  padding: 0.65em;
  text-align: right;
  font-weight: bold;
}
.contribute-title-one {
  color: #707070;
  font-weight: bold;
  font-size: 0.85em;
  padding: 0;
  margin: 0;
}
</style>
