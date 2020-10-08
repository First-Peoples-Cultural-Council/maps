<template>
  <div>
    <div class="w-100">
      <div
        v-if="!mobileContent"
        class="content-collapse d-none content-mobile-title"
      >
        <div>
          GRANTS:
          <span class="font-weight-bold">{{ grant.name }}</span>
        </div>
        <div
          class="content-collapse-btn"
          @click="$store.commit('sidebar/setMobileContent', true)"
        >
          <img src="@/assets/images/arrow_up_icon.svg" />
        </div>
      </div>
      <div class="hide-mobile" :class="{ 'content-mobile': mobileContent }">
        <Logo :logo-alt="1" class="cursor-pointer hide-mobile"></Logo>
        <div>
          <div
            class="text-center d-none mobile-close"
            :class="{ 'content-mobile': mobileContent }"
            @click="$store.commit('sidebar/setMobileContent', false)"
          >
            <img
              class="d-inline-block"
              src="@/assets/images/arrow_down_icon.svg"
            />
          </div>
          <div>
            <GrantsDetailCard
              :name="grant.name"
              :arttype="'Grants'"
              :tags="grant.grantTags"
            ></GrantsDetailCard>
          </div>

          <hr class="sidebar-divider" />
          <div class="grants-detail-container">
            <section v-if="grant.description" class="artist-content-field">
              <h5 class="field-title">
                Grants Description:
              </h5>
              <span class="field-content">
                <span v-html="stringSplit(grant.description)"></span>
                <a v-if="showExpandBtn()" href="#" @click="toggleDescription">{{
                  collapseDescription ? 'read less' : 'read more'
                }}</a>
              </span>
            </section>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import GrantsDetailCard from '@/components/grants/GrantsDetailCard.vue'
import Logo from '@/components/Logo.vue'

export default {
  components: {
    GrantsDetailCard,
    Logo
  },
  data() {
    return {
      collapseDescription: false,
      grant: {
        name: 'Sample Grants Data',
        type: 'Grants Type',
        description:
          'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Beatae, laudantium debitis cumque saepe quae unde consectetur in, pariatur quidem quibusdam vel, quos molestiae ipsam iste iusto perferendis. Beatae, necessitatibus dolorum.',
        grantTags: ['Grants#1', 'Grants#2', 'Grants#3'],
        other_fields: [
          {
            field_name: 'Grants Description',
            field_content:
              'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Ut, ipsa. Inventore vel soluta corrupti aliquid autem nostrum recusandae, officiis sint labore nobis quis rerum quod quae atque laboriosam maiores odio.'
          },
          {
            field_name: 'Grants Value',
            field_content: '1,000,000.00 Dollars'
          }
        ]
      }
    }
  },
  watchQuery: true,
  computed: {
    mobileContent() {
      return this.$store.state.sidebar.mobileContent
    },

    mapinstance() {
      return this.$store.state.mapinstance.mapInstance
    },
    isLoggedIn() {
      return this.$store.state.user.isLoggedIn
    }
  },

  async asyncData({ params, $axios, store }) {},
  mounted() {},
  created() {},
  methods: {
    showExpandBtn() {
      return this.grant.description.length >= 50
    },
    toggleDescription() {
      this.collapseDescription = !this.collapseDescription
    },
    stringSplit(string) {
      const stringValue = this.collapseDescription
        ? `${string} `
        : string.replace(/(.{200})..+/, '$1 ...')
      return stringValue
    }
  },
  head() {
    return {
      title: 'Grants Title goes here',
      meta: [
        {
          hid: `description`,
          name: 'description',
          content: 'Sample Grants Description'
        }
      ]
    }
  }
}
</script>
<style></style>
