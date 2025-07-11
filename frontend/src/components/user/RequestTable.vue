<script setup>
import { ref, onMounted, computed } from 'vue'
import apiInstance from '@/plugin/axios'

const requests = ref([])
const permissionTypes = ref([])
const isLoading = ref(true)
const errorMessage = ref('')
const currentUserId = ref(null)
const showReasonPopup = ref(false)
const currentReason = ref('')

// Fetch logged-in user’s ID
const fetchCurrentUser = async () => {
  try {
    const res = await apiInstance.get('/user')
    console.log('User Response:', res.data)
    if (res.data && res.data.id) {
      currentUserId.value = res.data.id
    } else {
      errorMessage.value = 'Failed to fetch user ID'
    }
  } catch (error) {
    console.error('User Fetch Error:', error)
    errorMessage.value = error.response
      ? `User Fetch Error: ${error.response.status} - ${error.response.data?.message || 'Unknown error'}`
      : `Network Error: ${error.message}`
  }
}

// Fetch permission types
const fetchPermissionTypes = async (retries = 3, delay = 1000) => {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const res = await apiInstance.get('/permissiontypes', { timeout: 5000 })
      console.log('Permission Types Response:', res.data)
      permissionTypes.value = Array.isArray(res.data.data)
        ? res.data.data
        : Array.isArray(res.data)
        ? res.data
        : []
      return
    } catch (error) {
      console.error(`Permission Types Attempt ${attempt} failed:`, error)
      if (attempt < retries) {
        await new Promise((resolve) => setTimeout(resolve, delay))
      } else {
        errorMessage.value = error.response
          ? `Permission Types Error: ${error.response.status} - ${error.response.data?.message || 'Unknown error'}`
          : `Network Error: ${error.message}`
      }
    }
  }
}

// Fetch permission requests
const fetchRequests = async (retries = 3, delay = 1000) => {
  for (let attempt = 1; attempt <= retries; attempt++) {
    try {
      const res = await apiInstance.get('/permissionrequests', { timeout: 5000 })
      console.log('Requests Response:', res.data)
      requests.value = Array.isArray(res.data.data)
        ? res.data.data
        : Array.isArray(res.data)
        ? res.data
        : []
      console.log('Requests:', requests.value)
      errorMessage.value = ''
      return
    } catch (error) {
      console.error(`Requests Attempt ${attempt} failed:`, error)
      if (attempt < retries) {
        await new Promise((resolve) => setTimeout(resolve, delay))
      } else {
        errorMessage.value = error.response
          ? `Requests Error: ${error.response.status} - ${error.response.data?.message || 'Unknown error'}`
          : `Network Error: ${error.message}`
      }
    }
  }
}

// Fetch data on mount
onMounted(async () => {
  await fetchCurrentUser()
  if (currentUserId.value) {
    await Promise.all([fetchPermissionTypes(), fetchRequests()])
  } else {
    errorMessage.value = 'Cannot fetch data without user ID'
  }
  isLoading.value = false
})

const filterStatus = ref('')

// Compute filtered requests
const filteredRequests = computed(() => {
  if (!Array.isArray(requests.value) || !currentUserId.value) return []
  let filtered = requests.value.filter((r) => r.user_id === currentUserId.value)
  if (filterStatus.value) {
    filtered = filtered.filter((r) => r.status === filterStatus.value)
  }
  console.log('Filtered Requests:', filtered)
  return filtered
})

// Map permission_type_id to name
const getPermissionTypeName = (permissionTypeId) => {
  const type = permissionTypes.value.find((pt) => pt.id === permissionTypeId)
  return type ? type.name : 'N/A'
}

// Format morning/afternoon for leave and back
const formatTimeOfDay = (morning, afternoon) => {
  const times = []
  if (morning) times.push('Morning')
  if (afternoon) times.push('Afternoon')
  return times.length > 0 ? times.join(', ') : 'N/A'
}

// Open reason popup
function openReasonPopup(reason) {
  currentReason.value = reason || 'N/A'
  showReasonPopup.value = true
}

// Close reason popup
function closeReasonPopup() {
  showReasonPopup.value = false
  currentReason.value = ''
}
</script>

<template>
  <div class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100">
    <!-- Header -->
    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
      <h2 class="text-xl font-semibold mb-5 text-teal-700 border-b pb-2">Request History</h2>
      <select
        v-model="filterStatus"
        class="border rounded px-3 py-1 text-sm focus:outline-none focus:ring-2 focus:ring-teal-500"
      >
        <option value="">All</option>
        <option value="approved">Approved</option>
        <option value="pending">Pending</option>
        <option value="rejected">Rejected</option>
      </select>
    </div>

    <!-- Error or Loading -->
    <div v-if="errorMessage" class="text-center text-red-500 py-4">
      {{ errorMessage }}
    </div>
    <div v-else-if="isLoading" class="text-center text-gray-500 py-4">Loading...</div>

    <!-- Table -->
    <div v-else class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-teal-50 text-teal-700">
          <tr>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Permission Type</th>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Reason</th>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Date Leave</th>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Leave Time</th>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Date Back</th>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Back Time</th>
            <th class="text-left px-4 py-2 text-gray-700 font-semibold">Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr
            v-for="request in filteredRequests"
            :key="request.id"
            class="hover:bg-teal-50 text-teal-700"
          >
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ getPermissionTypeName(request.permission_type_id) }}
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">
              <button @click="openReasonPopup(request.reason)" class="text-blue-600 hover:underline">
                View Reason
              </button>
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ request.date_leave || 'N/A' }}
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ formatTimeOfDay(request.leave_morning, request.leave_afternoon) }}
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ request.date_back || 'N/A' }}
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ formatTimeOfDay(request.back_morning, request.back_afternoon) }}
            </td>
            <td class="px-4 py-2">
              <span
                :class="[
                  'inline-block px-3 py-1 rounded-full text-xs font-medium',
                  {
                    'bg-green-100 text-green-700': request.status === 'approved',
                    'bg-yellow-100 text-yellow-700': request.status === 'pending',
                    'bg-red-100 text-red-700': request.status === 'rejected',
                  },
                ]"
              >
                {{ request.status ? request.status.charAt(0).toUpperCase() + request.status.slice(1) : 'N/A' }}
              </span>
            </td>
          </tr>
          <tr v-if="filteredRequests.length === 0">
            <td colspan="7" class="text-center text-gray-500 py-4">
              No matching records
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Reason View Popup -->
    <div v-if="showReasonPopup" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg max-w-md w-full p-6 relative">
        <h3 class="text-xl font-semibold mb-4">Reason Details</h3>
        <p class="mb-4 text-gray-700">{{ currentReason || 'N/A' }}</p>
        <div class="flex justify-end">
          <button @click="closeReasonPopup" class="px-4 py-2 border rounded hover:bg-gray-100">
            Close
          </button>
        </div>
        <button @click="closeReasonPopup"
          class="absolute top-2 right-2 text-gray-600 hover:text-gray-900 text-2xl font-bold leading-none"
          aria-label="Close reason popup">
          ×
        </button>
      </div>
    </div>
  </div>
</template>

<style scoped>
table {
  width: 100%;
  border-collapse: collapse;
}

select:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(45, 212, 191, 0.3);
}
</style>