<template>
  <div
    class="cursor-pointer"
    :class="{ favourited: favourited }"
    @click="handleFavourite"
  >
    <b-badge
      variant="warning"
      class="d-flex align-items-center favourite-badge mt-1"
      ><MdHeartIcon
        w="15"
        h="15"
        class="heart-place-icon mr-1"
        :class="{ favourited: favourited }"
      ></MdHeartIcon>
      <span v-if="favourited">Favourited</span>
      <span v-else>Favourite</span>
      <span v-if="numFavourites" class="ml-1">({{ numFavourites }})</span>
    </b-badge>
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
.heart-place-icon:hover {
  transform: scale(1.2);
  fill: #dc3545;
}

.favourited:hover {
  fill: black;
}

.heart-place-icon svg {
  display: block;
}

.favourited {
  fill: #dc3545;
}

.favourite-badge {
}
</style>
