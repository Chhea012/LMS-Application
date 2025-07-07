<script setup>
import { ref, onMounted } from 'vue'
import api from '@/plugin/axios.js'

const props = defineProps({
  profileOpen: Boolean
})

const emit = defineEmits(['toggle-profile', 'toggle-sidebar'])

const notifications = ref([])
const notificationOpen = ref(false)
const loading = ref(false)
const toast = ref({
  visible: false,
  message: '',
  type: 'success',
})
// Mocked user (Sophean, admin). Replace with auth context (e.g., store.getters.currentUser).
const currentUser = ref({ id: 1, full_name: 'Sophean Phouk', role_id: 1, department_id: 1 })

function showToast(message, type = 'success') {
  toast.value.message = message
  toast.value.type = type
  toast.value.visible = true
  setTimeout(() => {
    toast.value.visible = false
  }, 3000)
}

async function fetchNotifications() {
  loading.value = true
  try {
    const res = await api.get('/notification')
    const data = res.data.notification
    if (Array.isArray(data)) {
      notifications.value = data.map(n => ({
        ...n,
        status: n.is_read ? 'read' : 'unread' // Map is_read (0/1) to status (unread/read)
      }))
    } else {
      throw new Error('Invalid notifications data format')
    }
  } catch (err) {
    console.error('Error fetching notifications:', err.message, err.response?.data)
    showToast('Failed to load notifications.', 'error')
  } finally {
    loading.value = false
  }
}

function toggleNotification() {
  notificationOpen.value = !notificationOpen.value
  if (notificationOpen.value) {
    fetchNotifications()
  }
}

function toggleProfile() {
  emit('toggle-profile')
}

function toggleSidebar() {
  emit('toggle-sidebar')
}

function formatDate(dateString) {
  return dateString ? new Date(dateString).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit' }) : 'N/A'
}

onMounted(() => {
  fetchNotifications()
})
</script>

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

    <!-- Right: Notifications and Profile -->
    <div class="flex items-center gap-4">
      <!-- Notification Icon -->
      <div class="relative">
        <button
          @click="toggleNotification"
          class="relative p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition"
          :disabled="loading"
        >
          <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M15 17h5l-1.405-1.405C18.79 14.79 18 13.42 18 12V8a6 6 0 10-12 0v4c0 1.42-.79 2.79-1.595 3.595L3 17h5m4 0v1a2 2 0 104 0v-1m-4 0h4"
            />
          </svg>
          <span
            v-if="notifications.filter(n => n.status === 'unread').length > 0"
            class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center"
          >
            {{ notifications.filter(n => n.status === 'unread').length }}
          </span>
        </button>
        <!-- Notification Dropdown -->
        <transition name="fade">
          <div
            v-if="notificationOpen"
            class="absolute right-0 mt-2 w-80 bg-white rounded-md shadow-lg border border-gray-200 py-2 z-50"
            @click.stop
          >
            <div class="px-4 py-3 border-b border-gray-100">
              <p class="text-sm font-medium text-gray-900">Notifications</p>
            </div>
            <div v-if="loading" class="px-4 py-3 text-sm text-gray-500 text-center">
              Loading notifications...
            </div>
            <div v-else-if="notifications.length === 0" class="px-4 py-3 text-sm text-gray-500 text-center">
              No notifications available.
            </div>
            <div v-else class="max-h-96 overflow-y-auto">
              <div
                v-for="notification in notifications"
                :key="notification.id"
                class="px-4 py-3 border-b border-gray-100 last:border-b-0"
              >
                <p class="text-sm text-gray-800">{{ notification.message }}</p>
                <p class="text-xs text-gray-500">{{ formatDate(notification.created_at) }}</p>
                <p class="text-xs" :class="notification.status === 'unread' ? 'text-blue-600' : 'text-gray-600'">
                  Status: {{ notification.status }}
                </p>
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
            @click.stop
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

    <!-- Toast Notification -->
    <transition name="toast-fade">
      <div v-if="toast.visible" :class="[
        'fixed bottom-6 right-6 px-4 py-2 rounded shadow-md text-white font-semibold select-none',
        toast.type === 'success' ? 'bg-green-600' : 'bg-red-600',
      ]" role="alert">
        {{ toast.message }}
      </div>
    </transition>
  </header>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
.toast-fade-enter-active,
.toast-fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.toast-fade-enter-from,
.toast-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>