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
            type="part"
            @click.native.prevent="mode = 'art'"
          ></Badge>
          <Badge
            content="Organization"
            :number="orgs.length"
            class="cursor-pointer mb-2"
            bgcolor="#a48116"
            type="org"
            @click.native.prevent="mode = 'org'"
          ></Badge>
          <Badge
            content="Events"
            :number="events.length"
            class="cursor-pointer mb-1"
            bgcolor="#db531f"
            type="event"
            @click.native.prevent="mode = 'event'"
          ></Badge>
        </section>
        <hr class="sidebar-divider" />
        <Filters class="mb-4"></Filters>
      </template>
      <template v-slot:cards>
        <section class="pl-3 pr-3">
          <div v-for="(art, index) in arts" :key="index">
            <div v-if="mode !== 'All'">
              <ArtsCard
                v-if="mode === art.properties.type"
                :arttype="art.properties.type"
                :name="art.properties.title"
                class="mt-3 hover-left-move"
                @click.native="
                  $router.push({
                    path: `/art/${encodeURIComponent(art.properties.title)}`
                  })
                "
              ></ArtsCard>
            </div>
            <div v-else>
              <ArtsCard
                :arttype="art.properties.type"
                :name="art.properties.title"
                class="mt-3 hover-left-move"
                @click.native="
                  $router.push({
                    path: `/art/${encodeURIComponent(art.properties.title)}`
                  })
                "
              ></ArtsCard>
            </div>
          </div>
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
      mode: 'All'
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
  }
}
</script>
<style></style>
