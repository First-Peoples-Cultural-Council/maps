<template>
  <div class="searchbar-container">
    <div class="searchbar-input-container">
      <input
        class="searchbar-input"
        placeholder="Search for any term, like Secwepemctsin"
      />
      <span class="searchbar-icon"></span>
    </div>
  </div>
</template>

<script>
export default {};
</script>

<style>
.searchbar-container {
  position: fixed;
  top: 10px;
  left: calc(50% - 250px);
  width: 500px;
}
.searchbar-input-container {
  display: flex;
}
.searchbar-input {
  flex: 10 1 0;
  padding: 0.5em 1em;
  border-top-left-radius: 0.5em;
  border-bottom-left-radius: 0.5em;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-right: 0;
  outline: none;
}
.searchbar-icon {
  flex: 1 1 0;
  background-color: white;
  border-top-right-radius: 0.5em;
  border-bottom-right-radius: 0.5em;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-left: 0;
}
</style>
