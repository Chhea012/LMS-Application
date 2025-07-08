<template>
  <Navbar />

  <div class="p-6 min-h-screen bg-gradient-to-br from-white via-teal-50 to-white w-full">
    <!-- Top Bar: Back Button & Title -->
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
          Permission History Details
        </h1>
      </div>
    </div>

    <!-- History Summary Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-teal-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Total Requests</h3>
        <span class="text-3xl font-bold text-teal-700">{{ total }}</span>
      </div>
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-green-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Approved</h3>
        <span class="text-3xl font-bold text-green-600">{{ approved }}</span>
      </div>
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-red-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Rejected</h3>
        <span class="text-3xl font-bold text-red-600">{{ rejected }}</span>
      </div>
    </div>

    <!-- History Table -->
    <div
      class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100 w-full overflow-x-auto"
    >
      <h2 class="text-xl font-semibold mb-5 text-teal-700 border-b pb-2">
        Detailed Requests
      </h2>

      <table class="min-w-full text-sm divide-y divide-gray-200">
        <thead class="bg-teal-50 text-teal-700">
          <tr>
            <th class="text-left px-4 py-2 text-gray-700">Date</th>
            <th class="text-left px-4 py-2 text-gray-700">Reason</th>
            <th class="text-left px-4 py-2 text-gray-700">Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr
            v-for="(request, index) in requests"
            :key="index"
            class="hover:bg-teal-50 transition"
          >
            <td class="px-4 py-3 text-gray-700 font-medium">{{ request.date }}</td>
            <td class="px-4 py-3 text-gray-700">{{ request.reason }}</td>
            <td
              class="px-4 py-3 font-semibold"
              :class="{
                'text-green-600': request.status === 'Approved',
                'text-red-600': request.status === 'Rejected',
                'text-yellow-600': request.status === 'Pending',
              }"
            >
              {{ request.status }}
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'

const router = useRouter()

function goBack() {
  router.back()
}

const requests = ref([
  { date: '2025-07-01', reason: 'Medical leave', status: 'Approved' },
  { date: '2025-07-03', reason: 'Family issue', status: 'Rejected' },
  { date: '2025-07-05', reason: 'Travel', status: 'Pending' },
  { date: '2025-07-10', reason: 'Personal', status: 'Approved' },
  { date: '2025-07-12', reason: 'Training', status: 'Approved' },
])

const total = computed(() => requests.value.length)
const approved = computed(() => requests.value.filter(r => r.status === 'Approved').length)
const rejected = computed(() => requests.value.filter(r => r.status === 'Rejected').length)
</script>
