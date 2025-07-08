<template>
  <Navbar />

  <div class="p-6 bg-gray-100 min-h-screen">

    <!-- Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <DashboardCard title="Request Permission">
        <p class="text-gray-600 mb-4">Submit a new permission request.</p>
        <button
          @click="showModal = true"
          class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition"
        >
          Request Now
        </button>
      </DashboardCard>

      <DashboardCard
  title="Days You Can Request"
  @click="goToRequestPage"
  class="cursor-pointer hover:bg-gray-50 transition"
>
  <p class="text-3xl font-bold text-green-600">5</p>
  <p class="text-gray-500 mt-1">remaining this month</p>
</DashboardCard>


      <DashboardCard title="History Summary">
        <p class="text-gray-700 mb-1">Total: <span class="font-bold">12</span></p>
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

const showModal = ref(false)

const requestHistory = ref([
  { date: '2025-07-01', reason: 'Medical leave', status: 'Approved' },
  { date: '2025-07-03', reason: 'Family issue', status: 'Rejected' },
  { date: '2025-07-05', reason: 'Travel', status: 'Pending' },
])

function handleSubmitRequest(newRequest) {
  requestHistory.value.push(newRequest)
}
</script>
