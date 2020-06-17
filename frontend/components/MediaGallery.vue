<template>
  <div class="media-list-container">
    <MediaPreview
      v-for="media in mediaList"
      :key="media.name"
      :file="media"
      :type-media="media.placename ? 'existing' : 'new'"
      :all-media="mediaList"
      class="media-add-btn"
    />

    <div id="media-add-btn" class="media-add-btn " @click="openModal">
      <img class="add-btn" src="@/assets/images/plus_icon.svg" alt="Zoom In" />
      {{
        type === 'Artist' || type === 'Public Art'
          ? 'Upload an Artwork'
          : 'Upload a Media/File'
      }}
      <UploadModal
        v-if="showUploadModal"
        :id="1"
        :type="'placename'"
      ></UploadModal>
      <b-tooltip target="media-add-btn"
        >Add relevant audio, images, links to YouTube videos, and PDF files. You
        can add multiple files.</b-tooltip
      >
    </div>
  </div>
</template>

<script>
import MediaPreview from '@/components/MediaPreview.vue'
import UploadModal from '@/components/UploadModal.vue'
export default {
  components: {
    MediaPreview,
    UploadModal
  },
  props: {
    mediaList: {
      type: Array,
      default: () => {
        return []
      }
    },
    type: {
      type: String,
      default: ''
    }
  },
  data() {
    return {
      showUploadModal: false
    }
  },
  computed: {
    getMediaFiles() {
      return this.$store.state.file.fileList
    }
  },
  methods: {
    openModal(e) {
      this.showUploadModal = !this.showUploadModal
      this.$root.$emit('openUploadModal', { id: 1, type: 'placename' })
    }
  }
}
</script>

<style lang="scss">
.media-list-container {
  display: flex;
  flex-wrap: wrap;
}

.media-add-btn {
  position: relative;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  flex: 0 0 auto;
  width: 125px;
  height: 125px;
  background-clip: border-box;
  border: 1px solid rgba(0, 0, 0, 0.125);
  border-radius: 0.25rem;
  margin: 0.25em;
  text-align: center;

  &:hover {
    cursor: pointer;
    border: 1px solid #f2a798;
    background-color: #fcedea !important;
  }

  img {
    width: 120px;
    height: 120px;
    object-fit: cover;
  }

  .add-btn {
    width: 30px;
    height: 30px;
  }

  .media-action-btns {
    display: flex;
    position: absolute;
    bottom: 7.5px;
    right: 2.5px;
  }

  .media-remove-btn,
  .media-edit-btn {
    flex: 0 0 25px;
    background-image: url(data:image/svg+xml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PHN2ZyAgIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgICB4bWxuczpjYz0iaHR0cDovL2NyZWF0aXZlY29tbW9ucy5vcmcvbnMjIiAgIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyIgICB4bWxuczpzdmc9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiAgIHhtbG5zPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2ZyIgICB4bWxuczpzb2RpcG9kaT0iaHR0cDovL3NvZGlwb2RpLnNvdXJjZWZvcmdlLm5ldC9EVEQvc29kaXBvZGktMC5kdGQiICAgeG1sbnM6aW5rc2NhcGU9Imh0dHA6Ly93d3cuaW5rc2NhcGUub3JnL25hbWVzcGFjZXMvaW5rc2NhcGUiICAgd2lkdGg9IjIwIiAgIGhlaWdodD0iMjAiICAgaWQ9InN2ZzU3MzgiICAgdmVyc2lvbj0iMS4xIiAgIGlua3NjYXBlOnZlcnNpb249IjAuOTErZGV2ZWwrb3N4bWVudSByMTI5MTEiICAgc29kaXBvZGk6ZG9jbmFtZT0idHJhc2guc3ZnIiAgIHZpZXdCb3g9IjAgMCAyMCAyMCI+ICA8ZGVmcyAgICAgaWQ9ImRlZnM1NzQwIiAvPiAgPHNvZGlwb2RpOm5hbWVkdmlldyAgICAgaWQ9ImJhc2UiICAgICBwYWdlY29sb3I9IiNmZmZmZmYiICAgICBib3JkZXJjb2xvcj0iIzY2NjY2NiIgICAgIGJvcmRlcm9wYWNpdHk9IjEuMCIgICAgIGlua3NjYXBlOnBhZ2VvcGFjaXR5PSIwLjAiICAgICBpbmtzY2FwZTpwYWdlc2hhZG93PSIyIiAgICAgaW5rc2NhcGU6em9vbT0iMjIuNjI3NDE3IiAgICAgaW5rc2NhcGU6Y3g9IjEyLjEyODE4NCIgICAgIGlua3NjYXBlOmN5PSI4Ljg0NjEzMDciICAgICBpbmtzY2FwZTpkb2N1bWVudC11bml0cz0icHgiICAgICBpbmtzY2FwZTpjdXJyZW50LWxheWVyPSJsYXllcjEiICAgICBzaG93Z3JpZD0idHJ1ZSIgICAgIGlua3NjYXBlOndpbmRvdy13aWR0aD0iMTAzMyIgICAgIGlua3NjYXBlOndpbmRvdy1oZWlnaHQ9Ijc1MSIgICAgIGlua3NjYXBlOndpbmRvdy14PSIyMCIgICAgIGlua3NjYXBlOndpbmRvdy15PSIyMyIgICAgIGlua3NjYXBlOndpbmRvdy1tYXhpbWl6ZWQ9IjAiICAgICBpbmtzY2FwZTpzbmFwLXNtb290aC1ub2Rlcz0idHJ1ZSIgICAgIGlua3NjYXBlOm9iamVjdC1ub2Rlcz0idHJ1ZSI+ICAgIDxpbmtzY2FwZTpncmlkICAgICAgIHR5cGU9Inh5Z3JpZCIgICAgICAgaWQ9ImdyaWQ1NzQ2IiAgICAgICBlbXBzcGFjaW5nPSI1IiAgICAgICB2aXNpYmxlPSJ0cnVlIiAgICAgICBlbmFibGVkPSJ0cnVlIiAgICAgICBzbmFwdmlzaWJsZWdyaWRsaW5lc29ubHk9InRydWUiIC8+ICA8L3NvZGlwb2RpOm5hbWVkdmlldz4gIDxtZXRhZGF0YSAgICAgaWQ9Im1ldGFkYXRhNTc0MyI+ICAgIDxyZGY6UkRGPiAgICAgIDxjYzpXb3JrICAgICAgICAgcmRmOmFib3V0PSIiPiAgICAgICAgPGRjOmZvcm1hdD5pbWFnZS9zdmcreG1sPC9kYzpmb3JtYXQ+ICAgICAgICA8ZGM6dHlwZSAgICAgICAgICAgcmRmOnJlc291cmNlPSJodHRwOi8vcHVybC5vcmcvZGMvZGNtaXR5cGUvU3RpbGxJbWFnZSIgLz4gICAgICAgIDxkYzp0aXRsZSAvPiAgICAgIDwvY2M6V29yaz4gICAgPC9yZGY6UkRGPiAgPC9tZXRhZGF0YT4gIDxnICAgICBpbmtzY2FwZTpsYWJlbD0iTGF5ZXIgMSIgICAgIGlua3NjYXBlOmdyb3VwbW9kZT0ibGF5ZXIiICAgICBpZD0ibGF5ZXIxIiAgICAgdHJhbnNmb3JtPSJ0cmFuc2xhdGUoMCwtMTAzMi4zNjIyKSI+ICAgIDxwYXRoICAgICAgIHN0eWxlPSJjb2xvcjojMDAwMDAwO2Rpc3BsYXk6aW5saW5lO292ZXJmbG93OnZpc2libGU7dmlzaWJpbGl0eTp2aXNpYmxlO2ZpbGw6IzAwMDAwMDtmaWxsLW9wYWNpdHk6MTtmaWxsLXJ1bGU6bm9uemVybztzdHJva2U6bm9uZTtzdHJva2Utd2lkdGg6MC45OTk5OTk4MjttYXJrZXI6bm9uZTtlbmFibGUtYmFja2dyb3VuZDphY2N1bXVsYXRlIiAgICAgICBkPSJtIDEwLDEwMzUuNzc0MyBjIC0wLjc4NDkyNTMsOGUtNCAtMS40OTY4Mzc2LDAuNDYwNiAtMS44MjAzMTI1LDEuMTc1OCBsIC0zLjE3OTY4NzUsMCAtMSwxIDAsMSAxMiwwIDAsLTEgLTEsLTEgLTMuMTc5Njg4LDAgYyAtMC4zMjM0NzUsLTAuNzE1MiAtMS4wMzUzODcsLTEuMTc1IC0xLjgyMDMxMiwtMS4xNzU4IHogbSAtNSw0LjU4NzkgMCw3IGMgMCwxIDEsMiAyLDIgbCA2LDAgYyAxLDAgMiwtMSAyLC0yIGwgMCwtNyAtMiwwIDAsNS41IC0xLjUsMCAwLC01LjUgLTMsMCAwLDUuNSAtMS41LDAgMCwtNS41IHoiICAgICAgIGlkPSJyZWN0MjQzOS03IiAgICAgICBpbmtzY2FwZTpjb25uZWN0b3ItY3VydmF0dXJlPSIwIiAgICAgICBzb2RpcG9kaTpub2RldHlwZXM9ImNjY2NjY2NjY2NjY2NjY2NjY2NjY2NjY2MiIC8+ICA8L2c+PC9zdmc+);
    background-color: #fff;
    width: 25px;
    height: 25px;
    border: 1px solid rgba(0, 0, 0, 0.125);
    border-radius: 0.25rem;
    padding: 0.25em;
    margin-right: 5px;

    &:hover {
      border: 1px solid #f2a798;
      background-color: #fcedea !important;
    }
  }

  .media-edit-btn {
    background-size: 15px 15px;
    background-repeat: no-repeat;
    background-position: center;
    background-image: url("data:image/svg+xml,%3C%3Fxml version='1.0' encoding='iso-8859-1'%3F%3E%3C!-- Generator: Adobe Illustrator 19.0.0, SVG Export Plug-In . SVG Version: 6.00 Build 0) --%3E%3Csvg version='1.1' id='Capa_1' xmlns='http://www.w3.org/2000/svg' xmlns:xlink='http://www.w3.org/1999/xlink' x='0px' y='0px' viewBox='0 0 383.947 383.947' style='enable-background:new 0 0 383.947 383.947;' xml:space='preserve'%3E%3Cg%3E%3Cg%3E%3Cg%3E%3Cpolygon points='0,303.947 0,383.947 80,383.947 316.053,147.893 236.053,67.893 '/%3E%3Cpath d='M377.707,56.053L327.893,6.24c-8.32-8.32-21.867-8.32-30.187,0l-39.04,39.04l80,80l39.04-39.04 C386.027,77.92,386.027,64.373,377.707,56.053z'/%3E%3C/g%3E%3C/g%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3Cg%3E%3C/g%3E%3C/svg%3E%0A");
  }

  .media-status {
    position: absolute;
    top: 0;
    left: 0;
    width: 50px;
    background: #d4edda;
    padding: 0.25em;
  }

  .media-other {
    width: 50px;
    height: 50px;
    object-fit: contain;
  }
}
</style>
