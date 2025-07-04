<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <!-- Page Header -->
    <header class="mb-6 flex items-center justify-between">
      <h1 class="text-3xl font-bold text-gray-900">User Management</h1>
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition"
        @click="addUser"
      >
        + Add User
      </button>
    </header>

    <!-- Description -->
    <p class="text-gray-700 mb-8">
      Manage all users in the system. You can add, update, or delete users as needed.
    </p>

    <!-- Users Table or Empty State -->
    <div class="bg-white shadow rounded-lg border border-gray-200">
      <table v-if="users.length" class="w-full text-left">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-6 py-3 font-medium text-gray-700">Name</th>
            <th class="px-6 py-3 font-medium text-gray-700">Email</th>
            <th class="px-6 py-3 font-medium text-gray-700">Role</th>
            <th class="px-6 py-3 font-medium text-gray-700">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id" class="border-t">
            <td class="px-6 py-4">{{ user.name }}</td>
            <td class="px-6 py-4">{{ user.email }}</td>
            <td class="px-6 py-4">{{ user.role }}</td>
            <td class="px-6 py-4 space-x-2">
              <button
                class="text-blue-600 hover:underline"
                @click="editUser(user.id)"
              >
                Edit
              </button>
              <button
                class="text-red-600 hover:underline"
                @click="deleteUser(user.id)"
              >
                Delete
              </button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Empty State -->
      <div
        v-else
        class="flex flex-col items-center justify-center py-20 text-gray-400"
      >
        <svg
          class="h-16 w-16 mb-4"
          fill="none"
          stroke="currentColor"
          stroke-width="1.5"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M12 11c0 1.104-.896 2-2 2s-2-.896-2-2 .896-2 2-2 2 .896 2 2zm4 0c0 1.104-.896 2-2 2s-2-.896-2-2 .896-2 2-2 2 .896 2 2z"
          />
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M4.5 21h15M4.5 18v3m15-3v3"
          />
        </svg>
        <p class="text-lg">No users found.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'

const users = ref([
  { id: 1, name: 'Sophean Phouk', email: 'sophean@example.com', role: 'Product Owner' },
  { id: 2, name: 'Vannak Chea', email: 'vannak@example.com', role: 'Manager' },
  { id: 3, name: 'Rina Chan', email: 'rina@example.com', role: 'Employee' },
])

function addUser() {
  alert('Add user clicked!')
}
function editUser(id) {
  alert(`Edit user ${id}`)
}
function deleteUser(id) {
  alert(`Delete user ${id}`)
}
</script>
