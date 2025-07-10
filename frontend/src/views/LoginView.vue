<template>
  <div class="min-h-screen flex items-center justify-center bg-gray-100 px-4">
    <div class="max-w-md w-full bg-white p-8 rounded-lg shadow-md">
      <h2 class="text-2xl font-bold mb-6 text-center text-gray-800">Login</h2>

      <form @submit.prevent="login" class="space-y-6">
        <div>
          <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email</label>
          <input
            v-model="email"
            id="email"
            type="email"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
            placeholder="you@example.com"
          />
        </div>

        <div>
          <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
          <input
            v-model="password"
            id="password"
            type="password"
            required
            class="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500"
            placeholder="••••••••"
          />
        </div>

        <button
          type="submit"
          class="w-full bg-indigo-600 text-white py-2 rounded-md hover:bg-indigo-700 transition"
        >
          Login
        </button>
      </form>

      <p v-if="errorMessage" class="mt-4 text-red-600 text-center">{{ errorMessage }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import apiInstance from '@/plugin/axios'

const router = useRouter()
const email = ref('')
const password = ref('')
const errorMessage = ref('')

const login = async () => {
  errorMessage.value = ''
  try {
    const response = await apiInstance.post('/login', {
      email: email.value,
      password: password.value,
    })

    const { token, user } = response.data
    console.log('Login success:', response.data)

    // Store token and role_id in localStorage
    localStorage.setItem('token', token)
    localStorage.setItem('isLoggedIn', 'true')
    localStorage.setItem('role_id', user.role_id)

    // Immediate navigation based on role
    if (user.role_id === 4) {
      router.push('/userhome')
    } else {
      router.push('/')
    }
  } catch (error) {
    if (error.response) {
      errorMessage.value = error.response.data.message || 'Login failed'
      console.error('Login error:', error.response.data)
    } else if (error.request) {
      errorMessage.value = 'No response from server.'
      console.error('Login error: No response', error.request)
    } else {
      errorMessage.value = error.message
      console.error('Login error:', error.message)
    }
  }
}
</script>