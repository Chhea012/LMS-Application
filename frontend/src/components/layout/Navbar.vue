<script setup>
import { defineProps, defineEmits, onMounted, onUnmounted, ref } from "vue";
import { useRouter } from "vue-router";
import api from "@/plugin/axios";

const router = useRouter()
const signOut = async () => {
  try {
    await api.post('/logout')  // no extra /v1 here
    localStorage.removeItem('token')
    localStorage.setItem('isLoggedIn', 'false')
    delete api.defaults.headers.common['Authorization']
    router.push('/login')
  } catch (error) {
    console.error('Logout failed:', error)
    alert('Logout failed: ' + (error.response?.data?.message || error.message))
  }
}


const props = defineProps({
  profileOpen: Boolean,
});

const emit = defineEmits(["toggle-profile", "toggle-sidebar", "close-profile"]);
const toggleProfile = () => emit("toggle-profile");
const toggleSidebar = () => emit("toggle-sidebar");
const closeDropdown = () => emit("close-profile");


const user = ref({
  full_name: "",
  role_name: "",
  image_url: "",
});

onMounted(async () => {
  try {
    const res = await api.get("/user");
    user.value = res.data;
  } catch (error) {
    console.error("Failed to load user:", error);
  }

  window.addEventListener("click", handleClickOutside);
});

onUnmounted(() => {
  window.removeEventListener("click", handleClickOutside);
});

function handleClickOutside(e) {
  if (
    !e.target.closest(".profile-dropdown") &&
    !e.target.closest(".profile-toggle-btn")
  ) {
    emit("close-profile");
  }
}
</script>

<template>
  <header
    class="h-16 sticky top-0 z-40 bg-white border-b border-gray-200 shadow-sm flex items-center justify-between px-4 sm:px-6"
  >
    <!-- Sidebar Toggle -->
    <div class="flex items-center gap-3">
      <button
        @click="toggleSidebar"
        class="lg:hidden p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition"
      >
        <svg
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M4 6h16M4 12h16M4 18h16"
          />
        </svg>
      </button>
      <span class="text-xl font-semibold text-teal-700 hidden sm:block"
        >LMS Dashboard</span
      >
    </div>

    <!-- Profile Section -->
    <div class="flex items-center gap-4">
      <!-- Notification (optional) -->
      <button
        class="relative p-2 rounded-md text-gray-600 hover:text-gray-900 hover:bg-gray-100 transition"
      >
        <svg
          class="w-6 h-6"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M15 17h5l-1.405-1.405C18.79 14.79 18 13.42 18 12V8a6 6 0 10-12 0v4c0 1.42-.79 2.79-1.595 3.595L3 17h5m4 0v1a2 2 0 104 0v-1m-4 0h4"
          />
        </svg>
        <span
          class="absolute -top-1 -right-1 h-5 w-5 bg-red-500 text-white text-xs rounded-full flex items-center justify-center"
        >
          3
        </span>
      </button>

      <!-- Profile Dropdown -->
      <div class="relative">
        <button
          @click="toggleProfile"
          class="profile-toggle-btn flex items-center gap-2 sm:gap-3 p-2 rounded-md hover:bg-gray-100 transition"
        >
          <img
            :src="
              user.image_url ||
              'https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg'
            "
            alt="User"
            class="w-8 h-8 rounded-full ring-1 ring-gray-200 object-cover"
          />

          <div class="hidden sm:block text-left">
            <p class="text-sm font-medium text-gray-800">
              {{ user.full_name }}
            </p>
            <p class="text-xs text-gray-500">{{ user.role_name }}</p>
          </div>

          <svg
            class="h-4 w-4 text-gray-400 transition-transform"
            :class="{ 'rotate-180': profileOpen }"
            fill="none"
            stroke="currentColor"
            stroke-width="2"
            viewBox="0 0 24 24"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              d="M19 9l-7 7-7-7"
            />
          </svg>
        </button>

        <transition name="fade">
          <div
            v-if="profileOpen"
            class="profile-dropdown absolute right-0 mt-2 w-56 bg-white rounded-md shadow-lg border border-gray-200 py-2 z-50"
            @click.stop
          >
            <!-- Dropdown Header -->
            <div
              class="flex items-center gap-3 px-4 py-3 border-b border-gray-100"
            >
              <img
                :src="
                  user.image_url ||
                  'https://i.pinimg.com/736x/8f/86/50/8f8650ffcdfda6f1767a99565d3a4402.jpg'
                "
                alt="User"
                class="w-8 h-8 rounded-full ring-1 ring-gray-200 object-cover"
              />
              <div>
                <p class="text-sm font-medium text-gray-800">
                  {{ user.full_name }}
                </p>
                <p class="text-xs text-gray-500">{{ user.role_name }}</p>
              </div>
            </div>

            <!-- Dropdown Items -->
            <div class="py-2">
              <RouterLink
                to="/profile-settings"
                @click="closeDropdown"
                class="block px-4 py-2 text-sm text-gray-700 hover:bg-gray-100"
              >
                Profile Settings
              </RouterLink>
            </div>

            <!-- Sign Out -->
            <div class="border-t border-gray-100 pt-2">
              <button
                @click="signOut"
                class="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-red-50"
              >
                Sign Out
              </button>
            </div>
          </div>
        </transition>
      </div>
    </div>
  </header>
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
