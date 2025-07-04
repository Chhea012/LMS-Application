// src/Api/user.js
import api from '@/plugin/axios' // Adjust path if needed

export default {
  getAll() {
    return api.get('/v1/users')  // GET all users
  },
  get(id) {
    return api.get(`/v1/users/${id}`)  // GET single user by id
  },
  create(data) {
    return api.post('/v1/users', data)  // POST create new user
  },
  update(id, data) {
    return api.put(`/v1/users/${id}`, data)  // PUT update user by id
  },
  delete(id) {
    return api.delete(`/v1/users/${id}`)  // DELETE user by id
  }
}
