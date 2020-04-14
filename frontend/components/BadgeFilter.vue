<template>
  <div class="badge-filter-container">
    <slot name="badge"></slot>
    <div class="badge-filters">
      <!-- <p>choose sub-category</p> -->
      <b-dropdown
        size="sm"
        variant="link"
        toggle-class="text-decoration-none"
        no-caret
        dropleft
      >
        <template v-slot:button-content>
          choose sub-category
        </template>
        <b-dropdown-item href="#">Administrator</b-dropdown-item>
        <b-dropdown-item href="#">Artist</b-dropdown-item>
      </b-dropdown>
    </div>
  </div>
</template>

<script>
export default {}
</script>

<style></style>
