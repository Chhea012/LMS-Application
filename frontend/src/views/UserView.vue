<template>
  <div class="p-6">
    <div class="flex justify-between items-center mb-4">
      <h1 class="text-2xl font-bold">Users</h1>
      <button @click="openCreateModal" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded">
        + Add User
      </button>
    </div>

    <table class="min-w-full bg-white shadow-md rounded overflow-hidden">
      <thead class="bg-gray-100">
        <tr>
          <th class="py-3 px-4 text-left">Image</th>
          <th class="py-3 px-4 text-left">Name</th>
          <th class="py-3 px-4 text-left">Email</th>
          <th class="py-3 px-4 text-left">Role</th>
          <th class="py-3 px-4 text-left">Actions</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="user in users" :key="user.id" class="border-t hover:bg-gray-50">
          <td class="py-2 px-4">
            <img :src="user.image_url" class="w-10 h-10 rounded-full object-cover" />
          </td>
          <td class="py-2 px-4">{{ user.full_name }}</td>
          <td class="py-2 px-4">{{ user.email }}</td>
          <td class="py-2 px-4">{{ user.role_id }}</td>
          <td class="py-2 px-4 space-x-2">
            <button @click="openEditModal(user)" class="text-blue-600 hover:underline">Edit</button>
            <button @click="removeUser(user.id)" class="text-red-600 hover:underline">Delete</button>
          </td>
        </tr>
      </tbody>
    </table>

    <!-- Modal -->
    <div v-if="showModal" class="fixed inset-0 bg-black/50 z-50 flex items-center justify-center">
      <div class="bg-white p-6 rounded-lg w-full max-w-md relative">
        <h2 class="text-lg font-bold mb-4">{{ editing ? 'Edit User' : 'Create User' }}</h2>
        <form @submit.prevent="editing ? updateUserHandler() : createUserHandler()">
          <div class="mb-3">
            <label class="block text-sm mb-1">Full Name</label>
            <input v-model="form.full_name" type="text" class="w-full border px-3 py-2 rounded" required />
          </div>
          <div class="mb-3">
            <label class="block text-sm mb-1">Email</label>
            <input v-model="form.email" type="email" class="w-full border px-3 py-2 rounded" required />
          </div>
          <div class="mb-3">
            <label class="block text-sm mb-1">Password <span v-if="editing">(optional)</span></label>
            <input v-model="form.password" type="password" class="w-full border px-3 py-2 rounded" :required="!editing" />
          </div>
          <div class="mb-3">
            <label class="block text-sm mb-1">Image</label>
            <input type="file" @change="handleImageUpload" />
            <div v-if="imagePreview" class="mt-2">
              <img :src="imagePreview" class="w-16 h-16 rounded-full object-cover" />
            </div>
          </div>
          <div class="flex justify-end gap-2 mt-4">
            <button type="button" @click="closeModal" class="px-4 py-2 border rounded">Cancel</button>
            <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded">
              {{ editing ? 'Update' : 'Create' }}
            </button>
          </div>
        </form>
        <button @click="closeModal" class="absolute top-2 right-3 text-xl">&times;</button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import {
  getUsers,
  createUser,
  updateUser,
  deleteUser
} from '@/Api/users';

const users = ref([]);
const showModal = ref(false);
const editing = ref(false);
const editId = ref(null);
const imagePreview = ref(null);

const form = ref({
  full_name: '',
  email: '',
  password: '',
  image: null
});

const fetchUsers = async () => {
  try {
    users.value = await getUsers();
  } catch (error) {
    console.error(error);
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
  form.value.full_name = user.full_name;
  form.value.email = user.email;
  form.value.password = '';
  imagePreview.value = user.image_url;
};

const closeModal = () => {
  showModal.value = false;
  resetForm();
};

const resetForm = () => {
  form.value = {
    full_name: '',
    email: '',
    password: '',
    image: null
  };
  imagePreview.value = null;
};

const handleImageUpload = (e) => {
  const file = e.target.files[0];
  if (file) {
    form.value.image = file;
    imagePreview.value = URL.createObjectURL(file);
  }
};

const createUserHandler = async () => {
  try {
    await createUser(form.value);
    closeModal();
    fetchUsers();
  } catch (error) {
    console.error(error);
  }
};

const updateUserHandler = async () => {
  try {
    await updateUser(editId.value, form.value);
    closeModal();
    fetchUsers();
  } catch (error) {
    console.error(error);
  }
};

const removeUser = async (id) => {
  if (!confirm('Are you sure you want to delete this user?')) return;
  try {
    await deleteUser(id);
    fetchUsers();
  } catch (error) {
    console.error(error);
  }
};

onMounted(fetchUsers);
</script>
