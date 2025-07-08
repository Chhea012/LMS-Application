<script setup>
import { defineComponent, h, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import LoginView from '@/views/LoginView.vue'
import Sidebar from '@/components/layout/Sidebar.vue'
import Navbar from '@/components/layout/Navbar.vue'


// Icon components
const HomeIcon = defineComponent({
  name: 'HomeIcon',
  render() {
    return h('svg', { class: 'h-4 w-4', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, viewBox: '0 0 24 24' }, [
      h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        d: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6'
      })
    ])
  }
})

const BuildingIcon = defineComponent({
  name: 'BuildingIcon',
  render() {
    return h('svg', { class: 'h-4 w-4', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, viewBox: '0 0 24 24' }, [
      h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        d: 'M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-4m-5 0H3m2 0h4M9 7h1m-1 4h1m4-4h1m-1 4h1m-3 4h2'
      })
    ])
  }
})

const ShieldIcon = defineComponent({
  name: 'ShieldIcon',
  render() {
    return h('svg', { class: 'h-4 w-4', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, viewBox: '0 0 24 24' }, [
      h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        d: 'M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z'
      })
    ])
  }
})

const UsersIcon = defineComponent({
  name: 'UsersIcon',
  render() {
    return h('svg', { class: 'h-4 w-4', fill: 'none', stroke: 'currentColor', 'stroke-width': 2, viewBox: '0 0 24 24' }, [
      h('path', {
        'stroke-linecap': 'round',
        'stroke-linejoin': 'round',
        d: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197m13.5-9a4 4 0 11-8 0 4 4 0 018 0z'
      })
    ])
  }
})

// Reactive states
const sidebarOpen = ref(false)
const profileOpen = ref(false)
const openSubmenus = ref(['Permission'])

const navigationItems = [
  { title: 'Dashboard', url: '/', icon: HomeIcon },
  { title: 'Department', url: '/department', icon: BuildingIcon },
  {
    title: 'Permission',
    icon: ShieldIcon,
    items: [
      { title: 'Request', url: '/permission/request' },
      { title: 'Type', url: '/permission/type' },
      { title: 'Approval', url: '/permission/approval' }
    ]
  },
  { title: 'User', url: '/user', icon: UsersIcon }
]

const toggleSidebar = () => {
  sidebarOpen.value = !sidebarOpen.value
}

const toggleProfile = () => {
  profileOpen.value = !profileOpen.value
}

const toggleSubmenu = (title) => {
  const index = openSubmenus.value.indexOf(title)
  if (index > -1) {
    openSubmenus.value.splice(index, 1)
  } else {
    openSubmenus.value.push(title)
  }
}

const route = useRoute()
watch(
  () => route.path,
  () => {
    sidebarOpen.value = false
  }
)
</script>

<template>
  <div>
    <!-- Show only LoginView if on /login -->
    <LoginView v-if="route.path === '/login'" />

    <!-- Otherwise, show full layout -->
    <div v-else class="flex min-h-screen w-full bg-gray-50">
      <Sidebar
        :navigation-items="navigationItems"
        :sidebar-open="sidebarOpen"
        :open-submenus="openSubmenus"
        @toggle-submenu="toggleSubmenu"
        @toggle-sidebar="toggleSidebar"
      >
        <template #logo>
          <ShieldIcon />
        </template>
      </Sidebar>

      <div class="flex-1 flex flex-col lg:ml-64">
        <Navbar
          :profile-open="profileOpen"
          @toggle-profile="toggleProfile"
          @toggle-sidebar="toggleSidebar"
          @close-profile="profileOpen = false"
        />
        <main class="mt-6 px-4 sm:px-6 lg:px-8">
          <router-view />
        </main>
      </div>
    </div>
  </div>
</template>


