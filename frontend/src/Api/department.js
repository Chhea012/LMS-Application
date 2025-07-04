import api from '@/plugin/axios' // ✅ Adjusted import path is fine (depends on your project structure)

export default {
  getAll() {
    return api.get('/v1/department') // ✅ GET all departments
  },
  get(id) {
    return api.get(`/v1/department/${id}`) // ✅ GET single department
  },
  create(data) {
    return api.post('/v1/department', data) // ✅ POST (create)
  },
  update(id, data) {
    return api.put(`/v1/department/${id}`, data) // ✅ PUT (update)
  },
  delete(id) {
    return api.delete(`/v1/department/${id}`) // ✅ DELETE
  }
}
