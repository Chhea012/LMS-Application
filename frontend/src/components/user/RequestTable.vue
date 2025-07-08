<template>
  <div class="bg-white shadow rounded-xl p-6">
    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
      <h2 class="text-lg font-semibold text-gray-800">Request History</h2>
      <select v-model="filterStatus" class="border rounded px-3 py-1 text-sm">
        <option value="">All</option>
        <option value="Approved">Approved</option>
        <option value="Pending">Pending</option>
        <option value="Rejected">Rejected</option>
      </select>
    </div>

    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="text-left px-4 py-2 text-gray-700">Date</th>
            <th class="text-left px-4 py-2 text-gray-700">Reason</th>
            <th class="text-left px-4 py-2 text-gray-700">Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr
            v-for="(request, index) in filteredRequests"
            :key="index"
            class="hover:bg-gray-50"
          >
            <td class="px-4 py-2">{{ request.date }}</td>
            <td class="px-4 py-2">{{ request.reason }}</td>
            <td class="px-4 py-2">
              <span
                :class="[
                  'inline-block px-3 py-1 rounded-full text-xs font-medium',
                  {
                    'bg-green-100 text-green-700': request.status === 'Approved',
                    'bg-yellow-100 text-yellow-700': request.status === 'Pending',
                    'bg-red-100 text-red-700': request.status === 'Rejected',
                  },
                ]"
              >
                {{ request.status }}
              </span>
            </td>
          </tr>
          <tr v-if="filteredRequests.length === 0">
            <td colspan="3" class="text-center text-gray-500 py-4">
              No matching records
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  requests: Array
})

const filterStatus = ref('')

const filteredRequests = computed(() => {
  if (!filterStatus.value) return props.requests
  return props.requests.filter(r => r.status === filterStatus.value)
})
</script>
