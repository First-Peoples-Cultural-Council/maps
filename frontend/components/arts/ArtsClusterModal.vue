<template>
  <div class="art-cluster-container">
    <div class="header"></div>
    <div class="title">Showing {{ placenames.length }} Results</div>
    <div class="content">
      <a
        v-for="placename in placenames"
        :key="placename.properties.id"
        href="#"
        @click="goToPlacename(placename)"
      >
        {{ placename.properties.name }} -
        {{ placename.properties.kind.replace('_', ' ') }}
      </a>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    placenames: {
      type: Array,
      default: () => {
        return []
      }
    }
  }
}
</script>

<style lang="scss">
.art-cluster-container {
  width: 100%;
  overflow-y: auto;
  overflow-x: hidden;
  border: 0.8px solid #9f9f9f;
  border-radius: 0.5em;

  .header {
    background-color: #b45339;
    padding: 0.25em;
    height: 25px;
    color: white;
  }

  .title {
    border-bottom: 0.8px solid #9f9f9f;
    padding: 0.75em;
    text-align: center;
    font: normal normal bold 18px/23px Proxima Nova;
    color: #707070;
  }

  .content {
    padding: 1.25em;
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    max-height: 250px;
    overflow-y: auto;
    text-transform: capitalize;
  }
}
</style>
