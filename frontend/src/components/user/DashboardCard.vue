<template>
  <div class="bg-white shadow rounded-xl p-6" @click="$emit('click')">
    <h2 class="text-lg font-semibold mb-2">{{ title }}</h2>
    <slot />
  </div>
</template>

<script setup>
defineProps({ title: String })
</script>
