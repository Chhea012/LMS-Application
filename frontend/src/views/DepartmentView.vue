<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <header class="mb-6 flex items-center justify-between">
      <h1 class="text-3xl font-bold text-gray-900">Department Management</h1>
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
        @click="openCreateForm"
      >
        + Add Department
      </button>
    </header>

    <p class="text-gray-700 mb-4">List of departments and their heads.</p>

    <!-- Search input -->
    <!-- <div class="mb-4">
      <input
        type="text"
        v-model="searchQuery"
        placeholder="Search departments..."
        class="w-full px-3 py-2 border border-gray-300 rounded focus:outline-none focus:ring focus:border-blue-500"
      />
    </div> -->

    <div class="bg-white shadow rounded-lg border border-gray-200">
      <table v-if="filteredDepartments.length" class="w-full text-left">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-6 py-3 font-medium text-gray-700">Department Name</th>
            <th class="px-6 py-3 font-medium text-gray-700">
              Head of Department
            </th>
            <th class="px-6 py-3 font-medium text-gray-700">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="dept in filteredDepartments"
            :key="dept.id"
            class="border-t relative"
          >
            <td class="px-6 py-4">{{ dept.name }}</td>
            <td class="px-6 py-4">{{ dept.head?.full_name || "—" }}</td>
            <td class="px-6 py-4">
              <div class="relative inline-block text-left" @click.stop>
                <button
                  @click="toggleMenu(dept.id)"
                  class="focus:outline-none"
                  aria-haspopup="true"
                  aria-expanded="false"
                >
                  <!-- Vertical three dots icon -->
                  <svg
                    class="w-6 h-6 text-gray-600 hover:text-gray-900"
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
                    v-if="menuOpenId === dept.id"
                    class="origin-top-right absolute right-0 mt-2 w-32 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-10"
                  >
                    <div class="py-1 flex flex-col">
                      <button
                        @click="
                          () => {
                            openEditForm(dept);
                            closeMenu();
                          }
                        "
                        class="px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-left"
                      >
                        Edit
                      </button>
                      <button
                        @click="
                          () => {
                            deleteDepartment(dept.id);
                            closeMenu();
                          }
                        "
                        class="px-4 py-2 text-sm text-red-600 hover:bg-gray-100 text-left"
                      >
                        Delete
                      </button>
                    </div>
                  </div>
                </transition>
              </div>
            </td>
          </tr>
        </tbody>
      </table>

      <div v-else class="text-center text-gray-500 py-20">
        No departments found.
      </div>
    </div>

    <!-- Modal -->
    <div
      v-if="showModal"
      class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50"
    >
      <div class="bg-white rounded-lg shadow-lg w-96 p-6">
        <h2 class="text-xl font-semibold mb-4">
          {{ isEdit ? "Edit Department" : "Create Department" }}
        </h2>

        <form @submit.prevent="submitForm">
          <label class="block mb-2 font-medium text-gray-700"
            >Department Name</label
          >
          <input
            v-model="form.name"
            type="text"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded mb-4 focus:outline-none focus:ring focus:border-blue-500"
          />

          <label class="block mb-2 font-medium text-gray-700"
            >Head of Department</label
          >
          <select
            v-model="form.head_user_id"
            class="w-full px-3 py-2 border border-gray-300 rounded mb-4 focus:outline-none focus:ring focus:border-blue-500"
          >
            <option value="">-- None --</option>
            <option v-for="user in users" :key="user.id" :value="user.id">
              {{ user.full_name }}
            </option>
          </select>

          <div class="flex justify-end space-x-4">
            <button
              type="button"
              class="px-4 py-2 rounded bg-gray-300 hover:bg-gray-400"
              @click="closeModal"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="px-4 py-2 rounded bg-blue-600 text-white hover:bg-blue-700"
              :disabled="loading"
            >
              {{ loading ? "Saving..." : "Save" }}
            </button>
          </div>
        </form>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted, computed } from "vue";
import departmentApi from "@/Api/department";
import userApi from "@/Api/user";

const departments = ref([]);
const users = ref([]);

const showModal = ref(false);
const loading = ref(false);
const isEdit = ref(false);

const form = reactive({
  id: null,
  name: "",
  head_user_id: "",
});

// To track which row's menu is open
const menuOpenId = ref(null);

// Search query state
const searchQuery = ref("");

// Process departments to keep latest 10 by id descending
const processDepartments = (list) => {
  return [...list].sort((a, b) => b.id - a.id).slice(0, 10);
};

const fetchDepartments = async () => {
  try {
    const res = await departmentApi.getAll();
    departments.value = processDepartments(res.data.department);
  } catch (error) {
    console.error("Failed to fetch departments:", error);
  }
};

const fetchUsers = async () => {
  try {
    const res = await userApi.getAll();
    users.value = res.data.users;
  } catch (error) {
    console.error("Failed to fetch users:", error);
  }
};

// Computed filtered list based on search query
const filteredDepartments = computed(() => {
  if (!searchQuery.value.trim()) return departments.value;
  return departments.value.filter((dept) =>
    dept.name.toLowerCase().includes(searchQuery.value.toLowerCase())
  );
});

// Helper to get user object by ID for head info
const getHeadUserById = (id) => {
  return users.value.find((u) => u.id === id) || null;
};

const openCreateForm = () => {
  isEdit.value = false;
  form.id = null;
  form.name = "";
  form.head_user_id = "";
  showModal.value = true;
};

const openEditForm = (dept) => {
  isEdit.value = true;
  form.id = dept.id;
  form.name = dept.name;
  form.head_user_id = dept.head_user_id || "";
  showModal.value = true;
};

const closeModal = () => {
  showModal.value = false;
  loading.value = false;
  closeMenu();
};

const submitForm = async () => {
  loading.value = true;
  try {
    const payload = {
      name: form.name,
      head_user_id: form.head_user_id || null,
    };

    if (isEdit.value) {
      await departmentApi.update(form.id, payload);
      // Update local department including full head user object
      const index = departments.value.findIndex((d) => d.id === form.id);
      if (index !== -1) {
        departments.value[index] = {
          ...departments.value[index],
          ...payload,
          head: getHeadUserById(payload.head_user_id),
        };
      }
    } else {
      const res = await departmentApi.create(payload);
      const newDept = {
        ...res.data.department,
        head: getHeadUserById(res.data.department.head_user_id),
      };
      departments.value = processDepartments([newDept, ...departments.value]);
    }
    closeModal();
  } catch (error) {
    console.error("Failed to save department:", error);
  } finally {
    loading.value = false;
  }
};

const deleteDepartment = async (id) => {
  if (!confirm("Are you sure you want to delete this department?")) return;

  try {
    await departmentApi.delete(id);
    departments.value = departments.value.filter((d) => d.id !== id);
  } catch (error) {
    console.error("Failed to delete department:", error);
  }
};

function toggleMenu(id) {
  menuOpenId.value = menuOpenId.value === id ? null : id;
}

function closeMenu() {
  menuOpenId.value = null;
}

// Close dropdown menu on outside click
document.addEventListener("click", () => {
  closeMenu();
});

onMounted(() => {
  fetchDepartments();
  fetchUsers();
});
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
