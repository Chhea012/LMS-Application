<script setup>
import { ref, defineProps, defineEmits, onUnmounted } from "vue";
import api from "@/plugin/axios";

const props = defineProps({
  modelValue: { type: Boolean, required: true },
  profile: { type: Object, required: true }, // fullName, email, imageUrl, imageFile
});

const emits = defineEmits(["update:modelValue", "update:profile", "save"]);
const showImagePreview = ref(false);
const isSaving = ref(false);

let previousObjectUrl = null;

function close() {
  emits("update:modelValue", false);
  showImagePreview.value = false;

  if (previousObjectUrl) {
    URL.revokeObjectURL(previousObjectUrl);
    previousObjectUrl = null;
  }
}

function updateProfileField(field, value) {
  emits("update:profile", { ...props.profile, [field]: value });
}

function onImageChange(event) {
  const file = event.target.files[0];
  if (!file) return;

  // Revoke previous object URL for preview
  if (previousObjectUrl) {
    URL.revokeObjectURL(previousObjectUrl);
  }

  const objectUrl = URL.createObjectURL(file);
  previousObjectUrl = objectUrl;

  emits("update:profile", {
    ...props.profile,
    imageFile: file,
    imageUrl: objectUrl,
  });
}

function openImagePreview() {
  if (props.profile.imageUrl) {
    showImagePreview.value = true;
  }
}

onUnmounted(() => {
  if (previousObjectUrl) {
    URL.revokeObjectURL(previousObjectUrl);
  }
});

async function save() {
  try {
    isSaving.value = true;

    const formData = new FormData();
    formData.append("full_name", props.profile.fullName || "");
    formData.append("email", props.profile.email || "");
    if (props.profile.imageFile) {
      formData.append("image", props.profile.imageFile);
    }

    await api.put("/profile", formData, {
      headers: { "Content-Type": "multipart/form-data" },
    });

    alert("Profile updated successfully!");
    emits("update:modelValue", false);
    emits("save"); // parent component can listen to this to reload data
  } catch (err) {
    if (err.response) {
      // Server responded with status code outside 2xx
      console.error("API error response:", err.response.data);
      alert(
        "Failed to update profile: " +
          (err.response.data.message || JSON.stringify(err.response.data))
      );
    } else if (err.request) {
      // No response received
      console.error("No response received:", err.request);
      alert("Failed to update profile: No response from server");
    } else {
      // Something else caused error
      console.error("Error", err.message);
      alert("Failed to update profile: " + err.message);
    }
  } finally {
    isSaving.value = false;
  }
}
</script>

<template>
  <div
    v-if="modelValue"
    class="fixed inset-0 z-50 bg-black/60 flex items-center justify-center p-4"
    @click.self="close"
  >
    <div class="bg-white rounded-xl w-[34%] max-w-2xl p-10 shadow-lg space-y-6">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold">Edit Profile</h2>
        <button
          @click="close"
          :disabled="isSaving"
          class="text-gray-500 hover:text-black text-xl disabled:opacity-50"
        >
          ×
        </button>
      </div>

      <div class="text-center">
        <img
          :src="
            profile.imageUrl || 'https://via.placeholder.com/150?text=No+Image'
          "
          alt="Profile Image"
          class="w-28 h-28 mx-auto rounded-full object-cover border-2 border-gray-300 cursor-pointer hover:scale-105 transition"
          @click="openImagePreview"
        />
        <input
          type="file"
          class="mt-2 text-sm"
          @change="onImageChange"
          :disabled="isSaving"
        />
      </div>

      <div class="grid md:grid-cols gap-4">
        <div>
          <label class="block text-sm font-medium">Full Name</label>
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md"
            :value="profile.fullName"
            @input="(e) => updateProfileField('fullName', e.target.value)"
            :disabled="isSaving"
          />
        </div>

        <div>
          <label class="block text-sm font-medium">Email</label>
          <input
            type="email"
            class="w-full px-4 py-2 border rounded-md"
            :value="profile.email"
            @input="(e) => updateProfileField('email', e.target.value)"
            :disabled="isSaving"
          />
        </div>
      </div>

      <div class="flex justify-end gap-3">
        <button
          @click="close"
          :disabled="isSaving"
          class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300 disabled:opacity-50"
        >
          Cancel
        </button>
        <button
          @click="save"
          :disabled="isSaving"
          class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 disabled:opacity-50"
        >
          {{ isSaving ? "Saving..." : "Save" }}
        </button>
      </div>
    </div>
  </div>

  <!-- Fullscreen Image Preview -->
  <div
    v-if="showImagePreview"
    class="fixed inset-0 z-50 bg-black/90 flex items-center justify-center"
    @click="showImagePreview = false"
  >
    <img
      :src="profile.imageUrl"
      alt="Full Image"
      class="max-w-full max-h-full rounded-lg"
    />
  </div>
</template>

<style scoped>
input:focus {
  outline: none;
  border-color: #3b82f6;
  box-shadow: 0 0 0 1px #3b82f6;
}
</style>
