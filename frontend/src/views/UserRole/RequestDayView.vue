<template>
  <Navbar
    :profileOpen="profileOpen"
    @toggle-profile="toggleProfile"
    @close-profile="closeProfile"
  />

  <div class="p-6 min-h-screen bg-gradient-to-br from-white via-teal-50 to-white">
    <div class="mb-8 flex justify-between items-center">
      <button
        @click="goBack"
        class="group flex items-center text-sm text-white bg-teal-600 hover:bg-teal-700 shadow-lg rounded-full px-5 py-2 transition-all hover:scale-105"
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

      <div class="flex items-center gap-3">
        <svg
          xmlns="http://www.w3.org/2000/svg"
          class="h-7 w-7 text-teal-600"
          fill="none"
          viewBox="0 0 24 24"
          stroke="currentColor"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9 17v-2a4 4 0 014-4h1a4 4 0 110 8h-1a4 4 0 01-4-4z"
          />
        </svg>
        <h1 class="text-2xl font-bold text-teal-700 hidden sm:block">
          Permission Days Summary
        </h1>
      </div>
    </div>

    <div v-if="isLoading" class="text-center text-gray-500">Loading...</div>
    <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-teal-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Total Days Allowed</h3>
        <span class="text-3xl font-bold text-teal-700">{{ summary.totalDays }}</span>
      </div>
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-red-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Used Days</h3>
        <span class="text-3xl font-bold text-red-600">{{ summary.usedDays }}</span>
      </div>
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-green-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Remaining Days</h3>
        <span class="text-3xl font-bold text-green-600">{{ summary.remainingDays }}</span>
      </div>
    </div>

    <div
      v-if="!isLoading"
      class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100"
    >
      <h2 class="text-xl font-semibold mb-5 text-teal-700 border-b pb-2">
        Monthly Usage (2025)
      </h2>
      <div class="overflow-x-auto">
        <table class="min-w-full text-sm divide-y divide-gray-200">
          <thead class="bg-teal-50 text-teal-700">
            <tr>
              <th class="text-left px-4 py-2 text-gray-700">Month</th>
              <th class="text-left px-4 py-2 text-gray-700">Used Days</th>
              <th class="text-left px-4 py-2 text-gray-700">Remaining</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr
              v-for="month in months"
              :key="month.name"
              class="hover:bg-teal-50 transition"
            >
              <td class="px-4 py-3 text-gray-700 font-medium">{{ month.name }}</td>
              <td>
                <span
                  class="px-3 py-1 rounded-full bg-red-100 text-red-600 font-semibold text-xs"
                >
                  {{ month.used }}
                </span>
              </td>
              <td>
                <span
                  class="px-3 py-1 rounded-full bg-green-100 text-green-600 font-semibold text-xs"
                >
                  {{ month.remaining }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    <!-- Create Request Popup -->
    <div
      v-if="showPopup"
      class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50"
    >
      <div class="bg-white rounded-lg shadow-lg max-w-md w-full p-6 relative">
        <h3 class="text-xl font-semibold mb-4">Create Permission Request</h3>
        <form @submit.prevent="createRequest">
          <div v-if="errorMessage" class="text-red-600 mb-4">{{ errorMessage }}</div>

          <div class="mb-4">
            <label class="block mb-1 font-medium text-gray-700">Permission Type</label>
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

          <div class="mb-4">
            <label class="block mb-1 font-medium text-gray-700">Reason</label>
            <textarea
              v-model="form.reason"
              rows="3"
              required
              class="w-full border border-gray-300 rounded px-4 py-2"
              placeholder="Explain your reason"
            ></textarea>
          </div>

          <div class="mb-4">
            <label class="block mb-1 font-medium text-gray-700">Date Leave</label>
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

          <div class="mb-4">
            <label class="block mb-1 font-medium text-gray-700">Date Back</label>
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

          <div class="flex justify-end gap-4">
            <button
              type="button"
              @click="showPopup = false"
              class="px-4 py-2 border rounded hover:bg-gray-100"
            >
              Cancel
            </button>
            <button
              type="submit"
              class="px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
              :disabled="isSubmitting"
            >
              {{ isSubmitting ? 'Submitting...' : 'Create Request' }}
            </button>
          </div>
        </form>

        <button
          @click="showPopup = false"
          class="absolute top-2 right-2 text-gray-600 hover:text-gray-900 text-2xl font-bold"
          aria-label="Close popup"
        >
          ×
        </button>
      </div>
    </div>

    <!-- Toast Notification -->
    <transition name="toast-fade">
      <div
        v-if="toast.visible"
        :class="[
          'fixed bottom-6 right-6 px-4 py-2 rounded shadow-md text-white font-semibold select-none',
          toast.type === 'success' ? 'bg-green-600' : 'bg-red-600',
        ]"
        role="alert"
      >
        {{ toast.message }}
      </div>
    </transition>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'
import apiInstance from '@/plugin/axios'

const router = useRouter()
const isLoading = ref(true)
const showPopup = ref(false)
const isSubmitting = ref(false)
const errorMessage = ref('')
const months = ref([])
const summary = ref({
  totalDays: 12,
  usedDays: 7,
  remainingDays: 5,
})
const permissionTypes = ref([])
const profileOpen = ref(false)

const form = reactive({
  user_id: localStorage.getItem('user_id') || 1,
  permission_type_id: '',
  reason: '',
  date_leave: '',
  leave_morning: false,
  leave_afternoon: false,
  date_back: '',
  back_morning: false,
  back_afternoon: false,
})

const toast = ref({
  visible: false,
  message: '',
  type: 'success',
})

function showToast(message, type = 'success') {
  toast.value.message = message
  toast.value.type = type
  toast.value.visible = true
  setTimeout(() => {
    toast.value.visible = false
  }, 2000)
}

function toggleProfile() {
  profileOpen.value = !profileOpen.value
}

function closeProfile() {
  profileOpen.value = false
}

const fetchMonthlyData = async () => {
  try {
    isLoading.value = true
    const response = await apiInstance.get('/user/monthly-usage', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    months.value = response.data.months || []
    summary.value = response.data.summary || {
      totalDays: 12,
      usedDays: 7,
      remainingDays: 5,
    }
  } catch (error) {
    console.error('Error fetching monthly data:', error)
    months.value = [
      { name: 'January', used: 1, remaining: 1 },
      { name: 'February', used: 0, remaining: 2 },
      { name: 'March', used: 2, remaining: 0 },
      { name: 'April', used: 1, remaining: 1 },
      { name: 'May', used: 1, remaining: 1 },
      { name: 'June', used: 2, remaining: 0 },
      { name: 'July', used: 0, remaining: 2 },
      { name: 'August', used: 0, remaining: 2 },
      { name: 'September', used: 0, remaining: 2 },
      { name: 'October', used: 0, remaining: 2 },
      { name: 'November', used: 0, remaining: 2 },
      { name: 'December', used: 0, remaining: 2 },
    ]
    showToast('Failed to fetch monthly data.', 'error')
  } finally {
    isLoading.value = false
  }
}

const fetchPermissionTypes = async () => {
  try {
    const res = await apiInstance.get('/permission-types', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    permissionTypes.value = res.data.data || []
  } catch (err) {
    console.error('Failed to load permission types:', err)
    errorMessage.value = 'Failed to load permission types. Please try again.'
    showToast(errorMessage.value, 'error')
  }
}

async function createRequest() {
  if (!form.leave_morning && !form.leave_afternoon) {
    errorMessage.value = 'Please select at least one leave time (Morning or Afternoon).'
    showToast(errorMessage.value, 'error')
    return
  }
  if (!form.back_morning && !form.back_afternoon) {
    errorMessage.value = 'Please select at least one return time (Morning or Afternoon).'
    showToast(errorMessage.value, 'error')
    return
  }

  try {
    isSubmitting.value = true
    await apiInstance.post('/permissionrequests', form, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    showToast('Request created successfully!', 'success')
    showPopup.value = false
    await fetchMonthlyData()
  } catch (err) {
    console.error('Failed to create request:', err)
    errorMessage.value = 'Failed to create request. Please try again.'
    showToast(errorMessage.value, 'error')
  } finally {
    isSubmitting.value = false
  }
}

function goBack() {
  profileOpen.value = false // Close dropdown on navigation
  router.back()
}

onMounted(() => {
  Promise.all([fetchMonthlyData(), fetchPermissionTypes()])
})
</script>

<style>
.toast-fade-enter-active,
.toast-fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}
.toast-fade-enter-from,
.toast-fade-leave-to {
  opacity: 0;
  transform: translateY(10px);
}
</style>