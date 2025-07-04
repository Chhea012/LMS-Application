<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold text-gray-800 mb-4">Approval Management</h1>
    <p class="text-gray-600">Manage approval requests and statuses here.</p>

    <div class="mt-6 bg-white border border-gray-200 rounded-lg shadow overflow-x-auto">
      <table v-if="approvals.length" class="min-w-full divide-y divide-gray-200">
        <thead class="bg-gray-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Requested By</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Approved By</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Comments</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Created At</th>
            <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">Status</th>
          </tr>
        </thead>
        <tbody class="bg-white divide-y divide-gray-200">
          <tr v-for="(approval, index) in approvals" :key="index">
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
              {{ approval.requested_by }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-700">
              {{ approval.approved_by }}
            </td>
            <td
              class="px-6 py-4 whitespace-nowrap text-sm text-blue-600 underline cursor-pointer"
              @click="openCommentPopup(approval.comments)"
            >
              Comment
            </td>
            <td class="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
              {{ approval.created_at }}
            </td>
            <td class="px-6 py-4 whitespace-nowrap">
              <span
                :class="[
                  'px-2 inline-flex text-xs leading-5 font-semibold rounded-full',
                  approval.status === 'Approved'
                    ? 'bg-green-100 text-green-800'
                    : 'bg-yellow-100 text-yellow-800'
                ]"
              >
                {{ approval.status }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>

      <p v-else class="py-8 text-center text-gray-400">No approvals found.</p>
    </div>

    <!-- Popup Modal -->
    <div
      v-if="showPopup"
      class="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50"
      @click.self="closePopup"
    >
      <div class="bg-white p-6 rounded-lg shadow-lg max-w-md w-full">
        <h2 class="text-lg font-bold mb-4">Comment</h2>
        <p class="text-gray-700 mb-4">{{ selectedComment }}</p>
        <button
          @click="closePopup"
          class="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600"
        >
          Close
        </button>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import permissionApprovalApi from '@/Api/permissionApproval' // adjust path if needed

const approvals = ref([])
const showPopup = ref(false)
const selectedComment = ref('')

function openCommentPopup(comment) {
  selectedComment.value = comment
  showPopup.value = true
}

function closePopup() {
  showPopup.value = false
  selectedComment.value = ''
}

async function fetchAllApprovals() {
  try {
    const res = await permissionApprovalApi.getAll()

    const sortedAsc = res.data
      .filter((approval) => approval.request) // ✅ only require request exists
      .sort((a, b) => new Date(a.created_at) - new Date(b.created_at))

    const last10 = sortedAsc.slice(-10).reverse()

    approvals.value = last10.map((approval) => ({
      request_id: approval.permission_request_id,
      requested_by: approval.request?.user?.full_name ?? '—',
      approved_by: approval.approver?.full_name ?? '—',
      comments: approval.comments ?? 'No comments',
      created_at: approval.created_at,
      status: approval.status ?? 'Approved',
    }))
  } catch (error) {
    console.error('Failed to fetch approvals:', error)
  }
}

onMounted(fetchAllApprovals)
</script>

<style>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
