<script setup>
import { defineProps, defineEmits } from "vue";

const props = defineProps({
  navigationItems: Array,
  sidebarOpen: Boolean,
  openSubmenus: Array,
});

const emit = defineEmits(["toggle-submenu", "toggle-sidebar"]);

const toggleSubmenu = (title) => {
  emit("toggle-submenu", title);
};

const toggleSidebar = () => {
  emit("toggle-sidebar");
};
</script>

<template>
  <aside
    :class="[
      'fixed z-40 inset-y-0 left-0 w-64 h-screen overflow-y-auto bg-slate-950 shadow-lg border-r border-gray-800',
      // Remove transform/translate for large screens so it's always visible fixed
      sidebarOpen ? 'translate-x-0' : '-translate-x-full',
      'lg:translate-x-0', // remove lg:static and lg:shadow-none here
    ]"
  >
    <!-- Sidebar Header -->
    <div class="border-b border-gray-800 p-6">
      <div class="flex items-center gap-3">
        <div
          class="flex h-10 w-10 items-center justify-center rounded-lg bg-blue-600 text-white"
        >
          <!-- Slot for logo -->
          <slot name="logo" />
        </div>
        <div class="flex flex-col">
          <span class="text-white text-lg font-semibold tracking-tight"
            >LMS</span
          >
          <span class="text-xs text-gray-400">Permission Management</span>
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
              class="flex items-center gap-3 px-3 py-2.5 text-sm font-medium rounded-lg transition-colors group"
              :class="{
                'bg-teal-600 text-white border-r-2 border-teal-700':
                  $route.path === item.url,
                'text-gray-300 hover:bg-slate-800 hover:text-white':
                  $route.path !== item.url,
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
                class="flex w-full items-center justify-between gap-3 px-3 py-2.5 text-sm font-medium rounded-lg transition-colors group"
                :class="{
                  'bg-slate-800 text-white': openSubmenus.includes(item.title),
                  'text-gray-300 hover:bg-slate-800 hover:text-white':
                    !openSubmenus.includes(item.title),
                }"
              >
                <div class="flex items-center gap-3">
                  <component :is="item.icon" class="h-4 w-4" />
                  <span>{{ item.title }}</span>
                </div>
                <svg
                  class="h-4 w-4 transition-transform text-gray-400"
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

              <!-- Submenu -->
              <div
                v-if="openSubmenus.includes(item.title)"
                class="ml-6 mt-1 space-y-1 border-l border-gray-700 pl-4"
              >
                <router-link
                  v-for="subItem in item.items"
                  :key="subItem.title"
                  :to="subItem.url"
                  class="block px-3 py-2 text-sm font-medium rounded-lg transition-colors"
                  :class="{
                    'bg-teal-600 text-white': $route.path === subItem.url,
                    'text-gray-300 hover:bg-slate-800 hover:text-white':
                      $route.path !== subItem.url,
                  }"
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
