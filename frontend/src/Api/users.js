import api from '@/plugin/axios';

export const getUsers = async () => {
  try {
    const [usersRes, rolesRes, deptsRes] = await Promise.all([
      api.get('/users'),
      api.get('/roles'),
      api.get('/department'),
    ]);

    const users = Array.isArray(usersRes.data.users)
      ? usersRes.data.users
      : Array.isArray(usersRes.data)
      ? usersRes.data
      : [];
    const roles = Array.isArray(rolesRes.data.roles)
      ? rolesRes.data.roles
      : Array.isArray(rolesRes.data)
      ? rolesRes.data
      : [];
    const departments = Array.isArray(deptsRes.data.department)
      ? deptsRes.data.department
      : Array.isArray(deptsRes.data)
      ? deptsRes.data
      : [];

    return users.map((user) => ({
      ...user,
      role_name: roles.find((r) => r.id === user.role_id)?.role_name || 'Unknown',
      department_name: departments.find((d) => d.id === user.department_id)?.name || 'Unknown',
    }));
  } catch (error) {
    console.error('Error fetching users:', error);
    throw new Error(error.response?.data?.message || 'Failed to fetch users');
  }
};

export const createUser = async (userData) => {
  const formData = new FormData();
  formData.append('full_name', userData.full_name || '');
  formData.append('email', userData.email || '');
  formData.append('password', userData.password || '');
  formData.append('role_id', userData.role_id || '');
  formData.append('department_id', userData.department_id || '');
  if (userData.image) {
    formData.append('image', userData.image);
  }

  try {
    const response = await api.post('/users', formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data;
  } catch (error) {
    console.error('Error creating user:', error);
    throw new Error(error.response?.data?.message || 'Failed to create user');
  }
};

export const updateUser = async (id, userData) => {
  const formData = new FormData();
  formData.append('full_name', userData.full_name || '');
  formData.append('email', userData.email || '');
  formData.append('role_id', userData.role_id || '');
  formData.append('department_id', userData.department_id || '');
  if (userData.password) {
    formData.append('password', userData.password);
  }
  if (userData.image) {
    formData.append('image', userData.image);
  }
  formData.append('_method', 'PUT');

  try {
    const response = await api.post(`/users/${id}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data;
  } catch (error) {
    console.error('Error updating user:', error);
    throw new Error(error.response?.data?.message || 'Failed to update user');
  }
};

export const deleteUser = async (id) => {
  try {
    const response = await api.delete(`/users/${id}`);
    return response.data;
  } catch (error) {
    console.error('Error deleting user:', error);
    throw new Error(error.response?.data?.message || 'Failed to delete user');
  }
};

export const getRoles = async () => {
  try {
    const res = await api.get('/roles');
    return Array.isArray(res.data.roles) ? res.data.roles : Array.isArray(res.data) ? res.data : [];
  } catch (error) {
    console.error('Error fetching roles:', error);
    throw new Error(error.response?.data?.message || 'Failed to fetch roles');
  }
};

export const getDepartments = async () => {
  try {
    const res = await api.get('/department');
    return Array.isArray(res.data.department) ? res.data.department : Array.isArray(res.data) ? res.data : [];
  } catch (error) {
    console.error('Error fetching departments:', error);
    throw new Error(error.response?.data?.message || 'Failed to fetch departments');
  }
};