<template>
  <div
    class="bg-white shadow-lg rounded-xl p-6 transition-transform hover:shadow-xl"
    :class="[$attrs.class]"
    @click="$emit('click')"
  >
    <h2 class="text-lg font-semibold mb-2 text-teal-700">{{ title }}</h2>
    <slot />
  </div>
</template>

<script setup>
defineProps({
  title: {
    type: String,
    required: true,
  },
})

defineEmits(['click'])
</script>

<style scoped>
/* Ensure hover effect is smooth */
div {
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
</style>