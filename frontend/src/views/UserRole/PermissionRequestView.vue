
<template>
  <div class="min-h-screen bg-gradient-to-br from-teal-50 via-white to-gray-50 p-6">
    <Navbar />

    <div class="max-w-7xl mx-auto">
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

      <form
        @submit.prevent="submit"
        class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100"
      >
        <div v-if="errorMessage" class="text-red-600 mb-4">{{ errorMessage }}</div>

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
            :disabled="isSubmitting"
          >
            {{ isSubmitting ? 'Submitting...' : 'Submit Request' }}
          </button>
        </div>
      </form>

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
  </div>
</template>

<script setup>
import { reactive, ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'
import apiInstance from '@/plugin/axios'

const router = useRouter()
const isSubmitting = ref(false)
const errorMessage = ref('')
const permissionTypes = ref([])

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

onMounted(async () => {
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
})

async function submit() {
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
    showToast('Request submitted successfully!', 'success')
    router.push({ name: 'UserHome' })
  } catch (err) {
    console.error('Failed to submit request:', err)
    errorMessage.value = 'Failed to submit request. Please try again.'
    showToast(errorMessage.value, 'error')
  } finally {
    isSubmitting.value = false
  }
}

function cancel() {
  router.push({ name: 'UserHome' })
}

function goBack() {
  router.back()
}
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