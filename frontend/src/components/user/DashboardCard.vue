
<template>
  <div
    class="bg-white shadow-lg rounded-xl p-6 transition-transform"
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
