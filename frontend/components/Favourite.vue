<template>
  <div
    class="cursor-pointer"
    :class="{ favourited: favourited }"
    @click="handleFavourite"
  >
    <MdHeartIcon
      w="30"
      h="30"
      class="heart-place-icon"
      :class="{ favourited: favourited }"
    ></MdHeartIcon>
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
</style>
