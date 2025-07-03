<template>
  <aside
    class="fixed top-16 left-0 w-64 h-[calc(100vh-4rem)] z-40 bg-white border-r border-gray-300 shadow-lg font-sans overflow-y-auto transition-transform duration-300"
    :class="{ '-translate-x-full': !isVisible, 'translate-x-0': isVisible }"
  >
    <nav class="p-6 space-y-6 text-gray-700 text-base leading-tight">

      <!-- User Management Group -->
      <div class="space-y-2">
        <p class="text-blue-700 font-bold uppercase tracking-tight text-sm flex items-center gap-1">
          <span>👤</span> User Management
        </p>

        <SidebarLink to="/users" label="All Users" />
        <SidebarLink to="/roles" label="Roles & Permissions" />
        <SidebarLink to="/departments" label="Departments" />
        <SidebarLink to="/profiles" label="Profiles" />
      </div>

      <!-- Permission Center Group -->
      <div class="space-y-2">
        <p class="text-blue-700 font-bold uppercase tracking-tight text-sm flex items-center gap-1">
          <span>🔐</span> Permission Center
        </p>
        <SidebarLink to="/permission-requests" label="Request Permission" />
        <SidebarLink to="/my-requests" label="My Requests" />
        <SidebarLink to="/approvals" label="Approvals" />
      </div>

      <!-- Permissions Group -->
      <div class="space-y-2">
        <p class="text-blue-700 font-bold uppercase tracking-tight text-sm flex items-center gap-1">
          <span>⚙️</span> Permissions
        </p>
        <SidebarLink to="/permission-types" label="Permission Types" />
        <SidebarLink to="/access-control" label="Access Control" />
      </div>

      <!-- Notifications Group -->
      <div class="space-y-2">
        <p class="text-blue-700 font-bold uppercase tracking-tight text-sm flex items-center gap-1">
          <span>🔔</span> Notifications
        </p>
        <SidebarLink to="/notifications" label="My Notifications" />
      </div>

      <!-- Audit Group -->
      <div class="space-y-2">
        <p class="text-blue-700 font-bold uppercase tracking-tight text-sm flex items-center gap-1">
          <span>🕵️</span> Audit
        </p>
        <SidebarLink to="/audit-logs" label="Audit Logs" />
      </div>

    </nav>
  </aside>
</template>

<script setup>
import SidebarLink from './SidebarLink.vue'
import { defineProps } from 'vue'

const props = defineProps({
  isVisible: {
    type: Boolean,
    default: true,
  },
})
</script>
