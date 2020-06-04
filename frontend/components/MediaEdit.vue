<template>
  <div>
    <b-modal
      id="uploadModal"
      ref="multiUploadModal"
      v-model="showModal"
      title="Edit Media"
      hide-footer
      @hide="toggleModal"
    >
      <b-row class="edit-modal-container" no-gutters>
        <div v-if="hasImgThumbnail" class="upload-img-container mt-1">
          <div class="upload-img">
            <img v-if="fileSrc === null" :src="getMediaThumbnail()" />
            <img v-else :src="fileSrc" />
          </div>

          <b-form-file
            v-if="getGenericType === 'image'"
            ref="fileUpload"
            v-model="file"
            class="file-upload-input mt-2"
            :placeholder="getMediaUrl(media.media_file)"
            drop-placeholder="Drop file here..."
            accept="image/*"
          ></b-form-file>
        </div>

        <b-row>
          <b-col xl="12">
            <label class="font-08" for="file-name">Title</label>

            <b-form-input
              id="file-name"
              v-model="title"
              class="font-08"
              placeholder="Enter Title (required)"
              required
            ></b-form-input>
          </b-col>
        </b-row>
        <label class="mt-3 font-08" for="textarea">Description</label>

        <b-form-textarea
          id="textarea"
          v-model="description"
          placeholder="Enter description"
          aria-describedby="title-help title-feedback"
          rows="3"
          max-rows="6"
          class="mt-2 mb-2 font-08"
        ></b-form-textarea>

        <div v-if="getGenericType === 'youtube'">
          <label
            for="youtube-link"
            class="font-08 color-dark-gray font-weight-bold mt-2"
            >Youtube Link</label
          >

          <b-form-input
            id="youtube-link"
            v-model="url"
            placeholder="Enter the link"
            aria-describedby="youtube-feedback"
            size="sm"
            class=""
            :state="youtubestate"
            @input="checkValidYtLink"
          ></b-form-input>

          <b-form-invalid-feedback id="youtube-feedback">
            Youtube link is required
          </b-form-invalid-feedback>
        </div>

        <div>
          <label
            class="font-08 d-inline-block contribute-title-one"
            for="community-only"
            >Community Only?</label
          >
          <b-form-checkbox
            id="community-only"
            v-model="commonly"
            class="d-inline-block ml-2"
            name="community-only"
            value="accepted"
            unchecked-value="not_accepted"
          >
          </b-form-checkbox>
        </div>

        <div class="mt-2">
          <b-button variant="dark" size="sm" @click="patchMedia"
            >Update</b-button
          >
          <b-button size="sm" variant="dark" class="" @click="toggleModal"
            >Cancel</b-button
          >
        </div>
      </b-row>
    </b-modal>
  </div>
</template>

<script>
import {
  getGenericFileType,
  getYoutubeThumbnail,
  isValidYoutubeLink,
  getMediaUrl,
  getCookie
} from '@/plugins/utils.js'

const base64Encode = data =>
  new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(data)
    reader.onload = () => resolve(reader.result)
    reader.onerror = error => reject(error)
  })

export default {
  components: {},
  props: {
    id: {
      type: Number,
      default: 0
    },
    media: {
      type: Object,
      default: () => {
        return {}
      }
    },
    toggleModal: {
      type: Function,
      default: () => {
        return {}
      }
    },
    showState: {
      type: Boolean,
      default: false
    }
  },
  data() {
    return {
      showModal: false,
      title: '',
      description: '',
      url: null,
      media_file: null,
      fileSrc: null,
      file: null,
      commonly: 'not_accepted',
      youtubestate: null
    }
  },
  computed: {
    hasImgThumbnail() {
      const type = this.getGenericType
      return type === 'image' || type === 'youtube'
    },
    getGenericType() {
      return this.getGenericFileType(this.media.file_type)
    },
    isPlacename() {
      return this.$route.query.type || this.$route.query.upload_artwork
    },
    isArtwork() {
      return (
        this.$route.query.type &&
        (this.$route.query.type === 'Artist' ||
          this.$route.query.type === 'Public Art')
      )
    },
    getCookies() {
      return {
        headers: {
          'X-CSRFToken': getCookie('csrftoken')
        }
      }
    }
  },
  watch: {
    file(newValue, oldValue) {
      if (newValue !== oldValue) {
        if (newValue) {
          base64Encode(newValue)
            .then(value => {
              this.fileSrc = value
            })
            .catch(() => {
              this.fileSrc = null
            })
        } else {
          this.fileSrc = null
        }
      }
    }
  },
  mounted() {
    const { name, description, community_only, url, media_file } = this.media

    this.title = name
    this.description = description
    this.commonly = community_only ? 'accepted' : 'not_accepted'
    this.showModal = this.showState

    if (url) {
      this.url = url
    } else if (media_file) {
      this.media_file = media_file
    }
  },
  methods: {
    getGenericFileType,
    getYoutubeThumbnail,
    getMediaUrl,
    isValidYoutubeLink,
    checkValidYtLink() {
      this.youtubestate = !!this.isValidYoutubeLink(this.url)
    },
    getMediaThumbnail() {
      const type = this.getGenericFileType(this.media.file_type)
      if (type === 'image') {
        return this.getMediaUrl(this.media.media_file)
      } else if (type === 'youtube') {
        const ytLink = this.url ? this.url : this.media.url
        return this.getYoutubeThumbnail(ytLink)
      }
    },
    async patchMedia() {
      const getData = this.getFormData()

      try {
        const result = await this.$axios.$patch(
          `/api/media/${this.media.id}/`,
          getData,
          this.getCookies
        )
        if (result) {
          this.$root.$emit('fileUploaded', result)
          this.toggleModal()
        }
      } catch (e) {
        this.toggleModal()
        console.error(e)
      }
    },
    getFormData() {
      const getFile = this.file ? this.file : this.media_file
      const getType = this.file ? this.file.type : this.media.file_type

      const formData = new FormData()
      formData.append('name', this.title)
      formData.append('file_type', getType)
      formData.append('description', this.description)
      formData.append('community_only', this.commonly === 'accepted')

      if (this.url) {
        formData.append('url', this.url)
      } else if (this.file) {
        formData.append('media_file', getFile)
      }
      // formData.append('is_artwork', this.isArtwork)

      return formData
    }
  }
}
</script>

<style lang="scss">
.edit-modal-container {
  display: flex;
  flex-direction: column;
}

.upload-img-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  width: 70%;
  margin: 0 auto;

  .upload-img {
    position: relative;
    display: flex;
    align-items: center;
    justify-content: center;
    width: 175px;
    height: 175px;
    border: 2px solid rgba(0, 0, 0, 0.125);

    &:hover {
      img {
        opacity: 0.5;
      }
      .upload-remove {
        display: block;
        opacity: 1;
      }
    }
  }
  img {
    width: 175px;
    height: 175px;
    object-fit: cover;
  }

  .upload-placeholder {
    width: 90px;
    height: 90px;
    object-fit: contain;
    border-radius: 0;
  }

  .upload-remove {
    display: none;
    position: absolute;
    margin: auto auto;
    font-size: 0.75em;
    display: none;
  }
}
</style>
