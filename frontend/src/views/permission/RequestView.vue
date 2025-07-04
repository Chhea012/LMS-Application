<template>
  <div class="p-6">
    <h2 class="text-2xl font-semibold mb-4 text-gray-800">Permission Requests</h2>

    <!-- Filters -->
    <div class="mb-6 flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">

      <!-- Search by Reason -->
      <div class="flex-1">
        <label class="block mb-1 font-medium text-gray-700">Search by Reason:</label>

        <div class="relative w-full">
          <!-- Search Icon (left) -->
          <span class="absolute inset-y-0 left-3 flex items-center text-gray-400 pointer-events-none">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                d="M21 21l-4.35-4.35M16.65 16.65A7 7 0 1110 3a7 7 0 016.65 13.65z" />
            </svg>
          </span>

          <!-- Input Field -->
          <input v-model="searchQuery" type="text" placeholder="Search for permission . . ."
            class="w-full border border-gray-300 rounded-full pl-10 pr-10 py-2 shadow-sm focus:outline-none focus:ring focus:ring-blue-300" />

          <!-- Clear (X) Button -->
          <button v-if="searchQuery" @click="searchQuery = ''"
            class="absolute inset-y-0 right-3 flex items-center text-gray-500 hover:text-gray-700"
            aria-label="Clear search">
            <svg xmlns="http://www.w3.org/2000/svg" class="w-5 h-5" fill="none" viewBox="0 0 24 24"
              stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12" />
            </svg>
          </button>
        </div>
      </div>


      <!-- Create Button -->
      <div class="sm:mb-0">
        <label class="block mb-1 opacity-0">Button spacer</label>
        <button @click="showCreatePopup = true"
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 flex items-center gap-2 w-full sm:w-auto">
          <PlusCircle class="w-5 h-5" />
          Create New Request
        </button>
      </div>

      <!-- Filter by Status -->
      <div class="w-full sm:w-auto">
        <label class="block mb-1 font-medium text-gray-700">Filter by Status:</label>
        <select v-model="selectedStatus"
          class="w-full sm:w-48 border border-gray-300 rounded px-3 py-2 shadow-sm focus:outline-none focus:ring focus:ring-blue-300">
          <option value="">All</option>
          <option value="approved">Approved</option>
          <option value="pending">Pending</option>
          <option value="rejected">Rejected</option>
        </select>
      </div>

    </div>


    <!-- Table -->
    <div class="overflow-x-auto">
      <table class="min-w-full bg-white rounded-lg shadow-md border text-sm">
        <thead class="bg-blue-100 text-blue-800 uppercase font-semibold">
          <tr>
            <th class="px-4 py-3 text-left">ID</th>
            <th class="px-4 py-3 text-left">User name</th>
            <th class="px-4 py-3 text-left">Permission Type</th>
            <th class="px-4 py-3 text-left">Reason</th>
            <th class="px-4 py-3 text-left">Status</th>
            <th class="px-4 py-3 text-left">Created At</th>
            <th class="px-4 py-3 text-left">Updated At</th>
            <th class="px-4 py-3 text-left">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="permissionRequest in filteredPermissions" :key="permissionRequest.id"
            class="border-t hover:bg-gray-100 transition duration-200">
            <td class="px-4 py-3">{{ permissionRequest.id }}</td>
            <td class="px-4 py-3">{{ permissionRequest.user.full_name }}</td>
            <td class="px-4 py-3">{{ permissionRequest.permission_type.name }}</td>
            <td class="px-4 py-3">{{ permissionRequest.reason }}</td>
            <td class="px-4 py-3">
              <span :class="[
                'px-3 py-1 rounded-full text-xs font-medium',
                permissionRequest.status === 'approved'
                  ? 'bg-green-100 text-green-700'
                  : permissionRequest.status === 'pending'
                    ? 'bg-yellow-100 text-yellow-800'
                    : 'bg-red-100 text-red-700'
              ]">
                {{ permissionRequest.status }}
              </span>
            </td>
            <td class="px-4 py-3">{{ formatDate(permissionRequest.created_at) }}</td>
            <td class="px-4 py-3">{{ formatDate(permissionRequest.updated_at) }}</td>
            <td class="px-4 py-3 flex items-center gap-3">
              <!-- Edit Icon -->
              <button @click="editRequest(permissionRequest)" class="text-blue-500 hover:text-blue-700 transition"
                aria-label="Edit">
                <i class="bx bx-edit w-5 h-5"></i>
              </button>

              <!-- Delete Icon -->
              <button @click="deleteRequest(permissionRequest.id)" class="text-red-500 hover:text-red-700 transition"
                aria-label="Delete">
                <i class="bx bx-trash w-5 h-5"></i>
              </button>
            </td>
          </tr>

          <tr v-if="filteredPermissions.length === 0">
            <td colspan="7" class="px-4 py-6 text-center text-gray-500">
              No records match your search or filter.
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>


 
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import api from '@/plugin/axios.js'

const permissionRequests = ref([])
const selectedStatus = ref('')
const searchQuery = ref('')
const loading = ref(true)
const error = ref(null)


///
const showCreatePopup = ref(false)

function createRequest() {
  // Handle form submission logic here (e.g. POST to API)
  console.log('Creating:', newRequest.value)

  // Reset form (optional)
  newRequest.value = {
    user_id: '',
    permission_type_id: '',
    reason: '',
    status: 'pending',
  }

  showCreatePopup.value = false
}

const newRequest = ref({
  user_id: '',
  permission_type_id: '',
  reason: '',
  status: 'pending',
})


//get from database
onMounted(async () => {
  try {
    // Load Boxicons CSS
    const link = document.createElement('link')
    link.rel = 'stylesheet'
    link.href = 'https://cdn.jsdelivr.net/npm/boxicons@latest/css/boxicons.min.css'
    document.head.appendChild(link)

    const response = await api.get('/permissionrequests')
    permissionRequests.value = response.data
  } catch (err) {
    console.error('❌ Failed to fetch data:', err)
    error.value = 'Could not load permission requests.'
  } finally {
    loading.value = false
  }
})

const filteredPermissions = computed(() => {
  return permissionRequests.value.filter((p) => {
    const statusMatch = !selectedStatus.value || p.status === selectedStatus.value
    const reasonMatch =
      !searchQuery.value || (p.reason?.toLowerCase() || '').includes(searchQuery.value.toLowerCase())
    return statusMatch && reasonMatch
  })
})

function formatDate(dateString) {
  return new Date(dateString).toLocaleString()
}

const editRequest = async (request, newStatus) => {
  try {
    const updatedData = { ...request, status: newStatus }
    const response = await api.put(`/permissionrequests/${request.id}`, updatedData)
    const index = permissionRequests.value.findIndex(req => req.id === request.id)
    if (index !== -1) {
      permissionRequests.value[index] = response.data.data
    }
    alert('Updated successfully!')
  } catch (error) {
    console.error('Update failed:', error)
    alert('Failed to update request.')
  }
}

const deleteRequest = async (id) => {
  if (!confirm('Are you sure you want to delete this request?')) return

  try {
    await api.delete(`/permissionrequests/${id}`)
    permissionRequests.value = permissionRequests.value.filter(req => req.id !== id)
    alert('Deleted successfully!')
  } catch (error) {
    console.error('Delete failed:', error)
    alert('Failed to delete request.')
  }
}
</script>