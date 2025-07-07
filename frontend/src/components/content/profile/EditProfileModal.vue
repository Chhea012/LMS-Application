<script setup>
import { defineProps, defineEmits } from 'vue';

const props = defineProps({
  modelValue: {
    type: Boolean,
    required: true,
  },
  profile: {
    type: Object,
    required: true,
  }
});

const emits = defineEmits(['update:modelValue', 'update:profile', 'save']);

function close() {
  emits('update:modelValue', false);
}

function updateProfileField(field, value) {
  emits('update:profile', { ...props.profile, [field]: value });
}

function save() {
  emits('save');
}

// Handle image file input change
function onImageChange(event) {
  const file = event.target.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = (e) => {
    // Emit updated profile with new image URL (base64)
    emits('update:profile', { ...props.profile, imageUrl: e.target.result });
  };
  reader.readAsDataURL(file);
}
</script>

<template>
  <div
    v-if="modelValue"
    class="fixed inset-0 bg-black bg-opacity-70 flex items-center justify-center z-50"
    @click.self="close"
  >
    <div class="bg-white rounded-lg w-full max-w-2xl p-6">
      <div class="flex justify-between items-center mb-4">
        <h3 class="text-xl font-semibold text-gray-900">Edit Profile</h3>
        <button
          @click="close"
          class="text-gray-600 hover:text-gray-900 text-xl font-bold"
          aria-label="Close"
        >
          ✕
        </button>
      </div>

      <!-- Image preview and upload -->
      <div class="mb-4">
        <img
          :src="profile.imageUrl"
          alt="Profile Image"
          class="w-32 h-32 rounded-lg object-cover border-2 border-gray-300 mb-2"
        />
        <input type="file" @change="onImageChange" />
      </div>

      <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Full Name</label>
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md"
            :value="profile.fullName"
            @input="e => updateProfileField('fullName', e.target.value)"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Email</label>
          <input
            type="email"
            class="w-full px-4 py-2 border rounded-md"
            :value="profile.email"
            @input="e => updateProfileField('email', e.target.value)"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Role</label>
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md"
            :value="profile.jobTitle"
            @input="e => updateProfileField('jobTitle', e.target.value)"
          />
        </div>
        <div>
          <label class="block text-sm font-medium text-gray-700 mb-1">Department</label>
          <input
            type="text"
            class="w-full px-4 py-2 border rounded-md"
            :value="profile.department"
            @input="e => updateProfileField('department', e.target.value)"
          />
        </div>
      </div>

      <div class="mt-6 flex justify-end space-x-4">
        <button
          @click="close"
          class="px-5 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300"
        >
          Cancel
        </button>
        <button
          @click="save"
          class="px-5 py-2 bg-blue-600 text-white rounded-md hover:bg-blue-700"
        >
          Save
        </button>
      </div>
    </div>
  </div>
</template>
