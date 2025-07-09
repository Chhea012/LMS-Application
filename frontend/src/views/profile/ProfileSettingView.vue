<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4">
      <!-- Header Section -->
      <div class="bg-white border rounded-lg shadow-sm mb-6">
        <div class="px-8 py-6 border-b">
          <h1 class="text-2xl font-semibold text-gray-900">Profile Settings</h1>
          <p class="text-gray-600 mt-1">Manage your profile information</p>
        </div>

        <!-- Profile Info -->
        <div class="px-8 py-6 flex items-start gap-6">
          <div class="relative cursor-pointer" @click="openImageModal">
            <img
              :src="profile.imageUrl"
              class="w-32 h-32 rounded-lg object-cover border"
              alt="Profile Picture"
            />
          </div>
          <div class="flex-1">
            <h2 class="text-xl font-semibold text-gray-900 mb-2">
              {{ profile.fullName }}
            </h2>
            <div class="space-y-2 text-gray-600">
              <div class="flex items-center gap-2">
                <Mail class="w-4 h-4" /> {{ profile.email }}
              </div>
              <div class="flex items-center gap-2">
                <Briefcase class="w-4 h-4" /> {{ profile.jobTitle }}
              </div>
              <div class="flex items-center gap-2">
                <Building class="w-4 h-4" /> {{ profile.department_name }}
              </div>
            </div>
          </div>
        </div>

        <!-- Edit Button -->
        <div class="px-8 py-4 border-t flex justify-end">
          <button
            @click="showEditModal = true"
            class="px-6 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
          >
            Edit Profile
          </button>
        </div>
      </div>

      <!-- Profile Fields (readonly) -->
      <div class="bg-white border rounded-lg shadow-sm px-8 py-6">
        <h3 class="text-lg font-medium text-gray-900 mb-4">Personal Info</h3>
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Name</label
            >
            <input
              type="text"
              class="input"
              :value="profile.fullName"
              disabled
            />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Email</label
            >
            <input type="email" class="input" :value="profile.email" disabled />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Department</label
            >
            <input
              type="text"
              class="input"
              :value="profile.department_name"
              disabled
            />
          </div>
          <div>
            <label class="block text-sm font-medium text-gray-700 mb-2"
              >Role</label
            >
            <input
              type="text"
              class="input"
              :value="profile.jobTitle"
              disabled
            />
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Profile Modal -->
    <EditProfileModal
      v-model="showEditModal"
      :profile="profile"
      @update:profile="updateProfile"
      @save="saveProfile"
    />
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import api from "@/plugin/axios";
import { Mail, Briefcase, Building } from "lucide-vue-next";
import EditProfileModal from "@/components/content/profile/EditProfileModal.vue";

const profile = ref({
  id: null,
  fullName: "",
  email: "",
  jobTitle: "",
  department_name: "",
  department: "", // for editing, optional
  imageUrl: "",
  imageFile: null, // store selected file here
});

const showEditModal = ref(false);

async function fetchUserProfile() {
  try {
    const res = await api.get("/user");
    const data = res.data;

    profile.value.id = data.id;
    profile.value.fullName = data.full_name;
    profile.value.email = data.email;
    profile.value.jobTitle = data.role_name ?? "N/A";
    profile.value.department_name = data.department_name ?? "N/A";
    profile.value.department = data.department_name ?? "";
    profile.value.imageUrl =
      data.image_url ??
      "https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg";

    // Clear any previous selected file after load
    profile.value.imageFile = null;
  } catch (err) {
    console.error("Failed to load user profile:", err);
  }
}

onMounted(() => {
  fetchUserProfile();
});

// Update local profile state from modal changes
function updateProfile(updated) {
  profile.value = { ...updated };
}

// Save profile data on modal save event
async function saveProfile() {
  try {
    const formData = new FormData();
    formData.append("full_name", profile.value.fullName);
    formData.append("email", profile.value.email);

    if (profile.value.imageFile) {
      formData.append("image", profile.value.imageFile);
    }

    await api.put(`/profile`, formData, {
      headers: {
        "Content-Type": "multipart/form-data",
      },
    });

    alert("Profile updated successfully!");
    showEditModal.value = false;

    // Reload fresh profile data from server after update
    await fetchUserProfile();
  } catch (err) {
    console.error("Failed to update profile:", err);
    alert("Failed to update profile");
  }
}
</script>

<style scoped>
.input {
  width: 100%;
  padding: 0.75rem;
  border: 1px solid #d1d5db;
  background-color: #f9fafb;
  border-radius: 0.375rem;
  color: #6b7280;
}
</style>
