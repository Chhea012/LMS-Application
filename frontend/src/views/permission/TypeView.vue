<template>
  <div class="p-6">
    <!-- Header & Create Button -->
    <div class="flex justify-between items-center mb-6">
      <div>
        <h1 class="text-2xl font-bold text-gray-800">Permission Types</h1>
        <p class="text-gray-600">Manage permission types here.</p>
      </div>
      <button
        class="bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700"
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
            <td class="p-3 border-b space-x-2">
              <button @click="openEditModal(type)" class="text-blue-600 hover:underline">Edit</button>
              <button @click="showDeleteConfirm = type.id" class="text-red-600 hover:underline">Delete</button>
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

// Load all permission types
const fetchPermissionTypes = async () => {
  try {
    isLoading.value = true
    const res = await api.get('/v1/permissiontypes')
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
    const res = await api.post('/v1/permissiontypes', newPermissionType.value)
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
    const res = await api.put(`/v1/permissiontypes/${editPermissionType.value.id}`, editPermissionType.value)
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
    await api.delete(`/v1/permissiontypes/${showDeleteConfirm.value}`)
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
