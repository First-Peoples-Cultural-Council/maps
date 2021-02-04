<template>
  <div class="grant-cluster-container">
    <div class="grant-header"></div>
    <div class="grant-title">Showing {{ grants.length }} Grants</div>
    <div class="grant-content">
      <a
        v-for="grant in grants"
        :key="grant.properties.id"
        href="#"
        @click="showGrantModal(grant)"
      >
        {{ grant.properties.recipient }} - {{ grant.properties.grant }}
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    grants: {
      type: Array,
      default: () => {
        return []
      }
    }
  }
}
</script>

<style lang="scss">
.grant-cluster-container {
  width: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  border: 0.8px solid #9f9f9f;
  border-radius: 0.5em;

  .grant-header {
    background-color: #7d6799;
    padding: 0.25em;
    height: 25px;
    color: white;
  }

  .grant-title {
    border-bottom: 0.8px solid #9f9f9f;
    padding: 0.75em;
    text-align: center;
    font: normal normal bold 18px/23px BCSans;
    color: #707070;
  }

  .grant-content {
    padding: 1.25em;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    max-height: 250px;
    overflow-y: auto;
  }
}
</style>
