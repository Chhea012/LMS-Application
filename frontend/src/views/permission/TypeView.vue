<template>
  <div class="p-6">
    <!-- Header & Create Button -->
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="text-2xl font-bold text-gray-800">Permission Types</h1>
        <p class="text-gray-600">Manage permission types here.</p>
      </div>
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        @click="showAddModal = true"
      >
        + Create
      </button>
    </div>

    <!-- Add Modal -->
    <transition name="fade">
      <div
        v-if="showAddModal"
        class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50"
        @click.self="showAddModal = false"
      >
        <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-lg mx-4" @click.stop>
          <h2 class="text-lg font-semibold text-gray-700 mb-3">Add Permission Type</h2>
          <form @submit.prevent="addPermissionType" class="space-y-4">
            <div>
              <label class="block text-sm text-gray-600 mb-1">Name</label>
              <input v-model="newPermissionType.name" type="text" class="w-full border rounded px-3 py-2 focus:outline-none focus:ring" required />
            </div>
            <div>
              <label class="block text-sm text-gray-600 mb-1">Description</label>
              <textarea v-model="newPermissionType.description" class="w-full border rounded px-3 py-2 focus:outline-none focus:ring" required></textarea>
            </div>
            <div class="flex justify-end space-x-2">
              <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700" :disabled="isLoading">Create</button>
              <button type="button" class="bg-gray-300 text-gray-800 px-4 py-2 rounded hover:bg-gray-400" @click="showAddModal = false">Cancel</button>
            </div>
            <p v-if="error" class="text-red-600 mt-2">{{ error }}</p>
          </form>
        </div>
      </div>
    </transition>

    <!-- Edit Modal -->
    <transition name="fade">
      <div
        v-if="showEditModal"
        class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50"
        @click.self="showEditModal = false"
      >
        <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-lg mx-4" @click.stop>
          <h2 class="text-lg font-semibold text-gray-700 mb-3">Edit Permission Type</h2>
          <form @submit.prevent="updatePermissionType" class="space-y-4">
            <div>
              <label class="block text-sm text-gray-600 mb-1">Name</label>
              <input v-model="editPermissionType.name" type="text" class="w-full border rounded px-3 py-2 focus:outline-none focus:ring" required />
            </div>
            <div>
              <label class="block text-sm text-gray-600 mb-1">Description</label>
              <textarea v-model="editPermissionType.description" class="w-full border rounded px-3 py-2 focus:outline-none focus:ring" required></textarea>
            </div>
            <div class="flex justify-end space-x-2">
              <button type="submit" class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700" :disabled="isLoading">Update</button>
              <button type="button" class="bg-gray-300 text-gray-800 px-4 py-2 rounded hover:bg-gray-400" @click="showEditModal = false">Cancel</button>
            </div>
            <p v-if="error" class="text-red-600 mt-2">{{ error }}</p>
          </form>
        </div>
      </div>
    </transition>

    <!-- Delete Confirm -->
    <transition name="fade">
      <div
        v-if="showDeleteConfirm !== null"
        class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50"
        @click.self="showDeleteConfirm = null"
      >
        <div class="bg-white rounded-lg shadow-lg p-6 w-full max-w-sm mx-4" @click.stop>
          <h3 class="text-lg font-semibold mb-4 text-gray-700">Confirm Delete</h3>
          <p class="mb-6">Are you sure you want to delete this permission type?</p>
          <div class="flex justify-end space-x-4">
            <button @click="confirmDelete" class="bg-red-600 text-white px-4 py-2 rounded hover:bg-red-700" :disabled="isLoading">Delete</button>
            <button @click="showDeleteConfirm = null" class="bg-gray-300 text-gray-800 px-4 py-2 rounded hover:bg-gray-400">Cancel</button>
          </div>
          <p v-if="error" class="text-red-600 mt-2">{{ error }}</p>
        </div>
      </div>
    </transition>

    <!-- Table List -->
    <div class="bg-white border rounded-lg shadow">
      <table class="w-full text-left border-collapse">
        <thead class="bg-gray-100 text-gray-600 text-sm uppercase">
          <tr>
            <th class="p-3 border-b">#</th>
            <th class="p-3 border-b">Name</th>
            <th class="p-3 border-b">Description</th>
            <th class="p-3 border-b">Created At</th>
            <th class="p-3 border-b">Updated At</th>
            <th class="p-3 border-b">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-if="permissionTypes.length === 0">
            <td colspan="5" class="text-center text-gray-400 py-4">No permission types available.</td>
          </tr>
          <tr v-for="(type, index) in permissionTypes" :key="type.id" class="hover:bg-gray-50">
            <td class="p-3 border-b">{{ index + 1 }}</td>
            <td class="p-3 border-b">{{ type.name }}</td>
            <td class="p-3 border-b">{{ type.description }}</td>
            <td class="p-3 border-b">{{ type.created_at }}</td>
            <td class="p-3 border-b">{{ type.updated_at }}</td>
            <td class="p-3 border-b relative" @click.stop>
  <!-- Three dots button -->
  <button
    @click="toggleActionMenu(type.id)"
    class="p-1 rounded hover:bg-gray-200 focus:outline-none focus:ring-2 focus:ring-blue-400"
    aria-haspopup="true"
    :aria-expanded="actionMenuOpenId === type.id ? 'true' : 'false'"
    aria-label="Open actions menu"
  >
    <!-- Vertical three dots icon -->
    <svg
      class="w-6 h-6 text-gray-600"
      fill="currentColor"
      viewBox="0 0 20 20"
      xmlns="http://www.w3.org/2000/svg"
    >
      <circle cx="10" cy="4" r="2" />
      <circle cx="10" cy="10" r="2" />
      <circle cx="10" cy="16" r="2" />
    </svg>
  </button>

  <!-- Dropdown menu -->
  <transition name="fade">
    <div
      v-if="actionMenuOpenId === type.id"
      class="absolute right-0 mt-2 w-28 bg-white border border-gray-200 rounded shadow-md z-50"
    >
      <button
        @click="() => { openEditModal(type); closeActionMenu(); }"
        class="block w-full text-left px-4 py-2 hover:bg-gray-100 text-gray-700 text-sm"
        type="button"
      >
        Edit
      </button>
      <button
        @click="() => { showDeleteConfirm = type.id; closeActionMenu(); }"
        class="block w-full text-left px-4 py-2 hover:bg-gray-100 text-red-600 text-sm"
        type="button"
      >
        Delete
      </button>
    </div>
  </transition>
</td>

          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import api from '@/plugin/axios'

const permissionTypes = ref([])
const newPermissionType = ref({ name: '', description: '' })
const editPermissionType = ref({ id: null, name: '', description: '' })

const showAddModal = ref(false)
const showEditModal = ref(false)
const showDeleteConfirm = ref(null)
const isLoading = ref(false)
const error = ref(null)


const actionMenuOpenId = ref(null)

function toggleActionMenu(id) {
  actionMenuOpenId.value = actionMenuOpenId.value === id ? null : id
}

function closeActionMenu() {
  actionMenuOpenId.value = null
}

document.addEventListener('click', () => {
  closeActionMenu()
})

const fetchPermissionTypes = async () => {
  try {
    isLoading.value = true
    const res = await api.get('/permissiontypes')
    console.log('Fetched data:', res.data.data)

    permissionTypes.value = Array.isArray(res.data.data)
      ? res.data.data
      : res.data.data ?? []

  } catch (err) {
    error.value = 'Failed to load permission types'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

// Add new
const addPermissionType = async () => {
  try {
    isLoading.value = true
    const res = await api.post('/permissiontypes', newPermissionType.value)
    permissionTypes.value.push(res.data.data ?? res.data.data)
    newPermissionType.value = { name: '', description: '' }
    showAddModal.value = false
  } catch (err) {
    error.value = 'Failed to add permission type'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

// Open edit
const openEditModal = (type) => {
  editPermissionType.value = { ...type }
  showEditModal.value = true
}

// Update
const updatePermissionType = async () => {
  try {
    isLoading.value = true
    const res = await api.put(`/permissiontypes/${editPermissionType.value.id}`, editPermissionType.value)
    const index = permissionTypes.value.findIndex(t => t.id === editPermissionType.value.id)
    if (index !== -1) permissionTypes.value[index] = res.data.data ?? res.data.data
    showEditModal.value = false
  } catch (err) {
    error.value = 'Failed to update permission type'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

// Delete
const confirmDelete = async () => {
  try {
    isLoading.value = true
    await api.delete(`/permissiontypes/${showDeleteConfirm.value}`)
    permissionTypes.value = permissionTypes.value.filter(t => t.id !== showDeleteConfirm.value)
    showDeleteConfirm.value = null
  } catch (err) {
    error.value = 'Failed to delete permission type'
    console.error(err)
  } finally {
    isLoading.value = false
  }
}

onMounted(fetchPermissionTypes)
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
