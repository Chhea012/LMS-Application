<template>
  <Navbar />

  <div class="p-6 min-h-screen bg-gradient-to-br from-white via-teal-50 to-white">
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
          Permission Days Summary
        </h1>
      </div>
    </div>

    <!-- Summary Cards -->
    <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-teal-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Total Days Allowed</h3>
        <span class="text-3xl font-bold text-teal-700">12</span>
      </div>
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-red-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Used Days</h3>
        <span class="text-3xl font-bold text-red-600">7</span>
      </div>
      <div
        class="bg-white/70 backdrop-blur shadow-xl rounded-2xl p-6 border-t-4 border-green-400"
      >
        <h3 class="text-sm text-gray-500 mb-2">Remaining Days</h3>
        <span class="text-3xl font-bold text-green-600">5</span>
      </div>
    </div>

    <!-- Monthly Table -->
    <div class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100">
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
                <span class="px-3 py-1 rounded-full bg-red-100 text-red-600 font-semibold text-xs">
                  {{ month.used }}
                </span>
              </td>
              <td>
                <span class="px-3 py-1 rounded-full bg-green-100 text-green-600 font-semibold text-xs">
                  {{ month.remaining }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRouter } from 'vue-router'
import Navbar from '@/components/layout/Navbar.vue'

const router = useRouter()

function goBack() {
  router.back()
}

const months = [
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
</script>
