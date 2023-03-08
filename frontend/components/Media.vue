<template>
  <div class="media-main-container">
    <div
      v-if="getGenericFileType(media.file_type) === 'image'"
      class="w-100 d-flex justify-content-center"
    >
      <img
        class="media-image media-file-container cursor-pointer"
        :src="getMediaUrl(media.media_file, server)"
        :alt="media.name"
        @click="handleImageClick($event, media)"
      />
    </div>

    <div v-if="getGenericFileType(media.file_type) === 'audio'" class="w-100 ">
      <!-- <audio controls class="uploaded-audio">
        <source
          :src="getMediaUrl(media.media_file, server)"
          :type="media.file_type"
        />
        <p>
          Your browser doesn't support HTML5 audio. Here is a
          <a :href="getMediaUrl(media.media_file, server)">link to the audio</a>
          instead.
        </p>
      </audio> -->
      <div
        class="media-file-container"
        @click="handleAudioClick($event, media)"
      >
        <img class="media-placeholder" src="@/assets/images/volume.svg" />
      </div>
    </div>

    <div
      v-if="getGenericFileType(media.file_type) === 'youtube'"
      class="w-100 word-break-all d-flex justify-content-center"
      @click="handleYoutube($event, media)"
    >
      <iframe
        width="100%"
        :src="`https://www.youtube.com/embed/${getYoutubeId(media.url)[2]}`"
        frameborder="0"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
        class="media-file-container frame-thumbnail-video"
      ></iframe>
    </div>

    <div
      v-if="getGenericFileType(media.file_type) === 'vimeo'"
      class="w-100 word-break-all d-flex justify-content-center"
      @click="handleVimeo($event, media)"
    >
      <iframe
        v-if="vimeo.id"
        class="media-file-container frame-thumbnail-video"
        :src="`https://player.vimeo.com/video/${vimeo.id}`"
        width="100%"
        frameborder="0"
        allow="autoplay; fullscreen"
        allowfullscreen
      ></iframe>
    </div>

    <div
      v-if="getGenericFileType(media.file_type) === 'other'"
      class="w-100 word-break-all d-flex justify-content-center"
    >
      <div class="media-file-container">
        <img class="media-placeholder" src="@/assets/images/attach.svg" />
        <b-button
          variant="dark"
          size="sm"
          class="mt-3"
          @click="downloadFile(media)"
          >Click here to Download</b-button
        >
      </div>
    </div>

    <div
      v-if="getGenericFileType(media.file_type) === 'note'"
      class="w-100 word-break-all d-flex justify-content-center"
    >
      <div class="media-file-container">
        <img class="media-placeholder" src="@/assets/images/attach.svg" />
      </div>
    </div>

    <div class="media-content-container">
      <div v-if="media.name">
        <span class="word-break-all">{{ media.name }}</span>
      </div>
      <div v-if="media.created" class="font-07 mb-1">
        <span class="word-break-all">
          {{
            new Date(media.created).toLocaleDateString('en-US', {
              year: 'numeric',
              month: 'long',
              day: 'numeric'
            })
          }}
        </span>
      </div>
      <div
        v-if="media.description && media.description !== 'null'"
        class="font-08 color-gray mb-1"
      >
        <span class="word-break-all">{{ media.description }}</span>
      </div>

      <b-alert
        v-if="isOwner"
        variant="primary"
        show
        class="d-inline-block p-1 font-08"
      >
        Media Owner</b-alert
      >
      <b-alert
        v-if="media.status === 'UN'"
        variant="warning"
        show
        class="d-inline-block p-1 font-08"
        >Unverified Media</b-alert
      >
      <b-alert
        v-else-if="media.status === 'VE'"
        variant="primary"
        show
        class="d-inline-block p-1 font-08"
      >
        Verified Media</b-alert
      >
      <b-alert
        v-else-if="media.status === 'FL'"
        variant="danger"
        show
        class="d-inline-block p-1 font-08"
        >Flagged Media</b-alert
      >
      <b-alert
        v-else-if="media.status === 'RE'"
        variant="danger"
        show
        class="d-inline-block p-1 font-08"
        >Rejected Media</b-alert
      >
      <b-alert
        v-if="communityOnly"
        variant="success"
        show
        class="d-inline-block p-1 font-08"
        >Community Only</b-alert
      >

      <div class="media-action-container">
        <slot name="verify"></slot>
        <slot name="reject"></slot>
        <b-button
          v-if="isOwner"
          variant="dark"
          size="sm"
          @click="showEditModal"
        >
          Edit
        </b-button>
        <DeleteMedia v-if="isOwner" :id="media.id" :media="media"></DeleteMedia>

        <FlagModal
          v-if="media.status !== 'FL' && media.status !== 'VE'"
          :id="media.id"
          title="Report"
          :media="media"
        ></FlagModal>
      </div>
    </div>

    <MediaEdit
      v-if="showModal"
      :id="media.id"
      :show-state="showModal"
      :media="media"
      :toggle-modal="showEditModal"
    ></MediaEdit>
  </div>
</template>
<script>
import FlagModal from '@/components/Flag/FlagModal.vue'
import DeleteMedia from '@/components/DeleteMedia.vue'
import MediaEdit from '@/components/MediaEdit.vue'
import {
  getGenericFileType,
  getMediaUrl,
  getYoutubeId
} from '@/plugins/utils.js'
require('basiclightbox/dist/basicLightbox.min.css')

export default {
  components: {
    FlagModal,
    DeleteMedia,
    MediaEdit
  },
  props: {
    media: {
      default: null,
      type: Object
    },
    flag: {
      default: true,
      type: Boolean
    },
    server: {
      default: false,
      type: Boolean
    },
    isOwner: {
      default: false,
      type: Boolean
    },
    type: {
      default: null,
      type: String
    },
    communityOnly: {
      default: false,
      type: Boolean
    }
  },
  data() {
    return {
      vimeo: {
        id: null
      },
      showModal: false
    }
  },
  async created() {
    if (this.media.file_type === 'vimeo') {
      await this.getVimeoEmbed(this.media.url)
    }
  },

  methods: {
    getYoutubeId,
    getGenericFileType,
    getMediaUrl,
    handleImageClick(e, media) {
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(`<img src="${getMediaUrl(media.media_file, this.isServer)}">`, {
          closable: true
        })
        .show()
    },
    handleYoutube(e, media) {
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(
          `<iframe
        width="100%"
        src="https://www.youtube.com/embed/${this.getYoutubeId(media.url)[2]}"
        frameborder="0"
        allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture"
        allowfullscreen
        class="frame-video"
      ></iframe>`,
          {
            closable: true
          }
        )
        .show()
    },
    handleVimeo(e, media) {
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(
          ` <iframe
        v-if="vimeo.id"
        class="frame-video"
        src="https://player.vimeo.com/video/${this.vimeo.id}"
        width="100%"
        frameborder="0"
        allow="autoplay; fullscreen"
        allowfullscreen
      ></iframe>`,
          {
            closable: true
          }
        )
        .show()
    },
    handleAudioClick(e, media) {
      const basicLightbox = require('basiclightbox')
      basicLightbox
        .create(
          ` <audio controls controlsList="nodownload" class="frame-audio">
        <source
          src="${getMediaUrl(media.media_file)}"
          type="${media.file_type}"
        />
        <p>
          Your browser doesn't support HTML5 audio. Here is a
          <a href="${getMediaUrl(media.media_file)}">link to the audio</a>
          instead.
        </p>
      </audio> `,
          {
            closable: true
          }
        )
        .show()
    },
    downloadFile(media) {
      window.open(getMediaUrl(media.media_file))
    },
    async getVimeoEmbed(link) {
      const result = await this.$axios.$get(
        `https://vimeo.com/api/oembed.json?url=${link}`
      )
      this.vimeo.id = result.video_id
      return result.video_id
    },
    showEditModal() {
      this.showModal = !this.showModal
    }
  }
}
</script>
<style lang="scss">
.media-image {
  display: block;
  max-width: 100%;
  width: auto;
  height: auto;
}

.media-main-container {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  justify-content: flex-start;
  width: 100%;
  border: 1px solid #ebe6dc;
  border-radius: 0.25em;
  box-shadow: 0px 2px 4px 1px rgba(0, 0, 0, 0.1);

  .media-content-container {
    width: 100%;
    padding: 0.5em 0.5em;

    .media-action-container {
      display: flex;
      flex-wrap: wrap;
      margin: 0.5em 0;

      & > * {
        flex: 0 0 25%;
        margin-right: 0.25em;
        font-size: 0.8em;
      }
    }
  }

  .alert {
    margin-bottom: 0.5em !important;
  }

  &:hover {
    border: 1px solid #b57936;
  }
}

.media-file-container {
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  width: 100%;
  height: 250px;
  object-fit: cover;
  background: rgba(0, 0, 0, 0.2);
}

.media-placeholder {
  width: 75px;
  height: 75px;
  object-fit: contain;
}

.frame-thumbnail-video {
  pointer-events: none;
}

.frame-video {
  width: 60%;
  height: 60%;
}

.frame-audio {
  width: 1000px;
  position: relative;
}
</style>
