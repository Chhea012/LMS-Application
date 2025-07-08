<template>
  <Navbar />

  <div class="min-h-screen bg-gradient-to-br from-teal-50 via-white to-gray-50 p-6">
    <div class="max-w-7xl mx-auto">
      <!-- Top Bar: Back Button & Title -->
      <div class="flex items-center justify-between mb-8">
        <!-- Back Button -->
        <button
          @click="goBack"
          class="group flex items-center text-sm text-white bg-teal-600 hover:bg-teal-700 shadow-md rounded-full px-5 py-2 transition-all hover:scale-105"
        >
          <svg
            class="w-4 h-4 mr-2 transition-transform group-hover:-translate-x-1"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            viewBox="0 0 24 24"
          >
            <path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7" />
          </svg>
          Back
        </button>

        <!-- Title -->
        <h2 class="text-2xl font-semibold text-teal-700">Request Permission</h2>
      </div>

      <!-- Form Card -->
      <form
        @submit.prevent="submit"
        class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100"
      >
        <!-- Permission Type -->
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-1">Permission Type</label>
          <select
            v-model="form.permission_type_id"
            required
            class="w-full border border-gray-300 rounded px-4 py-2"
          >
            <option disabled value="">-- Select Permission Type --</option>
            <option v-for="type in permissionTypes" :key="type.id" :value="type.id">
              {{ type.name }}
            </option>
          </select>
        </div>

        <!-- Reason -->
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-1">Reason</label>
          <textarea
            v-model="form.reason"
            rows="3"
            required
            class="w-full border border-gray-300 rounded px-4 py-2"
            placeholder="Explain your reason"
          ></textarea>
        </div>

        <!-- Date Leave -->
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-1">Date Leave</label>
          <input
            v-model="form.date_leave"
            type="date"
            required
            class="w-full border border-gray-300 rounded px-4 py-2"
          />
          <div class="flex gap-6 mt-2">
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
        <div class="mb-6">
          <label class="block text-sm font-medium text-gray-700 mb-1">Date Back</label>
          <input
            v-model="form.date_back"
            type="date"
            required
            class="w-full border border-gray-300 rounded px-4 py-2"
          />
          <div class="flex gap-6 mt-2">
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
        <div class="flex justify-end gap-4 mt-8">
          <button
            type="button"
            @click="cancel"
            class="px-6 py-2.5 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition"
          >
            Cancel
          </button>
          <button
            type="submit"
            class="px-6 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition"
          >
            Submit Request
          </button>
        </div>
      </form>
    </div>
  </div>
</template>

<script setup>
import { reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import Navbar from '@/components/layout/Navbar.vue'

const router = useRouter()

const form = reactive({
  user_id: 1, // Replace with actual user ID
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
  console.log('Submitting:', form)
  router.push({ name: 'UserHome' })
}

function cancel() {
  router.push({ name: 'UserHome' })
}

function goBack() {
  router.back()
}
</script>
