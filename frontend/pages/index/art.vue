<template>
  <div>
    <SideBar v-if="this.$route.name === 'index-art'" active="Arts">
      <template v-slot:content>
        <section class="pl-3 pr-3 pt-3">
          <Badge
            content="Public Arts"
            :number="publicArts.length"
            class="cursor-pointer mb-2"
            bgcolor="#848159"
            @click.native.prevent="
              $router.push({
                query: {
                  mode: 'parts'
                }
              })
            "
          ></Badge>
          <Badge
            content="Organization"
            :number="orgs.length"
            class="cursor-pointer mb-2"
            bgcolor="#a48116"
            @click.native.prevent="
              $router.push({
                query: {
                  mode: 'orgs'
                }
              })
            "
          ></Badge>
          <Badge
            content="Events"
            :number="events.length"
            class="cursor-pointer mb-1"
            bgcolor="#db531f"
            @click.native.prevent="
              $router.push({
                query: {
                  mode: 'events'
                }
              })
            "
          ></Badge>
        </section>
        <hr class="sidebar-divider" />
        <Filters class="mb-4"></Filters>
      </template>
      <template v-slot:cards>
        <section class="pl-3 pr-3">
          <ArtsCard
            v-for="(art, index) in artsFiltered"
            :key="index"
            :arttype="art.properties.type"
            :name="art.properties.title"
            class="mt-3 hover-left-move"
            @click.native="
              $router.push({
                path: `/art/${encodeURIComponent(art.properties.title)}`
              })
            "
          ></ArtsCard>
        </section>
      </template>
    </SideBar>
    <DetailSideBar
      v-else-if="this.$route.name === 'index-art-art'"
      :width="375"
    >
      <div>
        <nuxt-child />
      </div>
    </DetailSideBar>
  </div>
</template>

<script>
import SideBar from '@/components/SideBar.vue'
import ArtsCard from '@/components/arts/ArtsCard.vue'
import DetailSideBar from '@/components/DetailSideBar.vue'
import Badge from '@/components/Badge.vue'
import Filters from '@/components/Filters.vue'

export default {
  components: {
    SideBar,
    ArtsCard,
    DetailSideBar,
    Badge,
    Filters
  },
  data() {
    return {
      artsFiltered: this.arts
    }
  },
  computed: {
    arts() {
      return this.$store.state.arts.arts
    },
    publicArts() {
      return this.arts.filter(art => art.properties.type === 'art')
    },
    orgs() {
      return this.arts.filter(art => art.properties.type === 'org')
    },
    events() {
      return this.arts.filter(art => art.properties.type === 'event')
    }
  },
  watch: {
    $route(to, from) {
      const mode = to.query.mode
      switch (mode) {
        case 'parts':
          this.artsFiltered = this.publicArts
          break
        case 'orgs':
          this.artsFiltered = this.orgs
          break
        case 'events':
          this.artsFiltered = this.events
          break
      }
      console.log('Switch')
    }
  }
}
</script>
<style></style>
