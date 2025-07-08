<template>
  <header
    class="h-16 sticky top-0 z-40 bg-white border-b border-gray-200 shadow-sm flex items-center justify-between px-4 sm:px-6"
  >
    <!-- Left: Sidebar Toggle (Mobile) -->
    <div class="flex items-center gap-3">
      <button
        @click="toggleSidebar"
        class="lg:hidden p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition"
      >
        <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="M4 6h16M4 12h16M4 18h16" />
        </svg>
      </button>
      <span class="text-xl font-semibold text-teal-700 hidden sm:block">LMS Dashboard</span>
    </div>

    <!-- Right: Actions -->
    <div class="flex items-center gap-4">
      <!-- Notification -->
      <div class="relative">
        <button
          @click="toggleNotifications"
          class="relative p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition"
          aria-label="Toggle notifications"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M15 17h5l-1.405-1.405C18.79 14.79 18 13.42 18 12V8a6 6 0 10-12 0v4c0 1.42-.79 2.79-1.595 3.595L3 17h5m4 0v1a2 2 0 104 0v-1m-4 0h4"
            />
          </svg>
          <span
            v-if="notifications.length"
            class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center"
          >
            {{ notifications.length }}
          </span>
        </button>

        <!-- Notification Dropdown -->
        <transition name="fade">
          <div
            v-if="notificationOpen"
            class="absolute right-0 mt-2 w-80 bg-white rounded-md shadow-lg border border-gray-200 py-2 z-50 max-h-96 overflow-y-auto"
          >
            <div v-if="notifications.length === 0" class="px-4 py-3 text-sm text-gray-500">
              No new notifications
            </div>
            <div v-for="notification in notifications" :key="notification.id" class="border-b border-gray-100 last:border-b-0">
              <div class="px-4 py-3">
                <p class="text-sm font-medium text-gray-900">
                  New request from {{ notification.user?.full_name || 'N/A' }}
                </p>
                <p class="text-xs text-gray-500">{{ notification.reason }}</p>
                <p class="text-xs text-gray-400">{{ formatDate(notification.created_at) }}</p>
                <div class="mt-2 flex gap-2">
                  <button
                    @click="handleRequestAction(notification.id, 'approved')"
                    class="px-3 py-1 bg-green-600 text-white text-xs rounded hover:bg-green-700"
                    :disabled="loading"
                  >
                    Approve
                  </button>
                  <button
                    @click="handleRequestAction(notification.id, 'rejected')"
                    class="px-3 py-1 bg-red-600 text-white text-xs rounded hover:bg-red-700"
                    :disabled="loading"
                  >
                    Reject
                  </button>
                </div>
              </div>
            </div>
          </div>
        </transition>
      </div>

      <!-- Profile -->
      <div class="relative">
        <button
          @click="toggleProfile"
          class="flex items-center gap-2 sm:gap-3 p-2 rounded-md hover:bg-gray-100 transition"
          aria-label="Toggle profile"
        >
          <img
            src="https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg"
            alt="User"
            class="w-8 h-8 rounded-full ring-1 ring-gray-200 object-cover"
          />
          <div class="hidden sm:block text-left">
            <p class="text-sm font-medium text-gray-800">Sophean Phouk</p>
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

        <!-- Profile Dropdown -->
        <transition name="fade">
          <div
            v-if="profileOpen"
            class="absolute right-0 mt-2 w-56 bg-white rounded-md shadow-lg border border-gray-200 py-2 z-50"
          >
            <div class="flex items-center gap-3 px-4 py-3 border-b border-gray-100">
              <img
                src="https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg"
                class="w-9 h-9 rounded-full ring-2 ring-gray-200"
                alt="User Avatar"
              />
              <div>
                <p class="text-sm font-medium text-gray-900">Sophean Phouk</p>
                <p class="text-xs text-gray-500">Product Owner</p>
              </div>
            </div>
            <div class="py-2">
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Profile Settings</a>
              <a href="#" class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">Account</a>
            </div>
            <div class="border-t border-gray-100 pt-2">
              <a href="#" class="block px-4 py-2 text-sm text-red-600 hover:bg-red-50">Sign Out</a>
            </div>
          </div>
        </transition>
      </div>
    </div>
  </header>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '@/plugin/axios.js'

const props = defineProps({
  profileOpen: Boolean,
  requestViewRef: Object, // Reference to RequestView.vue component
})

const emit = defineEmits(['toggle-profile', 'toggle-sidebar', 'notification-updated'])

const notificationOpen = ref(false)
const notifications = ref([])
const loading = ref(false)

const toggleProfile = () => emit('toggle-profile')
const toggleSidebar = () => emit('toggle-sidebar')
const toggleNotifications = () => {
  notificationOpen.value = !notificationOpen.value
}

function formatDate(dateString) {
  return new Date(dateString).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' })
}

async function fetchNotifications() {
  try {
    const response = await api.get('/permissionrequests?status=pending')
    notifications.value = response.data.filter(request => request.status === 'pending')
  } catch (error) {
    console.error('Failed to fetch notifications:', error)
  }
}

async function handleRequestAction(id, status) {
  if (!props.requestViewRef) {
    console.error('requestViewRef is not defined')
    return
  }
  try {
    loading.value = true
    await props.requestViewRef.updateRequestStatus(id, status)
    notifications.value = notifications.value.filter(n => n.id !== id)
    emit('notification-updated') // Notify parent to refresh RequestView
    console.log(`Request ${id} ${status} successfully`)
  } catch (error) {
    console.error(`Failed to ${status} request:`, error)
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchNotifications()
})

defineExpose({
  addNotification(request) {
    notifications.value.unshift(request)
  }
})
</script>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>