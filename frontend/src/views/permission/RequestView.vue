<template>
  <div class="p-6">
    <h2 class="text-2xl font-semibold mb-4 text-gray-800">Permission Requests</h2>

    <!-- Filters -->
    <div class="mb-6 flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
      <!-- Search -->
      <div class="flex-1">
        <label class="block mb-1 font-medium text-gray-700">Search by Reason:</label>
        <div class="relative w-full">
          <input v-model="searchQuery" type="text" placeholder="Search for permission . . ."
            class="w-full border border-gray-300 rounded-full pl-4 pr-10 py-2 shadow-sm focus:outline-none focus:ring focus:ring-blue-300" />
          <button v-if="searchQuery" @click="searchQuery = ''"
            class="absolute inset-y-0 right-3 flex items-center text-gray-500 hover:text-gray-700"
            aria-label="Clear search">
            ✕
          </button>
        </div>
      </div>

      <!-- Create Button -->
      <div class="sm:mb-0">
        <label class="block mb-1 opacity-0">Button spacer</label>
        <button @click="openCreatePopup()"
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 w-full sm:w-auto">
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
                    : 'bg-red-100 text-red-700',
              ]">
                {{ permissionRequest.status }}
              </span>
            </td>
            <td class="px-4 py-3">{{ formatDate(permissionRequest.created_at) }}</td>
            <td class="relative px-4 py-3 text-left">
              <button @click="toggleActionMenu(permissionRequest.id)"
                class="p-1 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                :aria-expanded="actionMenuOpenId === permissionRequest.id ? 'true' : 'false'" aria-haspopup="true"
                aria-label="Open actions menu">
                <!-- Three dots icon -->
                <svg class="w-5 h-5 text-gray-700" fill="currentColor" viewBox="0 0 20 20">
                  <circle cx="10" cy="4" r="1.5" />
                  <circle cx="10" cy="10" r="1.5" />
                  <circle cx="10" cy="16" r="1.5" />
                </svg>
              </button>

              <!-- Dropdown Menu -->
              <transition name="fade">
                <div v-if="actionMenuOpenId === permissionRequest.id"
                  class="absolute right-0 mt-2 w-32 bg-white border border-gray-200 rounded-md shadow-lg z-50">
                  <button @click="() => { openEditPopup(permissionRequest); closeActionMenu(); }"
                    class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100">
                    Edit
                  </button>
                  <button @click="() => { showDeleteConfirm = permissionRequest.id; closeActionMenu(); }"
                    class="block w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100">
                    Delete
                  </button>
                </div>
              </transition>
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

    <!-- Create / Edit Popup -->
    <div v-if="showPopup" class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg max-w-md w-full p-6 relative">
        <h3 class="text-xl font-semibold mb-4">
          {{ isEditing ? 'Edit Permission Request' : 'Create Permission Request' }}
        </h3>

        <form @submit.prevent="isEditing ? updateRequest() : createRequest()">
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="user_id">User ID</label>
            <input id="user_id" v-model="form.user_id" type="text" required class="w-full border rounded px-3 py-2" />
          </div>
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="permission_type_id">Permission Type ID</label>
            <input id="permission_type_id" v-model="form.permission_type_id" type="text" required
              class="w-full border rounded px-3 py-2" />
          </div>
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="reason">Reason</label>
            <textarea id="reason" v-model="form.reason" required class="w-full border rounded px-3 py-2"></textarea>
          </div>
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="status">Status</label>
            <select id="status" v-model="form.status" required class="w-full border rounded px-3 py-2">
              <option value="pending">Pending</option>
              <option value="approved">Approved</option>
              <option value="rejected">Rejected</option>
            </select>
          </div>

          <div class="flex justify-end gap-4">
            <button type="button" @click="closePopup" class="px-4 py-2 border rounded hover:bg-gray-100">
              Cancel
            </button>
            <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">
              {{ isEditing ? 'Update' : 'Create' }}
            </button>
          </div>
        </form>

        <button @click="closePopup"
          class="absolute top-2 right-2 text-gray-600 hover:text-gray-900 text-2xl font-bold leading-none"
          aria-label="Close popup">
          ×
        </button>
      </div>
    </div>

    <!-- Delete Confirm Modal -->
    <div v-if="showDeleteConfirm !== null"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg max-w-sm w-full p-6 text-center">
        <p class="mb-6 text-lg">Are you sure you want to delete this request?</p>
        <div class="flex justify-center gap-4">
          <button @click="showDeleteConfirm = null" class="px-4 py-2 border rounded hover:bg-gray-100">
            Cancel
          </button>
          <button @click="deleteRequest(showDeleteConfirm)"
            class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700">
            Delete
          </button>
        </div>
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

const actionMenuOpenId = ref(null)
const showPopup = ref(false)
const isEditing = ref(false)
const form = ref({
  id: null,
  user_id: '',
  permission_type_id: '',
  reason: '',
  status: 'pending',
})

const showDeleteConfirm = ref(null)

const toast = ref({
  visible: false,
  message: '',
  type: 'success', // or 'error'
})

function showToast(message, type = 'success') {
  toast.value.message = message
  toast.value.type = type
  toast.value.visible = true
  setTimeout(() => {
    toast.value.visible = false
  }, 2000)
}

async function fetchRequests() {
  loading.value = true
  error.value = null
  try {
    const res = await api.get('/permissionrequests')
    permissionRequests.value = res.data
  } catch (err) {
    error.value = 'Failed to load permission requests.'
    showToast(error.value, 'error')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRequests()
})

const filteredPermissions = computed(() => {
  return permissionRequests.value.filter(p => {
    const statusMatch = !selectedStatus.value || p.status === selectedStatus.value
    const reasonMatch = !searchQuery.value || (p.reason?.toLowerCase() || '').includes(searchQuery.value.toLowerCase())
    return statusMatch && reasonMatch
  })
})

function formatDate(dateString) {
  return new Date(dateString).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' })
}

function toggleActionMenu(id) {
  actionMenuOpenId.value = actionMenuOpenId.value === id ? null : id
}

function closeActionMenu() {
  actionMenuOpenId.value = null
}

function openCreatePopup() {
  resetForm()
  isEditing.value = false
  showPopup.value = true
}

function openEditPopup(request) {
  form.value = { ...request }
  isEditing.value = true
  showPopup.value = true
}

function closePopup() {
  showPopup.value = false
  resetForm()
}

function resetForm() {
  form.value = {
    id: null,
    user_id: '',
    permission_type_id: '',
    reason: '',
    status: 'pending',
  }
}

async function createRequest() {
  try {
    await api.post('/permissionrequests', {
      user_id: form.value.user_id,
      permission_type_id: form.value.permission_type_id,
      reason: form.value.reason,
      status: form.value.status,
    })
    showToast('Created successfully!', 'success')
    showPopup.value = false
    fetchRequests()
  } catch (error) {
    showToast('Failed to create request.', 'error')
  }
}

async function updateRequest() {
  try {
    await api.put(`/permissionrequests/${form.value.id}`, {
      user_id: form.value.user_id,
      permission_type_id: form.value.permission_type_id,
      reason: form.value.reason,
      status: form.value.status,
    })
    showToast('Updated successfully!', 'success')
    showPopup.value = false
    fetchRequests()
  } catch (error) {
    showToast('Failed to update request.', 'error')
  }
}

function confirmDelete(id) {
  showDeleteConfirm.value = id
  closeActionMenu()
}

async function deleteRequest(id) {
  try {
    await api.delete(`/permissionrequests/${id}`)
    permissionRequests.value = permissionRequests.value.filter(r => r.id !== id)
    showDeleteConfirm.value = null
    showToast('Deleted successfully!', 'success')
  } catch (error) {
    showToast('Failed to delete request.', 'error')
  }
}
</script>

<style>
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

.toast-fade-enter-from {
  opacity: 0;
  transform: translateY(10px);
}

.toast-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>
