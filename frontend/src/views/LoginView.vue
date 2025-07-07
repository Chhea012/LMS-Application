<template>
  <div class="min-h-screen bg-black flex items-center justify-center px-4">
    <div class="bg-white rounded-xl shadow-2xl max-w-md w-full p-10">
      <h1 class="text-4xl font-extrabold text-center text-blue-600 mb-8">
        Sign in to your account
      </h1>

      <div
        v-if="error"
        class="bg-red-100 text-red-700 border border-red-300 rounded-md px-4 py-2 mb-6 text-sm"
      >
        {{ error }}
      </div>

      <form @submit.prevent="login" class="space-y-6">
        <div>
          <label for="email" class="block text-gray-700 font-medium mb-2">Email address</label>
          <input
            v-model="email"
            id="email"
            type="email"
            autocomplete="email"
            placeholder="admin@example.com"
            required
            class="w-full rounded-md border border-gray-300 px-4 py-3 text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
          />
        </div>

        <div class="relative">
          <label for="password" class="block text-gray-700 font-medium mb-2">Password</label>
          <input
            :type="showPassword ? 'text' : 'password'"
            v-model="password"
            id="password"
            autocomplete="current-password"
            placeholder="••••••••"
            required
            class="w-full rounded-md border border-gray-300 px-4 py-3 pr-12 text-gray-800 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-500 transition"
          />
          <button
            type="button"
            @click="togglePassword"
            class="absolute right-3 top-9 text-gray-500 hover:text-blue-600"
            :aria-label="showPassword ? 'Hide password' : 'Show password'"
          >
            <svg v-if="showPassword" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
              viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M13.875 18.825A10.05 10.05 0 0112 19c-5.523 0-10-4.477-10-10a9.954 9.954 0 011.175-4.815M3 3l18 18" />
            </svg>
            <svg v-else xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none"
              viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
              <path stroke-linecap="round" stroke-linejoin="round"
                d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
            </svg>
          </button>
        </div>

        <button
          type="submit"
          class="w-full py-3 bg-gradient-to-r from-blue-600 to-blue-400 rounded-md text-white font-semibold hover:from-blue-700 hover:to-blue-500 transition"
        >
          Sign In
        </button>
      </form>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import apiInstance from '@/plugin/axios' // ✅ Make sure path is correct

const email = ref('')
const password = ref('')
const showPassword = ref(false)
const error = ref('')
const router = useRouter()

const togglePassword = () => {
  showPassword.value = !showPassword.value
}

const login = async () => {
  error.value = ''
  try {
    const response = await apiInstance.post('/login', {
      email: email.value,
      password: password.value,
    })

    localStorage.setItem('token', response.data.token)
    localStorage.setItem('user', JSON.stringify(response.data.user))
    localStorage.setItem('isLoggedIn', 'true') // ✅ Needed for route guard

    apiInstance.defaults.headers.common['Authorization'] = `Bearer ${response.data.token}`
    router.push('/')
  } catch (err) {
    error.value = err.response?.data?.message || 'Invalid email or password.'
  }
}
</script>
