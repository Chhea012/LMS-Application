<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold mb-4">Permission Days Summary</h1>

    <div class="bg-white shadow rounded-xl p-6 mb-6">
      <h2 class="text-lg font-semibold mb-2">Year 2025 Overview</h2>
      <p>Total Days Allowed: <span class="font-bold text-blue-600">12</span></p>
      <p>Used Days: <span class="font-bold text-red-600">7</span></p>
      <p>Remaining Days: <span class="font-bold text-green-600">5</span></p>
    </div>

    <div class="bg-white shadow rounded-xl p-6">
      <h2 class="text-lg font-semibold mb-4">Monthly Usage</h2>
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-100">
          <tr>
            <th class="text-left px-4 py-2">Month</th>
            <th class="text-left px-4 py-2">Used Days</th>
            <th class="text-left px-4 py-2">Remaining</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr v-for="month in months" :key="month.name">
            <td class="px-4 py-2">{{ month.name }}</td>
            <td class="px-4 py-2 text-red-600">{{ month.used }}</td>
            <td class="px-4 py-2 text-green-600">{{ month.remaining }}</td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
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
