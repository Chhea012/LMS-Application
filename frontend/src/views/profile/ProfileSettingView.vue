<script setup>
import { ref } from "vue";
import { useRouter } from "vue-router";
import { Mail, Briefcase, Building, User } from "lucide-vue-next";
import EditProfileModal from "@/components/content/profile/EditProfileModal.vue";

const router = useRouter();

const showImageModal = ref(false);
const showEditModal = ref(false);

import imgage from "../../images/phean2.jpg";
const profile = ref({
  fullName: "Sophean Phouk",
  email: "sophean123@gmail.com",
  jobTitle: "Developer",
  department: "Developer Team",
  imageUrl: imgage,
});

function cancel() {
  router.push("/");
}

function openImageModal() {
  showImageModal.value = true;
}

function closeImageModal() {
  showImageModal.value = false;
}

function openEditModal() {
  showEditModal.value = true;
}

function closeEditModal() {
  showEditModal.value = false;
}

function saveProfile() {
  // Add your save logic here (API call etc.)
  alert("Profile updated!");
  showEditModal.value = false;
}

function onImageChange(event) {
  const file = event.target.files[0];
  if (!file) return;
  const reader = new FileReader();
  reader.onload = (e) => {
    profile.value.imageUrl = e.target.result;
  };
  reader.readAsDataURL(file);
}
</script>

<template>
  <div class="min-h-screen bg-gray-50 py-8">
    <div class="max-w-4xl mx-auto px-4">
      <!-- Header Section -->
      <div class="bg-white border border-gray-200 rounded-lg shadow-sm mb-6">
        <div class="px-8 py-6 border-b border-gray-200">
          <h1 class="text-2xl font-semibold text-gray-900">Profile Settings</h1>
          <p class="text-gray-600 mt-1">
            Manage your professional profile information
          </p>
        </div>

        <!-- Profile Header -->
        <div class="px-8 py-6">
          <div class="flex items-start space-x-6">
            <div class="relative cursor-pointer" @click="openImageModal">
              <img
                :src="profile.imageUrl"
                class="w-32 h-32 rounded-lg object-cover border-2 border-gray-200"
                alt="Profile Picture"
              />
              <div
                class="absolute -bottom-2 -right-2 bg-green-500 w-6 h-6 rounded-full border-2 border-white"
              ></div>
            </div>
            <div class="flex-1">
              <h2 class="text-xl font-semibold text-gray-900 mb-2">
                {{ profile.fullName }}
              </h2>
              <div class="space-y-2">
                <div class="flex items-center text-gray-600">
                  <Mail class="w-4 h-4 mr-2" />
                  <span>{{ profile.email }}</span>
                </div>
                <div class="flex items-center text-gray-600">
                  <Briefcase class="w-4 h-4 mr-2" />
                  <span>{{ profile.jobTitle }}</span>
                </div>
                <div class="flex items-center text-gray-600">
                  <Building class="w-4 h-4 mr-2" />
                  <span>{{ profile.department }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Profile Information Form -->
      <div class="bg-white border border-gray-200 rounded-lg shadow-sm">
        <div class="px-8 py-6 border-b border-gray-200">
          <h3 class="text-lg font-medium text-gray-900">
            Personal Information
          </h3>
          <p class="text-sm text-gray-600 mt-1">
            Update your personal details and contact information
          </p>
        </div>

        <div class="px-8 py-6">
          <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Name -->
            <div>
              <label
                class="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-1"
              >
                <User class="w-4 h-4" />
                Name
              </label>
              <input
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-md bg-gray-50 text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                :value="profile.fullName"
                disabled
              />
            </div>

            <!-- Email -->
            <div>
              <label
                class="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-1"
              >
                <Mail class="w-4 h-4" />
                Email Address
              </label>
              <input
                type="email"
                class="w-full px-4 py-3 border border-gray-300 rounded-md bg-gray-50 text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                :value="profile.email"
                disabled
              />
            </div>

          
            <!-- Department -->
            <div>
              <label
                class="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-1"
              >
                <Building class="w-4 h-4" />
                Department
              </label>
              <input
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-md bg-gray-50 text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                :value="profile.department"
                disabled
              />
            </div>

            <!-- Role -->
            <div>
              <label
                class="block text-sm font-medium text-gray-700 mb-2 flex items-center gap-1"
              >
                <Briefcase class="w-4 h-4" />
                Role
              </label>
              <input
                type="text"
                class="w-full px-4 py-3 border border-gray-300 rounded-md bg-gray-50 text-gray-500 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
                :value="profile.jobTitle"
                disabled
              />
            </div>
          </div>
        </div>

        <!-- Action Buttons -->
        <div
          class="px-8 py-6 bg-gray-50 border-t border-gray-200 rounded-b-lg flex justify-end space-x-4"
        >
          <button
            @click="cancel"
            class="px-6 py-2.5 border border-gray-300 text-gray-700 font-medium rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
          >
            Cancel
          </button>
          <button
            @click="openEditModal"
            class="px-6 py-2.5 bg-blue-600 text-white font-medium rounded-md hover:bg-blue-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition-colors"
          >
            Edit Profile
          </button>
        </div>
      </div>

      <!-- Info Notice -->
      <div
        class="mt-6 bg-blue-50 border border-blue-200 rounded-lg p-4 flex items-start gap-3"
      >
        <div
          class="w-8 h-8 bg-blue-100 rounded-full flex items-center justify-center"
        >
          <User class="w-4 h-4 text-blue-600" />
        </div>
        <div>
          <h4 class="text-sm font-medium text-blue-800">Profile Information</h4>
          <p class="text-sm text-blue-700 mt-1">
            Your profile information is currently view-only. Click "Edit
            Profile" to make changes to your personal details.
          </p>
        </div>
      </div>
    </div>

    <!-- Image Modal -->
    <div
      v-if="showImageModal"
      class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50"
      @click.self="closeImageModal"
    >
      <div
        class="bg-white rounded-lg overflow-hidden max-w-xl max-h-[90vh] p-4"
      >
        <button
          @click="closeImageModal"
          class="mb-2 text-gray-600 hover:text-gray-900 font-bold"
          aria-label="Close image modal"
        >
          ✕ Close
        </button>
        <img
          :src="profile.imageUrl"
          alt="Profile Large Picture"
          class="max-w-full max-h-[80vh] rounded-md object-contain"
        />
      </div>
    </div>

    <!-- Edit Profile Modal -->
    <EditProfileModal
      v-model="showEditModal"
      :profile="profile"
      @update:profile="updateProfile"
      @save="onSave"
    />
  </div>
</template>
