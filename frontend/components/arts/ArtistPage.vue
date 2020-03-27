<template>
  <div v-if="isArtist" class="artist-main-container">
    <ArtistDetailCard
      :art-image="art.properties.image"
      :tags="art.properties.taxonomies"
      :media="art.properties.medias[0]"
      :arttype="art.properties.kind"
      :name="art.properties.name"
      :server="isServer"
    ></ArtistDetailCard>
    <div class="artist-content-container">
      <section class="artist-content-field">
        <h5 class="field-title">
          Indigenous/First Nation Association(s)
        </h5>
        <span class="field-content">Nuxalk</span>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Artist Awards</span>
        <ul class="field-content-list">
          <li>
            <img src="@/assets/images/arts/award_icon.svg" /> YVR Art Foundation
            YouthScolarship 2015
          </li>
        </ul>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Artist Biography</span>
        <span class="field-content">
          <p v-html="stringSplit('Text goes here...')" />
        </span>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Link to my work</span>
        <span class="field-content">
          <a href="google.com"
            >http://facebook.com/VonXgola/Designs-by-Danika-0231402</a
          >
        </span>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Email</span>
        <span class="field-content">
          johndoe@hotmail.com
        </span>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Phone</span>
        <span class="field-content">
          (668) 332 8898
        </span>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Address</span>
        <span class="field-content">
          Bella Colla, British Columbia, Canada
        </span>
      </section>
      <section class="artist-content-field">
        <span class="field-title">Social Media</span>
        <span class="field-content">
          <ul class="artist-social-icons">
            <li>
              <a href="https://www.facebook.com">
                <img src="@/assets/images/arts/facebook.svg" />
              </a>
            </li>
            <li>
              <a href="https://www.twitter.com">
                <img src="@/assets/images/arts/twitter.svg" />
              </a>
            </li>
            <li>
              <a href="https://www.linkedin.com">
                <img src="@/assets/images/arts/linkedin.svg" />
              </a>
            </li>
          </ul>
        </span>
      </section>
    </div>
  </div>
</template>

<script>
export default {
  methods: {
    stringSplit(string) {
      return string.replace(
        /(.{50}[^\s]*)/g,
        '$1 ...<a href="#">keep reading</a>'
      )
    }
  }
}
</script>

<style></style>
