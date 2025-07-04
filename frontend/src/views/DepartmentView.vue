<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <!-- Page Header -->
    <header class="mb-6 flex items-center justify-between">
      <h1 class="text-3xl font-bold text-gray-900">Department Management</h1>
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition"
        @click="addDepartment"
      >
        + Add Department
      </button>
    </header>

    <!-- Description -->
    <p class="text-gray-700 mb-8">
      Manage your organization's departments here. Add, edit, or remove departments as needed.
    </p>

    <!-- Departments Table or Empty State -->
    <div class="bg-white shadow rounded-lg border border-gray-200">
      <table v-if="departments.length" class="w-full text-left">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-6 py-3 font-medium text-gray-700">Name</th>
            <th class="px-6 py-3 font-medium text-gray-700">Manager</th>
            <th class="px-6 py-3 font-medium text-gray-700">Employees</th>
            <th class="px-6 py-3 font-medium text-gray-700">Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="dept in departments" :key="dept.id" class="border-t">
            <td class="px-6 py-4">{{ dept.name }}</td>
            <td class="px-6 py-4">{{ dept.manager }}</td>
            <td class="px-6 py-4">{{ dept.employees }}</td>
            <td class="px-6 py-4 space-x-2">
              <button
                class="text-blue-600 hover:underline"
                @click="editDepartment(dept.id)"
              >
                Edit
              </button>
              <button
                class="text-red-600 hover:underline"
                @click="deleteDepartment(dept.id)"
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
            d="M9.75 3.75h4.5M12 3.75v4.5M4.5 21h15M4.5 18v3m15-3v3m-8.25-3V12h2.25v6"
          />
        </svg>
        <p class="text-lg">No departments available.</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref } from "vue";

// Your static data here:
const departments = ref([
  { id: 1, name: "Sales", manager: "Alice Johnson", employees: 12 },
  { id: 2, name: "Marketing", manager: "Bob Lee", employees: 8 },
  { id: 3, name: "Development", manager: "Charlie Kim", employees: 20 },
  { id: 4, name: "HR", manager: "Dana Smith", employees: 5 },
]);

function addDepartment() {
  alert("Add department clicked! You can implement a modal or page.");
}
function editDepartment(id) {
  alert(`Edit department ${id} clicked!`);
}
function deleteDepartment(id) {
  alert(`Delete department ${id} clicked!`);
}
</script>
