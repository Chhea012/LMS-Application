
<template>
  <div class="bg-white/80 backdrop-blur-xl shadow-lg rounded-2xl p-6 border border-teal-100">
    <div class="flex flex-col md:flex-row justify-between items-center mb-4 gap-4">
      <h2 class="text-xl font-semibold text-teal-700 border-b pb-2">Request History</h2>
      <select
        v-model="filterStatus"
        class="border rounded px-3 py-1 text-sm text-gray-700"
      >
        <option value="">All</option>
        <option value="approved">Approved</option>
        <option value="pending">Pending</option>
        <option value="rejected">Rejected</option>
      </select>
    </div>

    <div class="overflow-x-auto">
      <table class="min-w-full divide-y divide-gray-200">
        <thead class="bg-teal-50 text-teal-700">
          <tr>
            <th class="text-left px-4 py-2 text-gray-700">Date Leave</th>
            <th class="text-left px-4 py-2 text-gray-700">Date Back</th>
            <th class="text-left px-4 py-2 text-gray-700">Reason</th>
            <th class="text-left px-4 py-2 text-gray-700">Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-gray-100">
          <tr
            v-for="request in filteredRequests"
            :key="request.id"
            class="hover:bg-teal-50 transition"
          >
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ formatDate(request.date_leave) }}
              {{ request.leave_morning ? '(Morning)' : '' }}
              {{ request.leave_afternoon ? '(Afternoon)' : '' }}
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">
              {{ formatDate(request.date_back) }}
              {{ request.back_morning ? '(Morning)' : '' }}
              {{ request.back_afternoon ? '(Afternoon)' : '' }}
            </td>
            <td class="px-4 py-2 text-gray-700 font-medium">{{ request.reason }}</td>
            <td class="px-4 py-2">
              <span
                :class="[
                  'inline-block px-3 py-1 rounded-full text-xs font-medium',
                  request.status === 'approved'
                    ? 'bg-green-100 text-green-700'
                    : request.status === 'pending'
                    ? 'bg-yellow-100 text-yellow-700'
                    : 'bg-red-100 text-red-700',
                ]"
              >
                {{ request.status }}
              </span>
            </td>
          </tr>
          <tr v-if="filteredRequests.length === 0">
            <td colspan="4" class="text-center text-gray-500 py-4">
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
  requests: {
    type: Array,
    required: true,
    default: () => [],
  },
})

const filterStatus = ref('')

const filteredRequests = computed(() => {
  if (!filterStatus.value) return props.requests
  return props.requests.filter(r => r.status.toLowerCase() === filterStatus.value.toLowerCase())
})

function formatDate(dateString) {
  return dateString
    ? new Date(dateString).toLocaleDateString(undefined, {
        year: 'numeric',
        month: 'short',
        day: 'numeric',
      })
    : 'N/A'
}
</script>