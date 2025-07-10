```vue
<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'
import apiInstance from '@/plugin/axios'

const router = useRouter()

// Fetch current user ID
const currentUserId = ref(null)
const fetchCurrentUser = async () => {
  try {
    const res = await apiInstance.get('/user')
    console.log('User Response:', res.data)
    if (res.data && res.data.id) {
      currentUserId.value = res.data.id
      form.user_id = currentUserId.value
    } else {
      console.warn('No user ID found in response')
    }
  } catch (error) {
    console.error('User Fetch Error:', error)
  }
}

// Form state
const form = reactive({
  user_id: null,
  permission_type_id: '',
  reason: '',
  date_leave: '',
  leave_morning: false,
  leave_afternoon: false,
  date_back: '',
  back_morning: false,
  back_afternoon: false,
})

// Permission types list
const permissionTypes = ref([])

// Fetch permission types and user on mount
onMounted(async () => {
  try {
    await fetchCurrentUser()
    const response = await apiInstance.get('/permissiontypes')
    console.log('Permission Types Response:', response.data)
    permissionTypes.value = Array.isArray(response.data.data)
      ? response.data.data
      : Array.isArray(response.data)
      ? response.data
      : []
  } catch (err) {
    console.error('Failed to load permission types:', err)
  }
})

// Submit form
async function submit() {
  try {
    const payload = {
      ...form,
      date_leave: form.date_leave || null,
      date_back: form.date_back || null,
    }
    console.log('Submit Payload:', JSON.stringify(payload, null, 2))

    if (!payload.user_id || !payload.permission_type_id || !payload.reason || !payload.date_leave || !payload.date_back) {
      alert('Please fill out all required fields, including user ID, permission type, reason, date leave, and date back.')
      return
    }

    const response = await apiInstance.post('/permissionrequests', payload, {
      headers: { 'Content-Type': 'application/json' },
    })
    console.log('Submit Response:', response.data)
    alert('Request submitted successfully!')
    router.push({ name: 'userhome' })
  } catch (error) {
    console.error('Submit Error:', {
      message: error.message,
      status: error.response?.status,
      data: error.response?.data,
    })
    alert(`Failed to submit permission request: ${error.response?.data?.message || error.message}`)
  }
}

function cancel() {
  router.push({ name: 'userhome' })
}

function goBack() {
  router.back()
}
</script>

<template>
  <Navbar />

  <div class="min-h-screen p-6 bg-gradient-to-br from-teal-50 via-white to-gray-50 max-w-7xl mx-auto">
    <!-- Header -->
    <div class="flex items-center justify-between mb-8">
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

      <h2 class="text-2xl font-semibold text-teal-700">Request Permission</h2>
    </div>

    <!-- Form -->
    <form @submit.prevent="submit" class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100">
      <!-- Permission Type -->
      <div class="mb-6">
        <label class="block text-sm font-medium text-gray-700 mb-1">Permission Type</label>
        <select
          v-model="form.permission_type_id"
          required
          class="w-full border border-gray-300 rounded px-4 py-2 text-black"
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
        <input v-model="form.date_leave" type="date" required class="w-full border border-gray-300 rounded px-4 py-2" />
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
        <input v-model="form.date_back" type="date" required class="w-full border border-gray-300 rounded px-4 py-2" />
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

      <!-- Buttons -->
      <div class="flex justify-end gap-4 mt-8">
        <button type="button" @click="cancel" class="px-6 py-2.5 bg-gray-200 text-gray-700 rounded-lg hover:bg-gray-300 transition">
          Cancel
        </button>
        <button type="submit" class="px-6 py-2.5 bg-blue-600 text-white rounded-lg hover:bg-blue-700 transition">
          Submit Request
        </button>
      </div>
    </form>
  </div>
</template>
```