<template>
  <header
    class="fixed top-0 left-0 w-full h-16 z-50 bg-gradient-to-r from-indigo-700 via-sky-500 to-cyan-400 text-white flex items-center justify-between px-6 shadow-md"
  >
    <div class="flex items-center space-x-4">
      <button @click="$emit('toggle-sidebar')" class="p-2 rounded-md hover:bg-white/20 transition">
        <svg xmlns="http://www.w3.org/2000/svg" class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24"
          stroke="currentColor">
          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
            d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <h1 class="text-2xl font-bold">Welcome to Admin LMS Dashboard</h1>
    </div>

    <div class="flex items-center gap-2">
      <p class="text-purple-800 font-bold tracking-tight text-2xl flex items-center gap-1">
          Admin
      </p>
      <img
        src="../assets/images/image.png"
        alt="Profile"
        class="w-12 h-12 rounded-full ring-2 ring-white-300 object-cover shadow"
      />
    </div>
  </header>
</template>

<script setup>
defineEmits(['toggle-sidebar'])
</script>
