<template>
  <div class="p-6">
    <h2 class="text-2xl font-semibold mb-4 text-gray-800">Permission Requests</h2>

    <!-- Filters -->
    <div class="mb-6 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
      <!-- Search by Reason -->
      <div class="w-full sm:w-1/2">
        <label class="block mb-1 font-medium text-gray-700">Search by Reason:</label>
        <input v-model="searchQuery" type="text" placeholder="Type to search..."
          class="w-full border border-gray-300 rounded px-3 py-2 shadow-sm focus:outline-none focus:ring focus:ring-blue-300" />
      </div>


      <!-- Filter by Status -->
      <div>
        <label class="block mb-1 font-medium text-gray-700">Filter by Status:</label>
        <select v-model="selectedStatus"
          class="w-48 border border-gray-300 rounded px-3 py-2 shadow-sm focus:outline-none focus:ring focus:ring-blue-300">
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
                <Pencil class="w-5 h-5" />
              </button>

              <!-- Delete Icon -->
              <button @click="deleteRequest(permissionRequest.id)" class="text-red-500 hover:text-red-700 transition"
                aria-label="Delete">
                <Trash2 class="w-5 h-5" />
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
      <div class="p-6 relative">



        <!-- Slide-in Popup -->
        <transition name="slide">
          <div v-if="showCreatePopup"
            class="fixed top-0 right-0 w-full max-w-md h-full bg-white shadow-lg p-6 overflow-auto z-50">
            <h3 class="text-xl font-semibold mb-4">New Permission Request</h3>

            <form @submit.prevent="createRequest">
              <label class="block mb-1 font-medium">User ID</label>
              <input v-model="newRequest.user_id" type="number" required class="w-full mb-3 px-3 py-2 border rounded" />

              <label class="block mb-1 font-medium">Permission Type ID</label>
              <input v-model="newRequest.permission_type_id" type="number" required
                class="w-full mb-3 px-3 py-2 border rounded" />

              <label class="block mb-1 font-medium">Reason</label>
              <textarea v-model="newRequest.reason" class="w-full mb-3 px-3 py-2 border rounded" rows="3"></textarea>

              <label class="block mb-1 font-medium">Status</label>
              <select v-model="newRequest.status" class="w-full mb-3 px-3 py-2 border rounded" required>
                <option value="pending">Pending</option>
                <option value="approved">Approved</option>
                <option value="rejected">Rejected</option>
              </select>

              <div class="flex justify-between">
                <button type="submit"
                  class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700 transition">Create</button>
                <button type="button" @click="showCreatePopup = false"
                  class="bg-gray-400 text-white px-4 py-2 rounded hover:bg-gray-500 transition">Cancel</button>
              </div>
            </form>
          </div>
        </transition>
      </div>
    </div>
  </div>

</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import api from '@/plugin/axios.js'
import { Pencil, Trash2 } from 'lucide-vue-next'




const permissionRequests = ref([])
const selectedStatus = ref('')
const searchQuery = ref('')
const loading = ref(true)
const error = ref(null)

//create
const showCreatePopup = ref(false)
const newRequest = ref({
  user_id: '',
  permission_type_id: '',
  reason: '',
  status: 'pending'
})

const createRequest = async () => {
  try {
    const response = await api.post('/permissionrequests', newRequest.value)
    alert('Created successfully!')
    // Optional: update local data list here or reload page
    showCreatePopup.value = false
    // reset form
    newRequest.value = { user_id: '', permission_type_id: '', reason: '', status: 'pending' }
  } catch (error) {
    console.error('Create failed:', error)
    alert('Failed to create permission request.')
  }
}


onMounted(async () => {
  try {
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
    const updatedData = { ...request, status: newStatus };
    const response = await api.put(`/permissionrequests/${request.id}`, updatedData);
    // Update local data with fresh response
    const index = permissionRequests.value.findIndex(req => req.id === request.id);
    if (index !== -1) {
      permissionRequests.value[index] = response.data.data; // Assuming API returns updated object in `data`
    }
    alert('Updated successfully!');
  } catch (error) {
    console.error('Update failed:', error);
    alert('Failed to update request.');
  }
}


const deleteRequest = async (id) => {
  if (!confirm('Are you sure you want to delete this request?')) return;

  try {
    await api.delete(`/permissionrequests/${id}`);
    // Remove from local list to update UI instantly
    permissionRequests.value = permissionRequests.value.filter(req => req.id !== id);
    alert('Deleted successfully!');
  } catch (error) {
    console.error('Delete failed:', error);
    alert('Failed to delete request.');
  }
}

</script>
