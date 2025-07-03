<template>
  <router-link
    :to="to"
    class="block px-4 py-2 rounded transition-all duration-200 hover:bg-purple-100 hover:text-purple-800"
    active-class="bg-purple-200 text-purple-900 font-semibold"
  >
    {{ label }}
  </router-link>
</template>

<script setup>
defineProps({
  to: String,
  label: String
});
</script>
