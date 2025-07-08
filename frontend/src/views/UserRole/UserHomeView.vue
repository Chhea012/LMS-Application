<template>
  <Navbar />

  <div class="p-6 bg-gray-100 min-h-screen">

    <!-- Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8">
      <!-- Card 1: Request Permission -->
      <div class="bg-white shadow rounded-xl p-6 hover:shadow-lg transition">
        <h2 class="text-lg font-semibold mb-2">Request Permission</h2>
        <p class="text-gray-600 mb-4">Submit a new permission request.</p>
        <button class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700 transition">
          Request Now
        </button>
      </div>

      <!-- Card 2: Days Remaining -->
      <div class="bg-white shadow rounded-xl p-6 hover:shadow-lg transition">
        <h2 class="text-lg font-semibold mb-2">Days You Can Request</h2>
        <p class="text-3xl font-bold text-green-600">5</p>
        <p class="text-gray-500 mt-1">remaining this month</p>
      </div>

      <!-- Card 3: History -->
      <div class="bg-white shadow rounded-xl p-6 hover:shadow-lg transition">
        <h2 class="text-lg font-semibold mb-2">History Summary</h2>
        <p class="text-gray-700 mb-1">Total: <span class="font-bold">12</span></p>
        <p class="text-green-600 mb-1">Approved: <span class="font-bold">10</span></p>
        <p class="text-red-600">Rejected: <span class="font-bold">2</span></p>
      </div>
    </div>

    <!-- Table + Filter -->
    <div class="bg-white shadow rounded-xl p-6">
      <div class="flex flex-col md:flex-row md:justify-between md:items-center mb-4 gap-4">
        <h2 class="text-lg font-semibold text-gray-800">Request History</h2>

        <div class="flex items-center gap-2">
          <label class="text-sm text-gray-600">Filter:</label>
          <select v-model="filterStatus" class="border border-gray-300 rounded px-3 py-1 text-sm">
            <option value="">All</option>
            <option value="Approved">Approved</option>
            <option value="Pending">Pending</option>
            <option value="Rejected">Rejected</option>
          </select>
        </div>
      </div>

      <div class="overflow-x-auto">
        <table class="min-w-full divide-y divide-gray-200">
          <thead class="bg-gray-50">
            <tr>
              <th class="text-left px-4 py-2 font-medium text-gray-700">Date</th>
              <th class="text-left px-4 py-2 font-medium text-gray-700">Reason</th>
              <th class="text-left px-4 py-2 font-medium text-gray-700">Status</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-100">
            <tr
              v-for="(request, index) in filteredRequests"
              :key="index"
              class="hover:bg-gray-50"
            >
              <td class="px-4 py-2 text-gray-800">{{ request.date }}</td>
              <td class="px-4 py-2 text-gray-700">{{ request.reason }}</td>
              <td class="px-4 py-2">
                <span
                  class="inline-block px-3 py-1 rounded-full text-xs font-semibold"
                  :class="{
                    'bg-green-100 text-green-700': request.status === 'Approved',
                    'bg-yellow-100 text-yellow-700': request.status === 'Pending',
                    'bg-red-100 text-red-700': request.status === 'Rejected'
                  }"
                >
                  {{ request.status }}
                </span>
              </td>
            </tr>
            <tr v-if="filteredRequests.length === 0">
              <td colspan="3" class="text-center py-4 text-gray-500">No matching records.</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import Navbar from '@/components/layout/Navbar.vue'

const requestHistory = ref([
  { date: '2025-07-01', reason: 'Medical leave', status: 'Approved' },
  { date: '2025-07-03', reason: 'Family issue', status: 'Rejected' },
  { date: '2025-07-05', reason: 'Travel', status: 'Pending' },
  { date: '2025-07-06', reason: 'Personal', status: 'Approved' }
])

const filterStatus = ref('')

const filteredRequests = computed(() => {
  if (!filterStatus.value) return requestHistory.value
  return requestHistory.value.filter(req => req.status === filterStatus.value)
})
</script>

<style scoped>
/* You can add more transitions or shadows if needed */
</style>
