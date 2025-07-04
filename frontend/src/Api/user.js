// src/Api/user.js
import api from '@/plugin/axios' // Adjust path if needed

export default {
  getAll() {
    return api.get('/users')  // GET all users
  },
  get(id) {
    return api.get(`/users/${id}`)  // GET single user by id
  },
  create(data) {
    return api.post('/users', data)  // POST create new user
  },
  update(id, data) {
    return api.put(`/users/${id}`, data)  // PUT update user by id
  },
  delete(id) {
    return api.delete(`/users/${id}`)  // DELETE user by id
  }
}
