<template>
  <div class="ds-container"><slot></slot></div>
</template>

<script></script>

<style>
.ds-container {
  position: fixed;
  top: 0;
  left: 0;
  bottom: 0;
  width: var(--sidebar-wdith, 350px);
  display: flex;
  flex-direction: column;
}
</style>
