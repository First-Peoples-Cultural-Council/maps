<template>
  <div class="media-add-btn" @click.prevent="handleImageClick($event, file)">
    <img v-if="file.file_type.includes('image')" :src="fileSrc" />
    <img v-else-if="file.file_type === 'youtube'" :src="videoThumbnail()" />
    <img v-else class="media-other" src="@/assets/images/clip_icon.svg" />
    <!-- <span v-if="typeMedia === 'existing'" class="media-status"> Old </span> -->
    <div class="media-action-btns">
      <div class="media-edit-btn" @click.stop.prevent="toggleEditModal" />
      <div class="media-remove-btn" @click.stop.prevent="toggleDeleteModal" />
    </div>
    <MediaEdit
      v-if="showEditModal"
      :id="file.id"
      :show-state="showEditModal"
      :media="file"
      :toggle-modal="toggleEditModal"
    ></MediaEdit>

    <b-modal v-model="modalShow" hide-header @ok="removeMedia(file)">{{
      `Are you sure you want to remove media named "${file.name}"?`
    }}</b-modal>
  </div>
</template>

<script>
import { getMediaUrl, getCookie, getApiUrl } from '@/plugins/utils.js'
import MediaEdit from '@/components/MediaEdit.vue'

const base64Encode = data =>
  new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(data)
    reader.onload = () => resolve(reader.result)
    reader.onerror = error => reject(error)
  })
export default {
  components: {
    MediaEdit
  },
  props: {
    file: {
      type: Object,
      default: () => {
        return {}
      }
    },
    allMedia: {
      type: Array,
      default: () => {
        return []
      }
    },
    typeMedia: {
      type: String,
      default: 'new'
    }
  },
  data() {
    return {
      fileSrc: null,
      modalShow: false,
      showEditModal: false
    }
  },
  created() {
    if (this.typeMedia === 'new') {
      base64Encode(this.file.media_file)
        .then(value => {
          this.fileSrc = value
        })

        .catch(() => {
          this.fileSrc = null
        })
    } else {
      this.fileSrc = getMediaUrl(this.file.media_file)
    }
  },
  methods: {
    toggleDeleteModal() {
      this.modalShow = !this.modalShow
    },
    toggleEditModal() {
      this.showEditModal = !this.showEditModal
    },
    removeMedia(file) {
      const filteredData = this.allMedia.filter(media => media !== file)
      this.$store.commit('file/setNewMediaFiles', filteredData)

      if (this.typeMedia === 'existing') {
        this.$axios.$delete(`${getApiUrl(`media/${file.id}`)}`, {
          headers: {
            'X-CSRFToken': getCookie('csrftoken')
          }
        })
      }

      this.toggleDeleteModal()
    },
    videoThumbnail() {
      return `https://img.youtube.com/vi/${this.getYoutubeVideoID(
        this.file.url
      )}/hqdefault.jpg`
    },
    getYoutubeVideoID(url) {
      const regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#&?]*).*/
      const match = url.match(regExp)
      return match && match[7].length === 11 ? match[7] : false
    },
    handleImageClick(e, media) {
      require('basiclightbox/dist/basicLightbox.min.css')
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(`<img src="${getMediaUrl(this.fileSrc, this.isServer)}">`, {
          closable: true
        })
        .show()
    }
  }
}
</script>

<style></style>
