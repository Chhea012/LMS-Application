<script setup>
import { ref, onMounted, computed } from "vue";
import api from "@/plugin/axios";

// State variables
const allRequests = ref([]); // All approved requests from API
const loading = ref(true);
const error = ref(null);

const selectedReason = ref(""); // Reason text for popup
const showReasonCard = ref(false);

const currentPage = ref(1); // Current page number for pagination
const itemsPerPage = 5; // Number of items per page

// Open the popup with the selected reason
function openReason(reason) {
  selectedReason.value = reason;
  showReasonCard.value = true;
}

// Close the reason popup
function closeReason() {
  showReasonCard.value = false;
}

// Fetch approved requests from API
async function fetchApprovedRequests() {
  loading.value = true;
  error.value = null;
  try {
    const res = await api.get("/permissionrequests");

    // Filter approved only and sort newest first
    allRequests.value = res.data
      .filter((r) => r.status?.toLowerCase() === "approved" && r.updated_at)
      .sort((a, b) => b.id - a.id);
  } catch (err) {
    error.value = "Failed to load approved requests.";
    console.error(err);
  } finally {
    loading.value = false;
  }
}

// Compute the paginated list to display based on currentPage and itemsPerPage
const paginatedRequests = computed(() => {
  const start = (currentPage.value - 1) * itemsPerPage;
  const end = start + itemsPerPage;
  return allRequests.value.slice(start, end);
});

// Total number of pages (rounded up)
const totalPages = computed(() =>
  Math.ceil(allRequests.value.length / itemsPerPage)
);

// Pagination controls
function nextPage() {
  if (currentPage.value < totalPages.value) {
    currentPage.value++;
  }
}

function prevPage() {
  if (currentPage.value > 1) {
    currentPage.value--;
  }
}

// Format date nicely for display
function formatDate(dateString) {
  return new Date(dateString).toLocaleDateString(undefined, {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
}

// Fetch data on component mount
onMounted(() => {
  fetchApprovedRequests();
});
</script>

<template>
  <div class="p-6">
    <h2 class="text-2xl font-semibold mb-4 text-gray-800">
      Approved Permission Requests
    </h2>

    <div v-if="loading" class="text-gray-500">Loading...</div>
    <div v-else-if="error" class="text-red-500">{{ error }}</div>

    <div
      v-else
      class="overflow-x-auto bg-white shadow rounded-lg border border-gray-200"
    >
      <table class="min-w-full divide-y divide-gray-200 text-sm">
        <thead class="bg-blue-100 text-blue-800 uppercase font-semibold">
          <tr>
            <th class="px-4 py-3 text-left">Request By</th>
            <th class="px-4 py-3 text-left">Permission Type</th>
            <th class="px-4 py-3 text-left">Reason</th>
            <th class="px-4 py-3 text-left">Created At</th>
            <th class="px-4 py-3 text-left">Status</th>
          </tr>
        </thead>
        <tbody>
          <tr
            v-for="request in paginatedRequests"
            :key="request.id"
            class="border-t hover:bg-gray-50"
          >
            <td class="px-4 py-3">{{ request.user?.full_name || "—" }}</td>
            <td class="px-4 py-3">
              {{ request.permission_type?.name || "—" }}
            </td>
            <td class="px-4 py-3">
              <button
                v-if="request.reason"
                @click="openReason(request.reason)"
                class="text-blue-600 hover:underline"
              >
                View
              </button>
              <span v-else class="text-gray-400">—</span>
            </td>
            <td class="px-4 py-3">{{ formatDate(request.updated_at) }}</td>
            <td class="px-4 py-3">
              <span
                class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-medium"
              >
                Approved
              </span>
            </td>
          </tr>
          <tr v-if="allRequests.length === 0">
            <td colspan="5" class="px-4 py-6 text-center text-gray-500">
              No approved requests found.
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Pagination Buttons -->
      <div
        class="flex justify-between items-center mt-4 px-4 py-2 bg-gray-50 rounded-b-lg"
        v-if="allRequests.length > itemsPerPage"
      >
        <button
          @click="prevPage"
          :disabled="currentPage === 1"
          class="px-4 py-2 rounded bg-gray-300 disabled:opacity-50 hover:bg-gray-400"
        >
          Previous
        </button>

        <span class="text-gray-700">
          Page {{ currentPage }} of {{ totalPages }}
        </span>

        <button
          @click="nextPage"
          :disabled="currentPage === totalPages"
          class="px-4 py-2 rounded bg-gray-300 disabled:opacity-50 hover:bg-gray-400"
        >
          Next
        </button>
      </div>
    </div>

    <!-- Card-style Reason Popup -->
    <transition name="fade">
      <div
        v-if="showReasonCard"
        class="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50"
      >
        <div
          class="bg-white rounded-xl shadow-lg w-full max-w-md p-6 relative"
          role="dialog"
          aria-modal="true"
          aria-labelledby="reason-title"
        >
          <h3
            id="reason-title"
            class="text-lg font-semibold mb-4 text-gray-800"
          >
            Permission Reason
          </h3>
          <p class="text-gray-700 whitespace-pre-line mb-6">
            {{ selectedReason }}
          </p>
          <div class="flex justify-end">
            <button
              @click="closeReason"
              class="bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700"
            >
              Close
            </button>
          </div>
          <button
            @click="closeReason"
            class="absolute top-2 right-3 text-gray-400 hover:text-gray-700 text-2xl font-bold leading-none"
            aria-label="Close"
          >
            ×
          </button>
        </div>
      </div>
    </transition>
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.2s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
</style>
