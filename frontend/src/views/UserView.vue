<template>
  <div class="p-6">
    <!-- Header -->
    <div class="flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">Users</h1>
      <button
        @click="openCreateModal"
        class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded flex items-center gap-2"
      >
        <i class="bx bx-plus"></i> Add User
      </button>
    </div>

    <!-- Loading, Error, and Empty States -->
    <div v-if="loading" class="text-center">
      <i class="bx bx-loader-alt animate-spin text-blue-600 text-2xl"></i>
    </div>
    <div v-else-if="error" class="text-red-600 text-center">{{ error }}</div>
    <div v-else-if="users.length === 0" class="text-center text-gray-500">No users found.</div>

    <!-- Users Table -->
    <table v-else class="min-w-full bg-white shadow-md rounded overflow-hidden">
      <thead class="bg-gray-100">
        <tr>
          <th class="py-3 px-4 text-left">ID</th>
          <th class="py-3 px-4 text-left">Image</th>
          <th class="py-3 px-4 text-left">Name</th>
          <th class="py-3 px-4 text-left">Email</th>
          <th class="py-3 px-4 text-left">Role</th>
          <th class="py-3 px-4 text-left">Department</th>
          <th class="py-3 px-4 text-left">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="(user, index) in users" :key="user.id" class="border-t hover:bg-gray-50 relative">
          <td class="py-2 px-4">{{ index + 1 }}</td>
          <td class="py-2 px-4">
            <img
              :src="getUserImageUrl(user)"
              class="w-10 h-10 rounded-full object-cover"
              :alt="`${user.full_name} profile image`"
            />
          </td>
          <td class="py-2 px-4">{{ user.full_name || 'N/A' }}</td>
          <td class="py-2 px-4">{{ user.email || 'N/A' }}</td>
          <td class="py-2 px-4">{{ user.role_name || 'Unknown' }}</td>
          <td class="py-2 px-4">{{ user.department_name || 'Unknown' }}</td>
          <td class="py-2 px-4 relative">
            <button
              @click="toggleMenu(user.id)"
              class="text-gray-600 hover:text-gray-800"
              aria-label="User actions"
            >
              <i class="bx bx-dots-vertical-rounded text-xl"></i>
            </button>
            <div
              v-if="activeMenu === user.id"
              class="absolute right-0 mt-2 w-28 bg-white border rounded shadow-lg z-10 flex flex-col"
            >
              <button
                @click="viewUser(user)"
                class="w-full px-4 py-2 text-gray-700 hover:bg-gray-100 flex items-center gap-2"
                aria-label="View user details"
              >
                <i class="bx bx-show text-lg"></i> View
              </button>
              <button
                @click="openEditModal(user)"
                class="w-full px-4 py-2 text-blue-600 hover:bg-gray-100 flex items-center gap-2"
                aria-label="Edit user"
              >
                <i class="bx bx-edit text-lg"></i> Edit
              </button>
              <button
                @click="openDeleteConfirmation(user.id)"
                class="w-full px-4 py-2 text-red-600 hover:bg-gray-100 flex items-center gap-2"
                aria-label="Delete user"
              >
                <i class="bx bx-trash text-lg"></i> Delete
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- View User Modal -->
    <div
      v-if="showViewModal"
      class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
      @click.self="closeViewModal"
    >
      <div class="bg-white max-w-sm w-full rounded-lg shadow-md overflow-hidden animate-fade-in relative">
        <div class="bg-gradient-to-r from-blue-500 to-indigo-600 p-3 rounded-t-lg flex justify-between items-center">
          <h2 class="text-lg font-bold text-white">User Profile</h2>
          <button
            @click="closeViewModal"
            class="text-white text-xl hover:text-gray-200"
            aria-label="Close profile"
          >
            <i class="bx bx-x"></i>
          </button>
        </div>
        <div class="p-4">
          <div class="flex flex-col items-center">
            <img
              :src="getUserImageUrl(selectedUser)"
              class="w-24 h-24 rounded-full object-cover border-2 border-white shadow-sm mb-3"
              :alt="`${selectedUser.full_name} profile image`"
            />
            <h3 class="text-md font-semibold text-gray-800">{{ selectedUser.full_name || 'N/A' }}</h3>
            <p class="text-xs text-gray-500 mb-3">{{ selectedUser.email || 'N/A' }}</p>
            <div class="w-full space-y-2 text-sm">
              <div class="flex items-center gap-2">
                <i class="bx bx-briefcase text-blue-600"></i>
                <p><strong>Role:</strong> {{ selectedUser.role_name || 'Unknown' }}</p>
              </div>
              <div class="flex items-center gap-2">
                <i class="bx bx-building text-blue-600"></i>
                <p><strong>Department:</strong> {{ selectedUser.department_name || 'Unknown' }}</p>
              </div>
            </div>
          </div>
          <div class="flex justify-end mt-4">
            <button
              @click="closeViewModal"
              class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm flex items-center gap-1"
            >
              <i class="bx bx-check"></i> Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Create/Edit User Modal -->
    <div
      v-if="showModal"
      class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
      @click.self="closeModal"
    >
      <div class="bg-white max-w-lg w-full rounded-lg shadow-md overflow-hidden animate-fade-in relative">
        <div class="bg-gradient-to-r from-blue-500 to-indigo-600 p-3 rounded-t-lg flex justify-between items-center">
          <h2 class="text-lg font-bold text-white">{{ editing ? 'Edit User' : 'Create User' }}</h2>
          <button
            @click="closeModal"
            class="text-white text-xl hover:text-gray-200"
            aria-label="Close form"
          >
            <i class="bx bx-x"></i>
          </button>
        </div>
        <div class="p-6">
          <div v-if="formError" class="text-red-600 text-xs mb-3 bg-red-100 p-2 rounded">{{ formError }}</div>
          <form @submit.prevent="editing ? updateUserHandler() : createUserHandler()">
            <!-- Full Name -->
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Full Name</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-user text-blue-600"></i>
                <input
                  v-model="form.full_name"
                  type="text"
                  class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                  required
                />
              </div>
            </div>

            <!-- Email -->
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Email</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-envelope text-blue-600"></i>
                <input
                  v-model="form.email"
                  type="email"
                  class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                  required
                />
              </div>
            </div>

            <!-- Password -->
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">
                Password <span v-if="editing" class="text-gray-500 text-xs">(optional)</span>
              </label>
              <div class="flex items-center gap-2">
                <i class="bx bx-lock-alt text-blue-600"></i>
                <input
                  v-model="form.password"
                  type="password"
                  class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                  :required="!editing"
                />
              </div>
            </div>

            <!-- Role -->
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Role</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-briefcase text-blue-600"></i>
                <select
                  v-model="form.role_id"
                  class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                  required
                >
                  <option value="" disabled>Select a role</option>
                  <option v-for="role in roles" :key="role.id" :value="role.id">{{ role.role_name }}</option>
                </select>
              </div>
            </div>

            <!-- Department -->
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Department</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-building text-blue-600"></i>
                <select
                  v-model="form.department_id"
                  class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500"
                  required
                >
                  <option value="" disabled>Select a department</option>
                  <option v-for="dept in departments" :key="dept.id" :value="dept.id">{{ dept.name }}</option>
                </select>
              </div>
            </div>

            <!-- Image Upload -->
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Image</label>
              <div
                class="border-2 border-dashed border-gray-300 rounded-lg p-3 text-center cursor-pointer hover:bg-gray-100 transition-colors duration-200"
                :class="{ 'bg-gray-100': isDragging }"
                @dragover.prevent="isDragging = true"
                @dragleave.prevent="isDragging = false"
                @drop.prevent="handleImageDrop"
                @click="$refs.fileInput.click()"
              >
                <i class="bx bx-upload text-blue-600 text-xl mb-1"></i>
                <p class="text-xs text-gray-600">Drag & drop or click to upload image</p>
                <input
                  ref="fileInput"
                  type="file"
                  class="hidden"
                  accept="image/*"
                  @change="handleFileChange"
                />
                <img
                  v-if="imagePreview"
                  :src="imagePreview"
                  alt="Image preview"
                  class="mx-auto mt-3 w-24 h-24 object-cover rounded-full border"
                />
              </div>
            </div>

            <!-- Buttons -->
            <div class="flex justify-end gap-3 mt-6">
              <button
                type="button"
                @click="closeModal"
                class="px-4 py-2 rounded bg-gray-200 hover:bg-gray-300 text-gray-700"
                :disabled="formLoading"
              >
                Cancel
              </button>
              <button
                type="submit"
                class="px-4 py-2 rounded bg-blue-600 hover:bg-blue-700 text-white flex items-center gap-2"
                :disabled="formLoading"
              >
                <i v-if="formLoading" class="bx bx-loader-alt animate-spin"></i>
                {{ editing ? 'Update' : 'Create' }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div
      v-if="showDeleteModal"
      class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center p-4"
      @click.self="closeDeleteModal"
    >
      <div class="bg-white max-w-xs w-full rounded-lg shadow-md overflow-hidden animate-fade-in relative p-6">
        <h3 class="text-lg font-bold mb-3">Delete Confirmation</h3>
        <p class="mb-6">Are you sure you want to delete this user? This action cannot be undone.</p>
        <div class="flex justify-end gap-3">
          <button
            @click="closeDeleteModal"
            class="px-4 py-2 rounded bg-gray-200 hover:bg-gray-300 text-gray-700"
            :disabled="formLoading"
          >
            Cancel
          </button>
          <button
            @click="deleteUserHandler"
            class="px-4 py-2 rounded bg-red-600 hover:bg-red-700 text-white flex items-center gap-2"
            :disabled="formLoading"
          >
            <i v-if="formLoading" class="bx bx-loader-alt animate-spin"></i>
            Delete
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { Notyf } from 'notyf';
import 'notyf/notyf.min.css';
import {
  getUsers,
  createUser,
  updateUser,
  deleteUser,
  getRoles,
  getDepartments,
} from '@/Api/users';

// Notification instance
const notyf = new Notyf({
  duration: 3000,
  position: { x: 'right', y: 'bottom' },
  ripple: true,
  dismissible: true,
  types: [
    {
      type: 'success',
      background: '#2563eb',
      icon: { className: 'bx bx-check-circle', tagName: 'i', color: '#fff' },
    },
    {
      type: 'error',
      background: '#dc2626',
      icon: { className: 'bx bx-error', tagName: 'i', color: '#fff' },
    },
    {
      type: 'delete',
      background: '#dc2626',
      duration: 0,
      dismissible: true,
      icon: { className: 'bx bx-error', tagName: 'i', color: '#fff' },
    },
  ],
});

// Reactive state
const users = ref([]);
const roles = ref([]);
const departments = ref([]);
const loading = ref(false);
const error = ref(null);

const showModal = ref(false);
const editing = ref(false);
const editId = ref(null);
const formLoading = ref(false);
const formError = ref(null);
const activeMenu = ref(null);

const showViewModal = ref(false);
const selectedUser = ref(null);

const isDragging = ref(false);

const showDeleteModal = ref(false);
const deleteId = ref(null);

const imagePreview = ref(null);

const form = ref({
  full_name: '',
  email: '',
  password: '',
  role_id: '',
  department_id: '',
  image: null,
});

// Helper: get user image URL
const getUserImageUrl = (user) => {
  if (!user) return 'https://via.placeholder.com/40';
  if (user.image_url) return user.image_url;
  if (user.image) return `http://127.0.0.1:8000/storage/${user.image}`;
  return 'https://via.placeholder.com/40';
};

// Fetch users list
const fetchUsers = async () => {
  loading.value = true;
  error.value = null;
  try {
    users.value = await getUsers();
  } catch (err) {
    error.value = err.message || 'Failed to fetch users. Please try again.';
    notyf.error(error.value);
  } finally {
    loading.value = false;
  }
};

// Fetch roles and departments
const fetchRolesAndDepartments = async () => {
  loading.value = true;
  error.value = null;
  try {
    const [rolesRes, deptsRes] = await Promise.all([getRoles(), getDepartments()]);
    roles.value = rolesRes;
    departments.value = deptsRes;
  } catch (err) {
    error.value = err.message || 'Failed to fetch roles or departments. Please try again.';
    notyf.error(error.value);
  } finally {
    loading.value = false;
  }
};

// Open Create Modal
const openCreateModal = () => {
  resetForm();
  editing.value = false;
  showModal.value = true;
};

// Open Edit Modal and populate form
const openEditModal = (user) => {
  editing.value = true;
  editId.value = user.id;
  form.value.full_name = user.full_name;
  form.value.email = user.email;
  form.value.password = '';
  form.value.role_id = user.role_id || user.role?.id || '';
  form.value.department_id = user.department_id || user.department?.id || '';
  form.value.image = null;
  imagePreview.value = getUserImageUrl(user);
  showModal.value = true;
};

// Close create/edit modal and reset form
const closeModal = () => {
  showModal.value = false;
  resetForm();
};

// Reset form fields
const resetForm = () => {
  form.value = {
    full_name: '',
    email: '',
    password: '',
    role_id: '',
    department_id: '',
    image: null,
  };
  imagePreview.value && URL.revokeObjectURL(imagePreview.value);
  imagePreview.value = null;
  formError.value = null;
};

// Create new user
const createUserHandler = async () => {
  formError.value = null;
  formLoading.value = true;

  if (!form.value.full_name || !form.value.email || !form.value.password || !form.value.role_id || !form.value.department_id) {
    formError.value = 'Please fill in all required fields.';
    formLoading.value = false;
    return;
  }

  try {
    await createUser(form.value);
    notyf.success('User created successfully');
    await fetchUsers();
    closeModal();
  } catch (err) {
    formError.value = err.message || 'Failed to create user.';
    notyf.error(formError.value);
  } finally {
    formLoading.value = false;
  }
};

// Update existing user
const updateUserHandler = async () => {
  formError.value = null;
  formLoading.value = true;

  if (!form.value.full_name || !form.value.email || !form.value.role_id || !form.value.department_id) {
    formError.value = 'Please fill in all required fields.';
    formLoading.value = false;
    return;
  }

  try {
    await updateUser(editId.value, form.value);
    notyf.success('User updated successfully');
    await fetchUsers();
    closeModal();
  } catch (err) {
    formError.value = err.message || 'Failed to update user.';
    notyf.error(formError.value);
  } finally {
    formLoading.value = false;
  }
};

// Open delete confirmation modal
const openDeleteConfirmation = (id) => {
  deleteId.value = id;
  showDeleteModal.value = true;
};

// Close delete modal
const closeDeleteModal = () => {
  showDeleteModal.value = false;
  deleteId.value = null;
};

// Delete user
const deleteUserHandler = async () => {
  if (!deleteId.value) return;
  formLoading.value = true;

  try {
    await deleteUser(deleteId.value);
    notyf.success('User deleted successfully');
    await fetchUsers();
    closeDeleteModal();
  } catch (err) {
    notyf.error(err.message || 'Failed to delete user.');
  } finally {
    formLoading.value = false;
  }
};

// Toggle action menu for user row
const toggleMenu = (id) => {
  activeMenu.value = activeMenu.value === id ? null : id;
};

// View user details modal
const viewUser = (user) => {
  selectedUser.value = user;
  showViewModal.value = true;
  activeMenu.value = null;
};

// Close user details modal
const closeViewModal = () => {
  showViewModal.value = false;
  selectedUser.value = null;
};

// Handle file input change for image upload
const handleFileChange = (e) => {
  const file = e.target.files[0];
  if (!file) return;

  form.value.image = file;
  if (imagePreview.value) URL.revokeObjectURL(imagePreview.value);
  imagePreview.value = URL.createObjectURL(file);
};

// Handle drag and drop image upload
const handleImageDrop = (e) => {
  isDragging.value = false;
  const file = e.dataTransfer.files[0];
  if (!file) return;

  form.value.image = file;
  if (imagePreview.value) URL.revokeObjectURL(imagePreview.value);
  imagePreview.value = URL.createObjectURL(file);
};

// Initial data fetch
onMounted(async () => {
  await Promise.all([fetchUsers(), fetchRolesAndDepartments()]);
});

// Clean up image preview URL on unmount
onUnmounted(() => {
  if (imagePreview.value) {
    URL.revokeObjectURL(imagePreview.value);
  }
});
</script>

<style scoped>
@keyframes fade-in {
  from { opacity: 0; }
  to { opacity: 1; }
}
.animate-fade-in {
  animation: fade-in 0.3s ease forwards;
}
@keyframes image-in {
  0% { opacity: 0; transform: scale(0.8); }
  100% { opacity: 1; transform: scale(1); }
}
.animate-image-in {
  animation: image-in 0.3s ease forwards;
}
</style>