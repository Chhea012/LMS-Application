<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  profileOpen: Boolean
})

const emit = defineEmits(['toggle-profile', 'toggle-sidebar'])

const toggleProfile = () => emit('toggle-profile')
const toggleSidebar = () => emit('toggle-sidebar')
</script>

<template>
  <header
    class="h-16 bg-white shadow-sm border-b border-gray-200 flex items-center justify-between px-6 sticky top-0 z-30"
  >
    <!-- Left: Menu Button -->
    <div class="flex items-center gap-4">
      <button
        @click="toggleSidebar"
        class="lg:hidden p-2 rounded-lg text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition-colors"
      >
        <svg
          class="w-5 h-5"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
    </div>

    <!-- Right: Notification + Profile -->
    <div class="flex items-center gap-4">
      <!-- Notification Button -->
      <button
        class="relative p-2 rounded-lg text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition-colors"
      >
        <svg
          class="w-5 h-5"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M15 17h5l-1.405-1.405C18.79 14.79 18 13.42 18 12V8a6 6 0 10-12 0v4c0 1.42-.79 2.79-1.595 3.595L3 17h5m4 0v1a2 2 0 104 0v-1m-4 0h4"
          />
        </svg>
        <span
          class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center font-medium"
          >3</span
        >
      </button>

      <!-- Profile Dropdown -->
      <div class="relative">
        <button
          @click="toggleProfile"
          class="flex items-center gap-3 p-2 rounded-lg text-gray-700 hover:bg-gray-100 transition-colors"
        >
          <img
            src="https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg"
            class="w-8 h-8 rounded-full ring-2 ring-gray-200"
            alt="User Avatar"
          />
          <div class="hidden sm:block text-left">
            <p class="text-sm font-medium text-gray-900">Sophean Phouk</p>
            <p class="text-xs text-gray-500">Product Owner</p>
          </div>
          <svg
            class="h-4 w-4 text-gray-400 transition-transform"
            :class="{ 'rotate-180': profileOpen }"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
          </svg>
        </button>

        <div
          v-if="profileOpen"
          class="absolute right-0 mt-2 w-56 bg-white rounded-lg shadow-lg border border-gray-200 py-2 z-50"
          @click.stop
        >
          <div class="flex items-center gap-3 px-4 py-3 border-b border-gray-100">
            <img
              src="https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg"
              class="w-8 h-8 rounded-full ring-2 ring-gray-200"
              alt="User Avatar"
            />
            <div>
              <p class="text-sm font-medium text-gray-900">Sophean Phouk</p>
              <p class="text-xs text-gray-500">Product Owner</p>
            </div>
          </div>
          <div class="py-2">
            <a
              href="#"
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
            >
              Profile Settings
            </a>
            <a
              href="#"
              class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
            >
              Account
            </a>
          </div>
          <div class="border-t border-gray-100 pt-2">
            <a
              href="#"
              class="block px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition-colors"
            >
              Sign Out
            </a>
          </div>
        </div>
      </div>
    </div>
  </header>
</template>
