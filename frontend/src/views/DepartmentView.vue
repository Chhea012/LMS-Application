<template>
  <div class="min-h-screen bg-gray-50 p-6">
    <!-- Header -->
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

    <!-- Department Table -->
    <div class="bg-white shadow rounded-lg border border-gray-200">
      <table v-if="filteredDepartments.length" class="w-full text-left">
        <thead class="bg-gray-100">
          <tr>
            <th class="px-6 py-3 font-medium text-gray-700">Department Name</th>
            <th class="px-6 py-3 font-medium text-gray-700">Head of Department</th>
            <th class="px-6 py-3 font-medium text-gray-700">Action</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="dept in filteredDepartments" :key="dept.id" class="border-t relative">
            <td class="px-6 py-4">{{ dept.name }}</td>
            <td class="px-6 py-4">{{ dept.head?.full_name || "—" }}</td>
            <td class="px-6 py-4">
              <!-- Action Dropdown -->
              <div class="relative inline-block text-left" @click.stop>
                <button @click="toggleMenu(dept.id)" class="focus:outline-none">
                  <svg class="w-6 h-6 text-gray-600 hover:text-gray-900" fill="currentColor" viewBox="0 0 20 20">
                    <circle cx="10" cy="4" r="2" />
                    <circle cx="10" cy="10" r="2" />
                    <circle cx="10" cy="16" r="2" />
                  </svg>
                </button>

                <!-- Menu Items -->
                <transition name="fade">
                  <div
                    v-if="menuOpenId === dept.id"
                    class="origin-top-right absolute right-0 mt-2 w-32 rounded-md shadow-lg bg-white ring-1 ring-black ring-opacity-5 z-10"
                  >
                    <div class="py-1 flex flex-col">
                      <button
                        @click="() => { selectedDepartment = dept; showDetailModal = true; closeMenu(); }"
                        class="px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-left"
                      >
                        View
                      </button>
                      <button
                        @click="() => { openEditForm(dept); closeMenu(); }"
                        class="px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 text-left"
                      >
                        Edit
                      </button>
                      <button
                        @click="() => { showDeleteModal = true; deleteId = dept.id; closeMenu(); }"
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

      <!-- No data fallback -->
      <div v-else class="text-center text-gray-500 py-20">No departments found.</div>
    </div>

    <!-- Pagination -->
    <div v-if="totalPages > 1" class="flex justify-between items-center mt-4 px-4 py-2 bg-gray-50 rounded-b-lg">
      <button
        @click="prevPage"
        :disabled="currentPage === 1"
        class="px-4 py-2 rounded bg-gray-300 disabled:opacity-50 hover:bg-gray-400"
      >
        Previous
      </button>
      <span class="text-gray-700">Page {{ currentPage }} of {{ totalPages }}</span>
      <button
        @click="nextPage"
        :disabled="currentPage === totalPages"
        class="px-4 py-2 rounded bg-gray-300 disabled:opacity-50 hover:bg-gray-400"
      >
        Next
      </button>
    </div>

    <!-- Create/Edit Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg w-96 p-6">
        <h2 class="text-xl font-semibold mb-4">{{ isEdit ? "Edit Department" : "Create Department" }}</h2>
        <form @submit.prevent="submitForm">
          <label class="block mb-2 font-medium text-gray-700">Department Name</label>
          <input
            v-model="form.name"
            type="text"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded mb-4 focus:outline-none focus:ring focus:border-blue-500"
          />
          <label class="block mb-2 font-medium text-gray-700">Head of Department</label>
          <select
            v-model="form.head_user_id"
            class="w-full px-3 py-2 border border-gray-300 rounded mb-4 focus:outline-none focus:ring focus:border-blue-500"
          >
            <option value="">-- None --</option>
            <option v-for="user in users" :key="user.id" :value="user.id">{{ user.full_name }}</option>
          </select>
          <div class="flex justify-end space-x-4">
            <button type="button" class="px-4 py-2 rounded bg-gray-300 hover:bg-gray-400" @click="closeModal">
              Cancel
            </button>
            <button type="submit" class="px-4 py-2 rounded bg-blue-600 text-white hover:bg-blue-700" :disabled="loading">
              {{ loading ? "Saving..." : "Save" }}
            </button>
          </div>
        </form>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div v-if="showDeleteModal" class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg w-96 p-6">
        <h2 class="text-lg font-semibold text-red-600 mb-4">Confirm Deletion</h2>
        <p class="text-gray-700 mb-6">Are you sure you want to delete this department?</p>
        <div class="flex justify-end space-x-4">
          <button
            class="px-4 py-2 rounded bg-gray-300 hover:bg-gray-400"
            @click="() => { showDeleteModal = false; deleteId = null; }"
          >
            Cancel
          </button>
          <button class="px-4 py-2 rounded bg-red-600 text-white hover:bg-red-700" @click="deleteDepartment">
            Delete
          </button>
        </div>
      </div>
    </div>

    <!-- View Detail Modal -->
    <div v-if="showDetailModal" class="fixed inset-0 bg-black bg-opacity-40 flex items-center justify-center z-50">
      <div class="bg-white rounded-lg shadow-lg w-96 p-6">
        <h2 class="text-xl font-semibold text-blue-600 mb-4">Department Details</h2>
        <p><strong class="text-gray-700">Name:</strong> {{ selectedDepartment?.name }}</p>
        <p><strong class="text-gray-700">Head:</strong> {{ selectedDepartment?.head?.full_name || "—" }}</p>
        <p><strong class="text-gray-700">ID:</strong> {{ selectedDepartment?.id }}</p>
        <div class="flex justify-end mt-4">
          <button class="px-4 py-2 rounded bg-gray-300 hover:bg-gray-400" @click="() => { showDetailModal = false; selectedDepartment = null; }">
            Close
          </button>
        </div>
      </div>
    </div>

    <!-- Toast Notification -->
    <transition name="fade">
      <div
        v-if="toast.visible"
        :class="[
          'fixed bottom-5 right-5 px-4 py-2 rounded shadow text-white z-50',
          toast.type === 'success' ? 'bg-green-500' :
          toast.type === 'error' ? 'bg-red-500' :
          'bg-yellow-500'
        ]"
      >
        {{ toast.message }}
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, watch } from "vue";
import departmentApi from "@/Api/department";
import userApi from "@/Api/user";

// State
const departments = ref([]);
const users = ref([]);
const currentPage = ref(1);
const itemsPerPage = 5;
const searchQuery = ref("");

// Modals
const showModal = ref(false);
const showDeleteModal = ref(false);
const showDetailModal = ref(false);
const selectedDepartment = ref(null);
const isEdit = ref(false);
const deleteId = ref(null);
const loading = ref(false);

// Form
const form = reactive({
  id: null,
  name: "",
  head_user_id: "",
});

// Toast
const toast = ref({ message: "", type: "success", visible: false });
function showToast(message, type = "success") {
  toast.value = { message, type, visible: true };
  setTimeout(() => {
    toast.value.visible = false;
  }, 2000);
}

// Menu
const menuOpenId = ref(null);
function toggleMenu(id) {
  menuOpenId.value = menuOpenId.value === id ? null : id;
}
function closeMenu() {
  menuOpenId.value = null;
}
document.addEventListener("click", closeMenu);

// Computed
const filteredDepartments = computed(() => {
  let filtered = departments.value;
  if (searchQuery.value.trim()) {
    filtered = filtered.filter((d) =>
      d.name.toLowerCase().includes(searchQuery.value.toLowerCase())
    );
  }
  const start = (currentPage.value - 1) * itemsPerPage;
  return filtered.slice(start, start + itemsPerPage);
});

const totalPages = computed(() => {
  const filtered = searchQuery.value.trim()
    ? departments.value.filter((d) =>
        d.name.toLowerCase().includes(searchQuery.value.toLowerCase())
      )
    : departments.value;
  return Math.ceil(filtered.length / itemsPerPage) || 1;
});

watch(searchQuery, () => (currentPage.value = 1));

// Fetch
const fetchDepartments = async () => {
  try {
    const res = await departmentApi.getAll();
    departments.value = res.data.department.sort((a, b) => b.id - a.id);
  } catch (e) {
    showToast("Failed to load departments", "error");
  }
};
const fetchUsers = async () => {
  try {
    const res = await userApi.getAll();
    users.value = res.data.users;
  } catch (e) {
    showToast("Failed to load users", "error");
  }
};

// Form Actions
const openCreateForm = () => {
  isEdit.value = false;
  Object.assign(form, { id: null, name: "", head_user_id: "" });
  showModal.value = true;
};
const openEditForm = (dept) => {
  isEdit.value = true;
  Object.assign(form, {
    id: dept.id,
    name: dept.name,
    head_user_id: dept.head_user_id || "",
  });
  showModal.value = true;
};
const closeModal = () => {
  showModal.value = false;
  loading.value = false;
  closeMenu();
};

const getHeadUserById = (id) => users.value.find((u) => u.id === id) || null;

const submitForm = async () => {
  loading.value = true;
  const payload = {
    name: form.name,
    head_user_id: form.head_user_id || null,
  };
  try {
    if (isEdit.value) {
      await departmentApi.update(form.id, payload);
      const index = departments.value.findIndex((d) => d.id === form.id);
      if (index !== -1) {
        departments.value[index] = {
          ...departments.value[index],
          ...payload,
          head: getHeadUserById(payload.head_user_id),
        };
      }
      showToast("Updated successfully!", "success");
    } else {
      const res = await departmentApi.create(payload);
      const newDept = {
        ...res.data.department,
        head: getHeadUserById(res.data.department.head_user_id),
      };
      departments.value.unshift(newDept);
      showToast("Created successfully!", "success");
    }
    closeModal();
  } catch (e) {
    showToast("Failed to save department.", "error");
  } finally {
    loading.value = false;
  }
};

const deleteDepartment = async () => {
  try {
    await departmentApi.delete(deleteId.value);
    departments.value = departments.value.filter((d) => d.id !== deleteId.value);
    showToast("Deleted successfully!", "error");
  } catch (e) {
    showToast("Failed to delete department.", "error");
  } finally {
    showDeleteModal.value = false;
    deleteId.value = null;
  }
};

// Pagination
const nextPage = () => currentPage.value < totalPages.value && currentPage.value++;
const prevPage = () => currentPage.value > 1 && currentPage.value--;

// Mount
onMounted(() => {
  fetchDepartments();
  fetchUsers();
});
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
