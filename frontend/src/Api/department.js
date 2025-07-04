import api from '@/plugin/axios' // ✅ Adjusted import path is fine (depends on your project structure)

export default {
  getAll() {
    return api.get('/department') // ✅ GET all departments
  },
  get(id) {
    return api.get(`/department/${id}`) // ✅ GET single department
  },
  create(data) {
    return api.post('/department', data) // ✅ POST (create)
  },
  update(id, data) {
    return api.put(`/department/${id}`, data) // ✅ PUT (update)
  },
  delete(id) {
    return api.delete(`/department/${id}`) // ✅ DELETE
  }
}
