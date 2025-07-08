<template>
  <!-- Only render modal if modelValue is true -->
  <div
    v-if="modelValue"
    class="fixed inset-0 z-50 bg-black bg-opacity-30 flex items-center justify-center"
  >
    <div class="bg-white w-full max-w-2xl rounded-xl shadow-lg p-6 relative">
      <h2 class="text-2xl font-semibold mb-6">Request Permission</h2>

      <!-- Permission Request Form -->
      <form @submit.prevent="submit">
        <!-- Permission Type -->
        <div class="mb-4">
          <label class="block text-sm font-medium mb-1">Permission Type</label>
          <select
            v-model="form.permission_type_id"
            required
            class="w-full border border-gray-300 rounded px-3 py-2"
          >
            <option disabled value="">-- Select Permission Type --</option>
            <option v-for="type in permissionTypes" :key="type.id" :value="type.id">
              {{ type.name }}
            </option>
          </select>
        </div>

        <!-- Reason -->
        <div class="mb-4">
          <label class="block text-sm font-medium mb-1">Reason</label>
          <textarea
            v-model="form.reason"
            rows="3"
            required
            class="w-full border border-gray-300 rounded px-3 py-2"
            placeholder="Explain your reason"
          ></textarea>
        </div>

        <!-- Date Leave -->
        <div class="mb-4">
          <label class="block text-sm font-medium mb-1">Date Leave</label>
          <input
            v-model="form.date_leave"
            type="date"
            required
            class="w-full border border-gray-300 rounded px-3 py-2"
          />
          <div class="flex gap-4 mt-2">
            <label class="inline-flex items-center">
              <input v-model="form.leave_morning" type="checkbox" class="form-checkbox" />
              <span class="ml-2">Morning</span>
            </label>
            <label class="inline-flex items-center">
              <input v-model="form.leave_afternoon" type="checkbox" class="form-checkbox" />
              <span class="ml-2">Afternoon</span>
            </label>
          </div>
        </div>

        <!-- Date Back -->
        <div class="mb-4">
          <label class="block text-sm font-medium mb-1">Date Back</label>
          <input
            v-model="form.date_back"
            type="date"
            required
            class="w-full border border-gray-300 rounded px-3 py-2"
          />
          <div class="flex gap-4 mt-2">
            <label class="inline-flex items-center">
              <input v-model="form.back_morning" type="checkbox" class="form-checkbox" />
              <span class="ml-2">Morning</span>
            </label>
            <label class="inline-flex items-center">
              <input v-model="form.back_afternoon" type="checkbox" class="form-checkbox" />
              <span class="ml-2">Afternoon</span>
            </label>
          </div>
        </div>

        <!-- Actions -->
        <div class="flex justify-end gap-2 mt-6">
          <button
            type="button"
            @click="$emit('update:modelValue', false)"
            class="px-4 py-2 bg-gray-200 rounded hover:bg-gray-300"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
          >
            Submit
          </button>
        </div>
      </form>

      <!-- Close Button (top right corner) -->
      <button
        @click="$emit('update:modelValue', false)"
        class="absolute top-3 right-3 text-gray-400 hover:text-gray-600 text-xl font-bold"
      >
        ×
      </button>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from 'vue'
import axios from 'axios'

const props = defineProps({
  modelValue: Boolean,
  userId: Number,
})

const emit = defineEmits(['update:modelValue', 'submit-request'])

const form = reactive({
  user_id: props.userId || null,
  permission_type_id: '',
  reason: '',
  date_leave: '',
  leave_morning: false,
  leave_afternoon: false,
  date_back: '',
  back_morning: false,
  back_afternoon: false,
})

const permissionTypes = reactive([])

onMounted(async () => {
  try {
    const res = await axios.get('/api/permission-types')
    permissionTypes.push(...res.data)
  } catch (err) {
    console.error('Failed to load permission types:', err)
  }
})

function submit() {
  emit('submit-request', { ...form })
  emit('update:modelValue', false) // Close modal after submission
}
</script>
