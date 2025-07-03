<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-r from-purple-400 via-pink-500 to-red-500 px-4">
    <div class="bg-white p-8 rounded-lg shadow-lg w-full max-w-md">
      <h1 class="text-3xl font-extrabold text-purple-700 mb-6 text-center">Login</h1>
      <form @submit.prevent="handleLogin" class="space-y-5">
        <input
          v-model="email"
          type="email"
          placeholder="Email"
          class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500"
          required
        />
        <input
          v-model="password"
          type="password"
          placeholder="Password"
          class="w-full px-4 py-3 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-purple-500"
          required
        />
        <button
          type="submit"
          class="w-full py-3 bg-purple-600 text-white font-semibold rounded-md hover:bg-purple-700 transition"
        >
          Login
        </button>
      </form>
      <p v-if="success" class="mt-4 text-green-600 text-center font-semibold">{{ success }}</p>
      <p v-if="error" class="mt-4 text-red-600 text-center">{{ error }}</p>
      <p class="mt-4 text-center text-gray-600">
        Don't have an account?
        <router-link to="/register" class="text-purple-600 hover:underline">Register here</router-link>
      </p>
    </div>
  </div>
</template>

<script setup>
import { ref } from 'vue'
import api from '../plugin/axios'
import axios from 'axios'
import { useRouter } from 'vue-router'

const router = useRouter()
const email = ref('')
const password = ref('')
const error = ref(null)
const success = ref(null)

const handleLogin = async () => {
  error.value = null
  success.value = null
  try {
    await axios.get('http://127.0.0.1:8000/sanctum/csrf-cookie', { withCredentials: true })

    const res = await api.post('/login', {
      email: email.value,
      password: password.value,
    })

    localStorage.setItem('token', res.data.token)
    success.value = '🎉 Login successful! Redirecting...'

    setTimeout(() => {
      router.push('/')
    }, 1500)
  } catch (e) {
    console.error('Login error:', e)
    error.value = e.response?.data?.message || 'Login failed'
  }
}
</script>
