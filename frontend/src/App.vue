<script setup>
import { RouterLink, RouterView } from 'vue-router'
</script>

<template>
      <nav>
        <RouterLink to="/" class=" text-blue-600 p-4">Home</RouterLink>
        <RouterLink to="/about" class=" text-blue-600 ">About</RouterLink>
      </nav>
  <RouterView />
</template>
