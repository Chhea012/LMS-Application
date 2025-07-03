<script setup>
import { RouterView } from 'vue-router'
import Sidebar from '../components/Sidebar.vue'
import TopBar from '../components/Topbar.vue'
</script>

<template>
  <div class="min-h-screen flex bg-gray-100 text-gray-800">

    <!-- Sidebar -->
    <div class="md:flex md:w-64 flex-shrink-0">
      <Sidebar />
    </div>

    <!-- Main content area -->
    <div class="flex flex-col flex-1 w-0">
      
      <!-- Topbar -->
      <div class="flex-shrink-0">
        <TopBar />
      </div>

      <!-- Page content -->
      <main class="flex-1 overflow-y-auto p-6 bg-gray-50">
        <RouterView />
      </main>
    </div>
  </div>
</template>

