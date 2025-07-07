import api from '@/plugin/axios' // Adjust path if needed

export default {
  login(data) {
    return api.post('/login', data)  // POST login with { email, password }
  },
  logout() {
    return api.post('/logout')  // POST logout (needs auth)
  },
  getUser() {
    return api.get('/user')  // GET currently authenticated user
  }
}