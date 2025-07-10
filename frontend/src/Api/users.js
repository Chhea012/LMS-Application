import api from '@/plugin/axios';

const getUserImageUrl = (user) => {
  if (user.image_url) return user.image_url;
  if (user.image) return `http://127.0.0.1:8000/storage/${user.image}`;
  return 'https://via.placeholder.com/40';
};

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

    return users.map((user) => {
      const role = roles.find((r) => r.id === user.role_id);
      const dept = departments.find((d) => d.id === user.department_id);
      return {
        ...user,
        role_name: role ? role.role_name : 'Unknown',
        department_name: dept ? dept.name : 'Unknown',
        image_url: getUserImageUrl(user),
      };
    });
  } catch (error) {
    console.error('Error fetching users:', error.response || error);
    throw new Error('Failed to fetch users: ' + (error.response?.data?.message || error.message));
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
    console.error('Error creating user:', error.response || error);
    throw new Error('Failed to create user: ' + (error.response?.data?.message || error.message));
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
  formData.append('_method', 'PUT'); // Laravel uses POST + _method override

  try {
    const response = await api.post(`/users/${id}`, formData, {
      headers: { 'Content-Type': 'multipart/form-data' },
    });
    return response.data;
  } catch (error) {
    console.error('Error updating user:', error.response || error);
    throw new Error('Failed to update user: ' + (error.response?.data?.message || error.message));
  }
};

export const deleteUser = async (id) => {
  try {
    const response = await api.delete(`/users/${id}`);
    return response.data;
  } catch (error) {
    console.error('Error deleting user:', error.response || error);
    throw new Error('Failed to delete user: ' + (error.response?.data?.message || error.message));
  }
};

export const getRoles = async () => {
  try {
    const res = await api.get('/roles');
    return Array.isArray(res.data.roles) ? res.data.roles : Array.isArray(res.data) ? res.data : [];
  } catch (error) {
    console.error('Error fetching roles:', error.response || error);
    throw new Error('Failed to fetch roles: ' + (error.response?.data?.message || error.message));
  }
};

export const getDepartments = async () => {
  try {
    const res = await api.get('/department');
    return Array.isArray(res.data.department) ? res.data.department : Array.isArray(res.data) ? res.data : [];
  } catch (error) {
    console.error('Error fetching departments:', error.response || error);
    throw new Error('Failed to fetch departments: ' + (error.response?.data?.message || error.message));
  }
};
