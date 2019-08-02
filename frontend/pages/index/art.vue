<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-art'" active="Arts">
      <template v-slot:content>
        <Filters class="mb-2"></Filters>
      </template>
      <template v-slot:badges>
        <section class="pl-3 pr-3 pt-3">
          <Badge
            content="Public Arts"
            :number="publicArts.length"
            class="cursor-pointer mb-2"
            bgcolor="#848159"
            type="part"
            :mode="getBadgeStatus(mode, 'public_art')"
            @click.native.prevent="handleBadge($event, 'public_art')"
          ></Badge>
          <Badge
            content="Organization"
            :number="orgs.length"
            class="cursor-pointer mb-2"
            bgcolor="#a48116"
            type="org"
            :mode="getBadgeStatus(mode, 'organization')"
            @click.native.prevent="handleBadge($event, 'organization')"
          ></Badge>
          <Badge
            content="Artists"
            :number="artists.length"
            class="cursor-pointer mb-1"
            bgcolor="#db531f"
            type="event"
            :mode="getBadgeStatus(mode, 'artist')"
            @click.native.prevent="handleBadge($event, 'artist')"
          ></Badge>
        </section>
      </template>
      <template v-slot:cards>
        <section class="pl-3 pr-3">
          <div v-for="(art, index) in arts" :key="index">
            <div v-if="mode !== 'All'">
              <ArtsCard
                v-if="mode === art.properties.art_type"
                :arttype="art.properties.art_type"
                :name="art.properties.name"
                class="mt-3 hover-left-move"
                @click.native="
                  $router.push({
                    path: `/art/${encodeURIComponent(art.properties.name)}`
                  })
                "
              ></ArtsCard>
            </div>
            <div v-else>
              <ArtsCard
                :arttype="art.properties.art_type"
                :name="art.properties.name"
                class="mt-3 hover-left-move"
                @click.native="
                  $router.push({
                    path: `/art/${encodeURIComponent(art.properties.name)}`
                  })
                "
              ></ArtsCard>
            </div>
          </div>
        </section>
      </template>
    </SideBar>
    <div v-else-if="this.$route.name === 'index-art-art'">
      <div>
        <nuxt-child />
      </div>
    </div>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    SideBar,
    ArtsCard,
    Badge,
    Filters
  },
  data() {
    return {
      mode: 'All'
    }
  },
  computed: {
    arts() {
      return this.$store.state.arts.arts
    },
    publicArts() {
      return this.arts.filter(art => art.properties.art_type === 'public_art')
    },
    orgs() {
      return this.arts.filter(art => art.properties.art_type === 'organization')
    },
    artists() {
      return this.arts.filter(art => art.properties.art_type === 'artist')
    }
  }
}
</script>
<style></style>
