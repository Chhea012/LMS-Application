<script setup>
import { defineProps, defineEmits } from 'vue'

const props = defineProps({
  navigationItems: Array,
  sidebarOpen: Boolean,
  openSubmenus: Array
})

const emit = defineEmits(['toggle-submenu', 'toggle-sidebar'])

// Methods just emit events up to parent
const toggleSubmenu = (title) => {
  emit('toggle-submenu', title)
}
const toggleSidebar = () => {
  emit('toggle-sidebar')
}
</script>

<template>
  <aside
    :class="[
      'fixed z-40 inset-y-0 left-0 w-64 bg-white shadow-lg transform transition-transform duration-300 ease-in-out border-r border-gray-200',
      sidebarOpen ? 'translate-x-0' : '-translate-x-full',
      'lg:translate-x-0 lg:static lg:shadow-none'
    ]"
  >
    <!-- Sidebar Header -->
    <div class="border-b border-gray-200 p-6">
      <div class="flex items-center gap-3">
        <div
          class="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-600 text-white"
        >
          <!-- Slot for logo SVG or image -->
          <slot name="logo" />
        </div>
        <div class="flex flex-col">
          <span class="text-lg font-semibold tracking-tight text-gray-900"
            >PMS</span
          >
          <span class="text-xs text-gray-500">Permission Management</span>
        </div>
      </div>
    </div>

    <!-- Navigation Menu -->
    <nav class="px-4 py-4">
      <ul class="space-y-1">
        <li v-for="item in navigationItems" :key="item.title">
          <!-- Single Menu Item -->
          <template v-if="!item.items">
            <router-link
              :to="item.url"
              class="flex items-center gap-3 px-3 py-2.5 text-sm font-medium rounded-lg transition-colors hover:bg-gray-100 group"
              :class="{
                'bg-blue-50 text-blue-700 border-r-2 border-blue-600': $route.path === item.url
              }"
            >
              <component :is="item.icon" class="h-4 w-4" />
              <span>{{ item.title }}</span>
            </router-link>
          </template>

          <!-- Collapsible Menu Item -->
          <template v-else>
            <div>
              <button
                @click="toggleSubmenu(item.title)"
                class="flex w-full items-center justify-between gap-3 px-3 py-2.5 text-sm font-medium rounded-lg transition-colors hover:bg-gray-100 group"
                :class="{ 'bg-gray-100': openSubmenus.includes(item.title) }"
              >
                <div class="flex items-center gap-3">
                  <component :is="item.icon" class="h-4 w-4" />
                  <span>{{ item.title }}</span>
                </div>
                <svg
                  class="h-4 w-4 transition-transform"
                  :class="{ 'rotate-90': openSubmenus.includes(item.title) }"
                  fill="none"
                  stroke="currentColor"
                  stroke-width="2"
                  viewBox="0 0 24 24"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    d="M9 5l7 7-7 7"
                  />
                </svg>
              </button>

              <div
                v-if="openSubmenus.includes(item.title)"
                class="ml-6 mt-1 space-y-1 border-l border-gray-200 pl-4"
              >
                <router-link
                  v-for="subItem in item.items"
                  :key="subItem.title"
                  :to="subItem.url"
                  class="block px-3 py-2 text-sm font-medium rounded-lg transition-colors hover:bg-gray-100"
                  :class="{ 'bg-blue-50 text-blue-700': $route.path === subItem.url }"
                >
                  {{ subItem.title }}
                </router-link>
              </div>
            </div>
          </template>
        </li>
      </ul>
    </nav>
  </aside>
</template>
