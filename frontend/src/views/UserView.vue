
<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">Users</h1>
      <button @click="openCreateModal" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded flex items-center gap-2">
        <i class="bx bx-plus"></i> Add User
      </button>
    </div>

    <!-- Loading and Error States -->
    <div v-if="loading" class="text-center">
      <i class="bx bx-loader-alt animate-spin text-blue-600 text-2xl"></i>
    </div>
    <div v-else-if="error" class="text-red-600 text-center">{{ error }}</div>
    <div v-else-if="users.length === 0" class="text-center text-gray-500">No users found.</div>
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
        <tr v-for="(user, index) in users" :key="user.id" class="border-t hover:bg-gray-50">
          <td class="py-2 px-4">{{ index + 1 }}</td>
          <td class="py-2 px-4">
            <img :src="user.image_url || 'https://via.placeholder.com/40'" class="w-10 h-10 rounded-full object-cover" :alt="user.full_name + ' profile image'" />
          </td>
          <td class="py-2 px-4">{{ user.full_name || 'N/A' }}</td>
          <td class="py-2 px-4">{{ user.email || 'N/A' }}</td>
          <td class="py-2 px-4">{{ user.role_name || 'Unknown' }}</td>
          <td class="py-2 px-4">{{ user.department_name || 'Unknown' }}</td>
          <td class="py-2 px-4 relative">
            <button @click="toggleMenu(user.id)" class="text-gray-600 hover:text-gray-800" aria-label="User actions">
              <i class="bx bx-dots-vertical-rounded text-xl"></i>
            </button>
            <div v-if="activeMenu === user.id" class="absolute right-0 mt-2 w-16 bg-white border rounded shadow-lg z-10">
              <button @click="viewUser(user)" class=" w-full px-4 py-2 text-gray-700 hover:bg-gray-100 flex justify-center items-center" aria-label="View user details">
                <i class="bx bx-show text-gray-700 text-lg"></i>
              </button>
              <button @click="openEditModal(user)" class=" w-full px-4 py-2 text-blue-600 hover:bg-gray-100 flex justify-center items-center" aria-label="Edit user">
                <i class="bx bx-edit text-blue-600 text-lg"></i>
              </button>
              <button @click="openDeleteConfirmation(user.id)" class=" w-full px-4 py-2 text-red-600 hover:bg-gray-100 flex justify-center items-center" aria-label="Delete user">
                <i class="bx bx-trash text-red-600 text-lg"></i>
              </button>
            </div>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- View User Popup -->
    <div v-if="showViewModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center">
      <div class="bg-white max-w-sm w-full mx-4 rounded-lg shadow-md relative overflow-hidden animate-fade-in">
        <div class="bg-gradient-to-r from-blue-500 to-indigo-600 p-3 rounded-t-lg">
          <h2 class="text-lg font-bold text-white">User Profile</h2>
          <button @click="closeViewModal" class="absolute top-3 right-3 text-white text-xl hover:text-gray-200" aria-label="Close profile">
            <i class="bx bx-x"></i>
          </button>
        </div>
        <div class="p-4">
          <div class="flex flex-col items-center">
            <img :src="selectedUser.image_url || 'https://via.placeholder.com/100'" class="w-24 h-24 rounded-full object-cover border-2 border-white shadow-sm mb-3" :alt="selectedUser.full_name + ' profile image'" />
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
            <button @click="closeViewModal" class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm flex items-center gap-1">
              <i class="bx bx-check"></i> Close
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Create/Edit Popup -->
    <div v-if="showModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center">
      <div class="bg-white max-w-lg w-full mx-4 rounded-lg shadow-md relative overflow-hidden animate-fade-in">
        <div class="bg-gradient-to-r from-blue-500 to-indigo-600 p-3 rounded-t-lg">
          <h2 class="text-lg font-bold text-white">{{ editing ? 'Edit User' : 'Create User' }}</h2>
          <button @click="closeModal" class="absolute top-3 right-3 text-white text-xl hover:text-gray-200" aria-label="Close form">
            <i class="bx bx-x"></i>
          </button>
        </div>
        <div class="p-6">
          <div v-if="formError" class="text-red-600 text-xs mb-3 bg-red-100 p-2 rounded">{{ formError }}</div>
          <form @submit.prevent="editing ? updateUserHandler() : createUserHandler()">
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Full Name</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-user text-blue-600"></i>
                <input v-model="form.full_name" type="text" class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500" required />
              </div>
            </div>
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Email</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-envelope text-blue-600"></i>
                <input v-model="form.email" type="email" class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500" required />
              </div>
            </div>
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Password <span v-if="editing" class="text-gray-500 text-xs">(optional)</span></label>
              <div class="flex items-center gap-2">
                <i class="bx bx-lock-alt text-blue-600"></i>
                <input v-model="form.password" type="password" class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500" :required="!editing" />
              </div>
            </div>
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Role</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-briefcase text-blue-600"></i>
                <select v-model="form.role_id" class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500" required>
                  <option value="" disabled>Select a role</option>
                  <option v-for="role in roles" :value="role.id" :key="role.id">{{ role.role_name }}</option>
                </select>
              </div>
            </div>
            <div class="mb-3">
              <label class="block text-xs mb-1 font-medium text-gray-700">Department</label>
              <div class="flex items-center gap-2">
                <i class="bx bx-building text-blue-600"></i>
                <select v-model="form.department_id" class="w-full border px-2 py-1 rounded text-sm focus:ring-1 focus:ring-blue-500 focus:border-blue-500" required>
                  <option value="" disabled>Select a department</option>
                  <option v-for="dept in departments" :value="dept.id" :key="dept.id">{{ dept.name }}</option>
                </select>
              </div>
            </div>
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
                <p class="text-xs text-gray-600">Drag & drop or click to upload</p>
                <input type="file" ref="fileInput" accept="image/*" class="hidden" @change="handleImageUpload" />
              </div>
              <div v-if="imagePreview" class="mt-3 flex items-center gap-2 animate-image-in">
                <img :src="imagePreview" class="w-20 h-20 rounded-full object-cover border-2 border-blue-500" alt="Image preview" />
                <button @click="removeImage" class="text-red-600 hover:text-red-700" aria-label="Remove image">
                  <i class="bx bx-trash text-sm"></i>
                </button>
              </div>
            </div>
            <div class="flex justify-end gap-2 mt-4">
              <button type="button" @click="closeModal" class="bg-gray-200 hover:bg-gray-300 text-gray-800 px-3 py-1 rounded text-sm flex items-center gap-1">
                <i class="bx bx-x"></i> Cancel
              </button>
              <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-3 py-1 rounded text-sm flex items-center gap-1" :disabled="formLoading">
                <i class="bx bx-save"></i> {{ formLoading ? 'Processing...' : (editing ? 'Update' : 'Create') }}
              </button>
            </div>
          </form>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue';
import { Notyf } from 'notyf';
import 'notyf/notyf.min.css'; // Ensure Notyf CSS is included
import {
  getUsers,
  createUser,
  updateUser,
  deleteUser,
  getRoles,
  getDepartments,
} from '@/Api/users';

// Initialize Notyf with simplified configuration
const notyf = new Notyf({
  duration: 3000,
  position: { x: 'right', y: 'bottom' },
  ripple: true,
  dismissible: true,
  types: [
    {
      type: 'success',
      background: '#2563eb',
      icon: {
        className: 'bx bx-check-circle',
        tagName: 'i',
        color: '#fff',
      },
    },
    {
      type: 'error',
      background: '#dc2626',
      icon: {
        className: 'bx bx-error',
        tagName: 'i',
        color: '#fff',
      },
    },
    {
      type: 'delete',
      background: '#dc2626',
      duration: 0,
      dismissible: true,
      icon: {
        className: 'bx bx-error',
        tagName: 'i',
        color: '#fff',
      },
    },
  ],
});

const users = ref([]);
const roles = ref([]);
const departments = ref([]);
const showModal = ref(false);
const editing = ref(false);
const editId = ref(null);
const imagePreview = ref(null);
const loading = ref(false);
const error = ref(null);
const formLoading = ref(false);
const formError = ref(null);
const activeMenu = ref(null);
const showViewModal = ref(false);
const selectedUser = ref(null);
const isDragging = ref(false);

const form = ref({
  full_name: '',
  email: '',
  password: '',
  role_id: '',
  department_id: '',
  image: null,
});

const fetchUsers = async () => {
  try {
    loading.value = true;
    error.value = null;
    const response = await getUsers();
    users.value = response;
    console.log('Fetched users:', response);
  } catch (err) {
    error.value = err.message || 'Failed to fetch users. Please try again.';
    console.error('Fetch users error:', err);
    notyf.error(error.value);
  } finally {
    loading.value = false;
  }
};

const fetchRolesAndDepartments = async () => {
  try {
    loading.value = true;
    error.value = null;
    const [rolesRes, deptsRes] = await Promise.all([getRoles(), getDepartments()]);
    roles.value = rolesRes;
    departments.value = deptsRes;
    console.log('Fetched roles:', rolesRes);
    console.log('Fetched departments:', deptsRes);
  } catch (err) {
    error.value = err.message || 'Failed to fetch roles or departments. Please try again.';
    console.error('Fetch roles/depts error:', err);
    notyf.error(error.value);
  } finally {
    loading.value = false;
  }
};

const openCreateModal = () => {
  resetForm();
  editing.value = false;
  showModal.value = true;
};

const openEditModal = (user) => {
  editing.value = true;
  showModal.value = true;
  editId.value = user.id;
  form.value = {
    full_name: user.full_name || '',
    email: user.email || '',
    password: '',
    role_id: user.role_id || '',
    department_id: user.department_id || '',
    image: null,
  };
  imagePreview.value = user.image_url || null;
  activeMenu.value = null;
};

const openDeleteConfirmation = (id) => {
  const notification = notyf.open({
    type: 'delete',
    message: 'Are you sure you want to delete this user? <button class="ml-2 px-2 py-1 bg-white text-red-600 rounded hover:bg-gray-100">Delete</button>',
  });
  notification.on('click', ({ target }) => {
    if (target.tagName === 'BUTTON') {
      removeUserConfirmed(id);
      notyf.dismiss(notification);
    }
  });
  activeMenu.value = null;
};

const closeModal = () => {
  showModal.value = false;
  if (imagePreview.value) {
    URL.revokeObjectURL(imagePreview.value);
  }
  resetForm();
};

const resetForm = () => {
  form.value = {
    full_name: '',
    email: '',
    password: '',
    role_id: '',
    department_id: '',
    image: null,
  };
  imagePreview.value = null;
  formError.value = null;
  isDragging.value = false;
};

const handleImageUpload = (e) => {
  const file = e.target.files[0];
  validateAndSetImage(file);
};

const handleImageDrop = (e) => {
  const file = e.dataTransfer.files[0];
  validateAndSetImage(file);
  isDragging.value = false;
};

const validateAndSetImage = (file) => {
  if (file) {
    if (!file.type.startsWith('image/')) {
      formError.value = 'Please upload a valid image file.';
      return;
    }
    if (file.size > 2 * 1024 * 1024) {
      formError.value = 'Image size must be less than 2MB.';
      return;
    }
    form.value.image = file;
    if (imagePreview.value) {
      URL.revokeObjectURL(imagePreview.value);
    }
    imagePreview.value = URL.createObjectURL(file);
    formError.value = null;
  }
};

const removeImage = () => {
  if (imagePreview.value) {
    URL.revokeObjectURL(imagePreview.value);
  }
  form.value.image = null;
  imagePreview.value = null;
  formError.value = null;
};

const createUserHandler = async () => {
  try {
    formLoading.value = true;
    formError.value = null;
    const newUser = await createUser(form.value);
    console.log('Created user:', newUser);
    closeModal();
    users.value.unshift({
      id: newUser.id,
      full_name: newUser.full_name,
      email: newUser.email,
      role_name: roles.value.find((r) => r.id === newUser.role_id)?.role_name || 'Unknown',
      department_name: departments.value.find((d) => d.id === newUser.department_id)?.name || 'Unknown',
      image_url: newUser.image_url || 'https://via.placeholder.com/40',
    });
    notyf.success('User created successfully!');
  } catch (err) {
    formError.value = err.message || 'Failed to create user. Please try again.';
    console.error('Create user error:', err);
    notyf.error(formError.value);
  } finally {
    formLoading.value = false;
  }
};

const updateUserHandler = async () => {
  try {
    formLoading.value = true;
    formError.value = null;
    const updateData = { ...form.value };
    if (!updateData.password) {
      delete updateData.password;
    }
    const updatedUser = await updateUser(editId.value, updateData);
    console.log('Updated user:', updatedUser);
    closeModal();
    const index = users.value.findIndex((u) => u.id === editId.value);
    if (index !== -1) {
      users.value[index] = {
        ...users.value[index],
        full_name: updatedUser.full_name,
        email: updatedUser.email,
        role_name: roles.value.find((r) => r.id === updatedUser.role_id)?.role_name || 'Unknown',
        department_name: departments.value.find((d) => d.id === updatedUser.department_id)?.name || 'Unknown',
        image_url: updatedUser.image_url || users.value[index].image_url,
      };
    }
    notyf.success('User updated successfully!');
  } catch (err) {
    formError.value = err.message || 'Failed to update user. Please try again.';
    console.error('Update user error:', err);
    notyf.error(formError.value);
  } finally {
    formLoading.value = false;
  }
};

const removeUserConfirmed = async (id) => {
  try {
    loading.value = true;
    error.value = null;
    await deleteUser(id);
    console.log('Deleted user ID:', id);
    users.value = users.value.filter((u) => u.id !== id);
    notyf.success('User deleted successfully!');
  } catch (err) {
    error.value = err.message || 'Failed to delete user. Please try again.';
    console.error('Delete user error:', err);
    notyf.error(error.value);
  } finally {
    loading.value = false;
  }
};

const toggleMenu = (userId) => {
  activeMenu.value = activeMenu.value === userId ? null : userId;
};

const viewUser = (user) => {
  selectedUser.value = user;
  showViewModal.value = true;
  activeMenu.value = null;
};

const closeViewModal = () => {
  showViewModal.value = false;
  selectedUser.value = null;
};

onMounted(async () => {
  await fetchRolesAndDepartments();
  await fetchUsers();
  document.addEventListener('click', handleClickOutside);
});

onUnmounted(() => {
  if (imagePreview.value) {
    URL.revokeObjectURL(imagePreview.value);
  }
  document.removeEventListener('click', handleClickOutside);
});

const handleClickOutside = (event) => {
  if (!event.target.closest('.relative') && activeMenu.value !== null) {
    activeMenu.value = null;
  }
};
</script>

<style scoped>
/* Fade-in animation for modals */
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Animation for image preview */
@keyframes imageIn {
  from {
    opacity: 0;
    transform: scale(0.8);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

/* Spinner animation */
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.animate-spin {
  animation: spin 1s linear infinite;
}

.animate-fade-in {
  animation: fadeIn 0.3s ease-in-out;
}

.animate-image-in {
  animation: imageIn 0.3s ease-in-out;
}

/* Ensure Notyf notifications appear above modals */
.notyf {
  z-index: 1000;
}
</style>
