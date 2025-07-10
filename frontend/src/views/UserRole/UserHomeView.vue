
<template>
  <div class="p-6 bg-gradient-to-br from-teal-50 via-white to-gray-50 min-h-screen">
    <Navbar />

    <div v-if="isLoading" class="text-center text-gray-500">Loading...</div>
    <div v-else class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <DashboardCard
        title="Request Permission"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-blue-500 cursor-pointer hover:scale-[1.01] transition-transform"
        @click="goToRequestPage"
      >
        <p class="text-gray-600 mb-4">Submit a new permission request.</p>
        <button
          @click.stop="goToRequestPage"
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
    <RequestModal v-model="showModal" @submit-request="handleSubmitRequest" />

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
import apiInstance from '@/plugin/axios'

const router = useRouter()
const showModal = ref(false)
const requestHistory = ref([])
const remainingDays = ref(5)
const isLoading = ref(true)

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
    const [permissionsResponse, daysResponse] = await Promise.all([
      apiInstance.get('/permissionrequests', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      }),
      apiInstance.get('/user/remaining-days', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      }),
    ])
    requestHistory.value = permissionsResponse.data.data || []
    remainingDays.value = daysResponse.data.remaining_days || 5
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

function handleSubmitRequest(newRequest) {
  requestHistory.value.push(newRequest)
  showToast('Request submitted successfully!', 'success')
  fetchUserData()
}

function goToRequestPage() {
  router.push({ name: 'RequestPermission' })
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
