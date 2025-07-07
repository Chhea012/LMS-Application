<script setup>
import { ref, onMounted, computed } from 'vue'
import api from '@/plugin/axios.js'

const permissionRequests = ref([])
const selectedStatus = ref('')
const searchQuery = ref('')
const loading = ref(false)
const error = ref(null)
const departments = ref([
  { id: 1, name: 'Developer' },
  { id: 2, name: 'HR' },
  { id: 5, name: 'Marketing' },
  { id: 6, name: 'Finance' },
])
const managers = ref([])
const permissionTypes = ref([
  { id: 1, name: 'Sick Leave' },
  { id: 2, name: 'Vacation' },
  { id: 3, name: 'Personal Leave' },
])
const actionMenuOpenId = ref(null)
const showPopup = ref(false)
const isEditing = ref(false)
const form = ref({
  id: null,
  department_id: '',
  manager_id: '',
  permission_type_id: '',
  reason: '',
  status: 'pending',
})
const showDeleteConfirm = ref(null)
const toast = ref({
  visible: false,
  message: '',
  type: 'success',
})
// Mocked user (Ryna, employee). Replace with auth context (e.g., store.getters.currentUser).
const currentUser = ref({ id: 9, full_name: 'Ryna', role_id: 4, department_id: 2 })

function showToast(message, type = 'success') {
  toast.value.message = message
  toast.value.type = type
  toast.value.visible = true
  setTimeout(() => {
    toast.value.visible = false
  }, 3000)
}

async function fetchDepartments() {
  loading.value = true
  try {
    const res = await api.get('/departments')
    const data = res.data.data || res.data
    if (Array.isArray(data)) {
      departments.value = data
    } else {
      throw new Error('Invalid departments data format')
    }
  } catch (err) {
    console.error('Error fetching departments:', err.message, err.response?.data)
    showToast('Failed to load departments, using fallback data.', 'error')
  } finally {
    loading.value = false
  }
}

async function fetchManagersByDepartment() {
  loading.value = true
  try {
    const deptId = form.value.department_id
    if (!deptId) {
      managers.value = []
      return
    }
    const res = await api.get('/users')
    const users = res.data.users || res.data
    if (Array.isArray(users)) {
      managers.value = users.filter(user =>
        (user.role_id === 1 || user.role_id === 3) && user.department_id === parseInt(deptId)
      )
    } else {
      throw new Error('Invalid users data format')
    }
  } catch (err) {
    console.error('Error fetching managers:', err.message, err.response?.data)
    showToast('Failed to load managers.', 'error')
    managers.value = []
  } finally {
    loading.value = false
  }
}

async function fetchPermissionTypes() {
  loading.value = true
  try {
    const res = await api.get('/permissiontypes')
    const data = res.data.data || res.data
    if (Array.isArray(data)) {
      permissionTypes.value = data
    } else {
      throw new Error('Invalid permission types data format')
    }
  } catch (err) {
    console.error('Error fetching permission types:', err.message, err.response?.data)
    showToast('Failed to load permission types, using fallback data.', 'error')
  } finally {
    loading.value = false
  }
}

async function fetchRequests() {
  loading.value = true
  error.value = null
  try {
    const res = await api.get('/permissionrequests')
    const data = res.data.data || res.data
    if (Array.isArray(data)) {
      permissionRequests.value = data
    } else {
      throw new Error('Invalid permission requests data format')
    }
  } catch (err) {
    console.error('Error fetching requests:', err.message, err.response?.data)
    error.value = 'Failed to load permission requests.'
    showToast(error.value, 'error')
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  fetchRequests()
  fetchDepartments()
  fetchPermissionTypes()
})

const filteredPermissions = computed(() => {
  return permissionRequests.value.filter(p => {
    const statusMatch = !selectedStatus.value || p.status === selectedStatus.value
    const reasonMatch = !searchQuery.value || (p.reason?.toLowerCase() || '').includes(searchQuery.value.toLowerCase())
    return statusMatch && reasonMatch
  })
})

function formatDate(dateString) {
  return dateString ? new Date(dateString).toLocaleDateString(undefined, { year: 'numeric', month: 'short', day: 'numeric' }) : 'N/A'
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
  form.value.department_id = currentUser.value.department_id.toString()
  fetchManagersByDepartment()
}

function openEditPopup(request) {
  form.value = {
    id: request.id,
    department_id: request.department_id?.toString() || '',
    manager_id: request.manager_id?.toString() || '',
    permission_type_id: request.permission_type_id?.toString() || '',
    reason: request.reason || '',
    status: request.status || 'pending',
  }
  isEditing.value = true
  showPopup.value = true
  fetchManagersByDepartment()
}

function closePopup() {
  showPopup.value = false
  resetForm()
}

function resetForm() {
  form.value = {
    id: null,
    department_id: '',
    manager_id: '',
    permission_type_id: '',
    reason: '',
    status: 'pending',
  }
  managers.value = []
}

async function createRequest() {
  if (managers.value.length === 0) {
    showToast('No managers available for the selected department.', 'error')
    return
  }
  if (form.value.reason.length > 500) {
    showToast('Reason cannot exceed 500 characters.', 'error')
    return
  }
  loading.value = true
  try {
    const response = await api.post('/permissionrequests', {
      user_id: currentUser.value.id,
      department_id: parseInt(form.value.department_id),
      manager_id: parseInt(form.value.manager_id),
      permission_type_id: parseInt(form.value.permission_type_id),
      reason: form.value.reason,
      status: form.value.status,
    })
    await api.post('/notifications', {
      permission_request_id: response.data.id,
      recipient_id: parseInt(form.value.manager_id),
      message: `New permission request from ${currentUser.value.full_name}: ${form.value.reason}`,
      status: 'unread',
    })
    showToast('Request created successfully!', 'success')
    showPopup.value = false
    fetchRequests()
  } catch (error) {
    console.error('Error creating request:', error.message, error.response?.data)
    showToast('Failed to create request: ' + (error.response?.data?.message || 'Unknown error'), 'error')
  } finally {
    loading.value = false
  }
}

async function updateRequest() {
  if (managers.value.length === 0) {
    showToast('No managers available for the selected department.', 'error')
    return
  }
  if (form.value.reason.length > 500) {
    showToast('Reason cannot exceed 500 characters.', 'error')
    return
  }
  loading.value = true
  try {
    await api.put(`/permissionrequests/${form.value.id}`, {
      department_id: parseInt(form.value.department_id),
      manager_id: parseInt(form.value.manager_id),
      permission_type_id: parseInt(form.value.permission_type_id),
      reason: form.value.reason,
      status: form.value.status,
    })
    showToast('Request updated successfully!', 'success')
    showPopup.value = false
    fetchRequests()
  } catch (error) {
    console.error('Error updating request:', error.message, error.response?.data)
    showToast('Failed to update request: ' + (error.response?.data?.message || 'Unknown error'), 'error')
  } finally {
    loading.value = false
  }
}

async function deleteRequest(id) {
  loading.value = true
  try {
    await api.delete(`/permissionrequests/${id}`)
    permissionRequests.value = permissionRequests.value.filter(r => r.id !== id)
    showDeleteConfirm.value = null
    showToast('Request deleted successfully!', 'success')
    fetchRequests()
  } catch (error) {
    console.error('Error deleting request:', error.message, error.response?.data)
    showToast('Failed to delete request: ' + (error.response?.data?.message || 'Unknown error'), 'error')
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="p-6">
    <h2 class="text-2xl font-semibold mb-4 text-gray-800">Permission Requests</h2>

    <!-- Filters -->
    <div class="mb-6 flex flex-col sm:flex-row sm:items-end sm:justify-between gap-4">
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
      <div class="sm:mb-0">
        <label class="block mb-1 opacity-0">Button spacer</label>
        <button @click="openCreatePopup()" :disabled="loading"
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 w-full sm:w-auto disabled:bg-blue-300">
          Create New Request
        </button>
      </div>
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
            <th class="px-4 py-3 text-left">User Name</th>
            <th class="px-4 py-3 text-left">Permission Type</th>
            <th class="px-4 py-3 text-left">Reason</th>
            <th class="px-4 py-3 text-left">Department</th>
            <th class="px-4 py-3 text-left">Manager</th>
            <th class="px-4 py-3 text-left">Status</th>
            <th class="px-4 py-3 text-left">Created At</th>
            <th class="px-4 py-3 text-left">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="loading">
            <td colspan="9" class="px-4 py-6 text-center text-gray-500">Loading...</td>
          </tr>
          <tr v-else-if="filteredPermissions.length === 0">
            <td colspan="9" class="px-4 py-6 text-center text-gray-500">
              No records match your search or filter.
            </td>
          </tr>
          <tr v-else v-for="permissionRequest in filteredPermissions" :key="permissionRequest.id"
            class="border-t hover:bg-gray-100 transition duration-200">
            <td class="px-4 py-3">{{ permissionRequest.id }}</td>
            <td class="px-4 py-3">{{ permissionRequest.user?.full_name || 'Unknown' }}</td>
            <td class="px-4 py-3">{{ permissionRequest.permission_type?.name || 'N/A' }}</td>
            <td class="px-4 py-3">{{ permissionRequest.reason || 'N/A' }}</td>
            <td class="px-4 py-3">{{ permissionRequest.department?.name || 'N/A' }}</td>
            <td class="px-4 py-3">{{ permissionRequest.manager?.full_name || 'N/A' }}</td>
            <td class="px-4 py-3">
              <span :class="[
                'px-3 py-1 rounded-full text-xs font-medium',
                permissionRequest.status === 'approved' ? 'bg-green-100 text-green-700' :
                permissionRequest.status === 'pending' ? 'bg-yellow-100 text-yellow-800' :
                'bg-red-100 text-red-700',
              ]">
                {{ permissionRequest.status || 'Unknown' }}
              </span>
            </td>
            <td class="px-4 py-3">{{ formatDate(permissionRequest.created_at) }}</td>
            <td class="relative px-4 py-3 text-left">
              <button @click="toggleActionMenu(permissionRequest.id)"
                class="p-1 rounded-full focus:outline-none focus:ring-2 focus:ring-blue-500"
                :aria-expanded="actionMenuOpenId === permissionRequest.id ? 'true' : 'false'" aria-haspopup="true"
                aria-label="Open actions menu">
                <svg class="w-5 h-5 text-gray-700" fill="currentColor" viewBox="0 0 20 20">
                  <circle cx="10" cy="4" r="1.5" />
                  <circle cx="10" cy="10" r="1.5" />
                  <circle cx="10" cy="16" r="1.5" />
                </svg>
              </button>
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
            <label class="block mb-1 font-medium" for="department_id">Department</label>
            <select id="department_id" v-model="form.department_id" required class="w-full border rounded px-3 py-2"
              @change="fetchManagersByDepartment" :disabled="loading">
              <option value="" disabled>Select Department</option>
              <option v-for="dept in departments" :key="dept.id" :value="dept.id">{{ dept.name }}</option>
            </select>
          </div>
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="manager_id">Manager</label>
            <select id="manager_id" v-model="form.manager_id" required class="w-full border rounded px-3 py-2"
              :disabled="!form.department_id || loading || managers.length === 0">
              <option value="" disabled>Select Manager</option>
              <option v-for="manager in managers" :key="manager.id" :value="manager.id">{{ manager.full_name }}</option>
            </select>
            <p v-if="form.department_id && managers.length === 0" class="text-sm text-red-600 mt-1">
              No managers available for this department.
            </p>
          </div>
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="permission_type_id">Permission Type</label>
            <select id="permission_type_id" v-model="form.permission_type_id" required class="w-full border rounded px-3 py-2"
              :disabled="loading">
              <option value="" disabled>Select Permission Type</option>
              <option v-for="type in permissionTypes" :key="type.id" :value="type.id">{{ type.name }}</option>
            </select>
          </div>
          <div class="mb-4">
            <label class="block mb-1 font-medium" for="reason">Reason</label>
            <textarea id="reason" v-model="form.reason" required class="w-full border rounded px-3 py-2"
              :disabled="loading" maxlength="500"></textarea>
            <p class="text-xs text-gray-500 mt-1">{{ form.reason.length || 0 }}/500 characters</p>
          </div>
          <div class="mb-4" v-if="isEditing && (currentUser.role_id === 1 || currentUser.role_id === 3)">
            <label class="block mb-1 font-medium" for="status">Status</label>
            <select id="status" v-model="form.status" required class="w-full border rounded px-3 py-2"
              :disabled="loading">
              <option value="pending">Pending</option>
              <option value="approved">Approved</option>
              <option value="rejected">Rejected</option>
            </select>
          </div>

          <div class="flex justify-end gap-4">
            <button type="button" @click="closePopup" :disabled="loading"
              class="px-4 py-2 border rounded hover:bg-gray-100 disabled:bg-gray-300">
              Cancel
            </button>
            <button type="submit" :disabled="loading || managers.length === 0"
              class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 disabled:bg-blue-300">
              {{ isEditing ? 'Update' : 'Create' }}
            </button>
          </div>
        </form>

        <button @click="closePopup" :disabled="loading"
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
          <button @click="showDeleteConfirm = null" :disabled="loading"
            class="px-4 py-2 border rounded hover:bg-gray-100 disabled:bg-gray-300">
            Cancel
          </button>
          <button @click="deleteRequest(showDeleteConfirm)" :disabled="loading"
            class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700 disabled:bg-red-300">
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

.toast-fade-enter-from,
.toast-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>