<template>
  <Navbar />

  <div class="p-6 bg-gradient-to-br from-teal-50 via-white to-gray-50 min-h-screen">
    <!-- Dashboard Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <!-- Request Permission -->
      <DashboardCard
        title="Request Permission"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-blue-500"
      >
        <p class="text-gray-600 mb-4">Submit a new permission request.</p>
        <button
          @click="showModal = true"
          class="bg-blue-600 text-white font-semibold px-5 py-2.5 rounded-full hover:bg-blue-700 shadow-sm transition duration-200"
        >
          Request Now
        </button>
      </DashboardCard>

      <!-- Days You Can Request -->
      <DashboardCard
        title="Days You Can Request"
        @click="goToRequestDays"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-green-500 cursor-pointer hover:scale-[1.02] transition-transform"
      >
        <p class="text-4xl font-bold text-green-600">5</p>
        <p class="text-gray-500 mt-1 text-sm">remaining this month</p>
      </DashboardCard>

      <!-- History Summary -->
      <DashboardCard
        title="History Summary"
        class="bg-white shadow-lg rounded-xl p-6 border-t-4 border-teal-500"
      >
        <p class="text-gray-700 mb-1">Total: <span class="font-bold text-gray-800">12</span></p>
        <p class="text-green-600 mb-1">Approved: <span class="font-bold">10</span></p>
        <p class="text-red-600">Rejected: <span class="font-bold">2</span></p>
      </DashboardCard>
    </div>

    <!-- Table -->
      <RequestTable :requests="requestHistory" />
      
    <!-- Modal -->
    <RequestModal
      v-model="showModal"
      @submit-request="handleSubmitRequest"
    />
  </div>
</template>

<script setup>
import { ref } from 'vue'
import Navbar from '@/components/layout/Navbar.vue'
import DashboardCard from '@/components/user/DashboardCard.vue'
import RequestModal from '@/components/user/RequestModal.vue'
import RequestTable from '@/components/user/RequestTable.vue'
import { useRouter } from 'vue-router'

const showModal = ref(false)

const requestHistory = ref([
  { date: '2025-07-01', reason: 'Medical leave', status: 'Approved' },
  { date: '2025-07-03', reason: 'Family issue', status: 'Rejected' },
  { date: '2025-07-05', reason: 'Travel', status: 'Pending' },
])

function handleSubmitRequest(newRequest) {
  requestHistory.value.push(newRequest)
}

const router = useRouter()

function goToRequestDays() {
  router.push({ name: 'RequestDays' })
}
</script>
