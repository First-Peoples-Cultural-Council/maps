<template>
  <div
    class="cursor-pointer"
    :class="{ favourited: favourited }"
    @click="handleFavourite"
  >
    <b-button block variant="warning" class="favourite-badge">
      <MdHeartIcon
        w="15"
        h="15"
        class="heart-place-icon d-inline-block"
        :class="{ favourited: favourited }"
      ></MdHeartIcon>
      <span v-if="favourited" class="d-inline-block">Liked</span>
      <span v-else class="d-inline-block">Like</span>
      <span v-if="numFavourites" class="ml-1 d-inline-block"
        >({{ numFavourites }})</span
      >
    </b-button>
  </div>
</template>
<script>
import MdHeartIcon from 'vue-ionicons/dist/md-heart.vue'
export default {
  components: {
    MdHeartIcon
  },
  props: {
    favourited: {
      default: null,
      type: Boolean
    },
    type: {
      default: 'placename',
      type: String
    },
    id: {
      default: null,
      type: Number
    },
    favourite: {
      default: null,
      type: Object
    },
    numFavourites: {
      default: null,
      type: Number
    }
  },
  methods: {
    async handleFavourite(e) {
      const data = {
        place: this.id,
        favourite_type: 'favourite',
        favourite: this.favourite
      }
      if (!this.favourited) {
        const result = await this.$store.dispatch('places/setFavourite', data)
        console.log('Result', result)
      } else {
        const result = await this.$store.dispatch(
          'places/removeFavourite',
          data
        )
        console.log('Result', result)
      }
      await this.$store.dispatch('places/getPlace', { id: this.id })
    }
  }
}
</script>
<style>
.heart-place-icon {
  vertical-align: sub;
}
.heart-place-icon:hover {
  transform: scale(1.2);
  fill: #dc3545;
}

.favourited:hover {
  fill: black;
  color: white;
}

.heart-place-icon svg {
  display: block;
  fill: white;
}

.favourited {
  fill: #dc3545;
}

.favourite-badge {
  font-size: 0.8em;
  padding: 0.2em 1em;
  background-color: #e6a000;
  color: white;
}
</style>
