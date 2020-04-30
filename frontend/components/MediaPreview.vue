<template>
  <div class="media-add-btn">
    <img v-if="file.file_type.includes('image')" :src="fileSrc" />
    <img v-else-if="file.file_type === 'youtube'" :src="videoThumbnail()" />
    <img v-else class="media-other" src="@/assets/images/clip_icon.svg" />
    <div class="media-remove-btn" @click="removeMedia(file)" />
  </div>
</template>

<script>
const base64Encode = data =>
  new Promise((resolve, reject) => {
    const reader = new FileReader()
    reader.readAsDataURL(data)
    reader.onload = () => resolve(reader.result)
    reader.onerror = error => reject(error)
  })
export default {
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
    }
  },
  data() {
    return {
      fileSrc: null
    }
  },
  created() {
    base64Encode(this.file.media_file)
      .then(value => {
        this.fileSrc = value
      })

      .catch(() => {
        this.fileSrc = null
      })
  },
  methods: {
    removeMedia(file) {
      const filteredData = this.allMedia.filter(media => media !== file)
      this.$store.commit('file/setNewMediaFiles', filteredData)
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
    }
  }
}
</script>

<style></style>
