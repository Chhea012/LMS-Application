<template>
  <Navbar
    :profileOpen="profileOpen"
    @toggle-profile="toggleProfile"
    @close-profile="closeProfile"
  />

  <div class="p-6 min-h-screen bg-gradient-to-br from-white via-teal-50 to-white">
    <div class="max-w-7xl mx-auto">
      <div class="flex items-center justify-between mb-8">
        <button
          @click="goBack"
          class="group flex items-center text-sm text-white bg-teal-600 hover:bg-teal-700 shadow-md rounded-full px-5 py-2 transition-all hover:scale-105"
        >
          <svg
            class="w-4 h-4 mr-2 transition-transform group-hover:-translate-x-1"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
          Back
        </button>

        <div class="flex items-center gap-3">
          <svg
            xmlns="http://www.w3.org/2000/svg"
            class="h-7 w-7 text-teal-600"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M9 17v-2a4 4 0 014-4h1a4 4 0 110 8h-1a4 4 0 01-4-4z"
            />
          </svg>
          <h1 class="text-2xl font-bold text-teal-700 hidden sm:block">
            Permission History Details
          </h1>
        </div>
      </div>

      <div v-if="isLoading" class="text-center text-gray-500">Loading...</div>
      <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <div
          class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-teal-400"
        >
          <h3 class="text-sm text-gray-500 mb-2">Total Requests</h3>
          <span class="text-3xl font-bold text-teal-700">{{ total }}</span>
        </div>
        <div
          class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-green-400"
        >
          <h3 class="text-sm text-gray-500 mb-2">Approved</h3>
          <span class="text-3xl font-bold text-green-600">{{ approved }}</span>
        </div>
        <div
          class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-red-400"
        >
          <h3 class="text-sm text-gray-500 mb-2">Rejected</h3>
          <span class="text-3xl font-bold text-red-600">{{ rejected }}</span>
        </div>
      </div>

      <RequestTable v-if="!isLoading" :requests="requests" />

      <!-- Toast Notification -->
      <transition name="toast-fade">
        <div
          v-if="toast.visible"
          :class="[
            'fixed bottom-6 right-6 px-4 py-2 rounded shadow-md text-white font-semibold select-none',
            toast.type === 'success' ? 'bg-green-600' : 'bg-red-600',
          ]"
          role="alert"
        >
          {{ toast.message }}
        </div>
      </transition>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'
import RequestTable from '@/components/user/RequestTable.vue'
import apiInstance from '@/plugin/axios'

const router = useRouter()
const requests = ref([])
const isLoading = ref(true)
const profileOpen = ref(false)

const toast = ref({
  visible: false,
  message: '',
  type: 'success',
})

function showToast(message, type = 'success') {
  toast.value.message = message
  toast.value.type = type
  toast.value.visible = true
  setTimeout(() => {
    toast.value.visible = false
  }, 2000)
}

function toggleProfile() {
  profileOpen.value = !profileOpen.value
}

function closeProfile() {
  profileOpen.value = false
}

const fetchRequests = async () => {
  try {
    isLoading.value = true
    const response = await apiInstance.get('/permissionrequests', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    requests.value = response.data || []
  } catch (error) {
    console.error('Error fetching requests:', error)
    showToast('Failed to fetch requests.', 'error')
  } finally {
    isLoading.value = false
  }
}

const total = computed(() => requests.value.length)
const approved = computed(
  () => requests.value.filter(r => r.status.toLowerCase() === 'approved').length
)
const rejected = computed(
  () => requests.value.filter(r => r.status.toLowerCase() === 'rejected').length
)

function goBack() {
  profileOpen.value = false // Close dropdown on navigation
  router.back()
}

onMounted(fetchRequests)
</script>

<style>
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