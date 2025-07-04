import api from '@/plugin/axios';

export const getUsers = async () => {
  const response = await api.get('/users');
  return response.data.users;
};

export const getUserById = async (id) => {
  const response = await api.get(`/users/${id}`);
  return response.data.user;
};

export const createUser = async (userData) => {
  const formData = new FormData();
  formData.append('full_name', userData.full_name);
  formData.append('email', userData.email);
  formData.append('password', userData.password);
  if (userData.image) {
    formData.append('image', userData.image);
  }

  return await api.post('/users', formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  });
};

export const updateUser = async (id, userData) => {
  const formData = new FormData();
  formData.append('full_name', userData.full_name);
  formData.append('email', userData.email);
  if (userData.password) {
    formData.append('password', userData.password);
  }
  if (userData.image) {
    formData.append('image', userData.image);
  }

  return await api.post(`/users/${id}?_method=PUT`, formData, {
    headers: { 'Content-Type': 'multipart/form-data' }
  });
};

export const deleteUser = async (id) => {
  return await api.delete(`/users/${id}`);
};
