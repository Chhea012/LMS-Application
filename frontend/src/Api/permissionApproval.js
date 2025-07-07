import api from '@/plugin/axios';

export default {
  getAll() {
    return api.get('/permissionapprovals')
  },
}