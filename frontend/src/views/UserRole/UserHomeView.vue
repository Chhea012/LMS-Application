<template>
  <div class="p-6 bg-gradient-to-br from-teal-50 via-white to-gray-50 min-h-screen">
    <Navbar />

    <div v-if="isLoading" class="text-center text-gray-500">Loading...</div>
    <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <DashboardCard
        title="Request Permission"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-blue-500 cursor-pointer hover:scale-[1.01] transition-transform"
        @click="openCreatePopup"
      >
        <p class="text-gray-600 mb-4">Submit a new permission request.</p>
        <button
          @click.stop="openCreatePopup"
          class="bg-blue-600 text-white font-semibold px-5 py-2.5 rounded-full hover:bg-blue-700 shadow-sm transition duration-200"
        >
          Request Now
        </button>
      </DashboardCard>

      <DashboardCard
        title="Days You Can Request"
        @click="goToRequestDays"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-green-500 cursor-pointer hover:scale-[1.02] transition-transform"
      >
        <p class="text-4xl font-bold text-green-600">{{ remainingDays }}</p>
        <p class="text-gray-500 mt-1 text-sm">remaining this month</p>
      </DashboardCard>

      <DashboardCard
        title="History Summary"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-teal-500 cursor-pointer hover:scale-[1.02] transition-transform"
        @click="goToHistoryDetail"
      >
        <p class="text-gray-700 mb-1">
          Total: <span class="font-bold text-gray-800">{{ totalRequests }}</span>
        </p>
        <p class="text-green-600 mb-1">
          Approved: <span class="font-bold">{{ approvedRequests }}</span>
        </p>
        <p class="text-red-600">
          Rejected: <span class="font-bold">{{ rejectedRequests }}</span>
        </p>
      </DashboardCard>
    </div>

    <RequestTable :requests="requestHistory" />

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
              <option disabled value="">Select a permission type</option>
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

          <div class="flex justify-end gap-4">
            <button
              type="button"
              @click="closePopup"
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
          @click="closePopup"
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
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'
import DashboardCard from '@/components/user/DashboardCard.vue'
import RequestTable from '@/components/user/RequestTable.vue'
import api from '@/plugin/axios'

const router = useRouter()
const showPopup = ref(false)
const requestHistory = ref([])
const remainingDays = ref(5)
const isLoading = ref(true)
const isSubmitting = ref(false)
const errorMessage = ref('')
const permissionTypes = ref([])

const form = ref({
  user_id: localStorage.getItem('user_id') || '',
  permission_type_id: '',
  reason: '',
  status: 'pending',
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

const fetchUserData = async () => {
  try {
    isLoading.value = true
    const [permissionsResponse, daysResponse, typesResponse] = await Promise.all([
      api.get('/permissionrequests', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      }),
      api.get('/user/remaining-days', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      }),
      api.get('/permissiontypes', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      }),
    ])
    requestHistory.value = permissionsResponse.data || []
    remainingDays.value = daysResponse.data.remaining_days || 5
    permissionTypes.value = typesResponse.data.data || []
  } catch (error) {
    console.error('Error fetching user data:', error)
    showToast('Failed to fetch user data.', 'error')
  } finally {
    isLoading.value = false
  }
}

const totalRequests = computed(() => requestHistory.value.length)
const approvedRequests = computed(
  () => requestHistory.value.filter(r => r.status.toLowerCase() === 'approved').length
)
const rejectedRequests = computed(
  () => requestHistory.value.filter(r => r.status.toLowerCase() === 'rejected').length
)

function openCreatePopup() {
  resetForm()
  showPopup.value = true
}

function closePopup() {
  showPopup.value = false
  resetForm()
}

function resetForm() {
  form.value = {
    user_id: localStorage.getItem('user_id') || '',
    permission_type_id: '',
    reason: '',
    status: 'pending',
  }
}

async function createRequest() {
  try {
    isSubmitting.value = true
    await api.post('/permissionrequests', {
      user_id: form.value.user_id,
      permission_type_id: form.value.permission_type_id,
      reason: form.value.reason,
      status: form.value.status,
    }, {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    showToast('Request submitted successfully!', 'success')
    showPopup.value = false
    fetchUserData()
  } catch (err) {
    console.error('Failed to submit request:', err)
    errorMessage.value = 'Failed to submit request. Please try again.'
    showToast(errorMessage.value, 'error')
  } finally {
    isSubmitting.value = false
  }
}

function goToRequestDays() {
  router.push({ name: 'RequestDays' })
}

function goToHistoryDetail() {
  router.push({ name: 'HistoryDetail' })
}

onMounted(fetchUserData)
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