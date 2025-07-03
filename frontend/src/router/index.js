import { createRouter, createWebHistory } from 'vue-router';
import AdminLayout from '@/Layouts/AdminLayout.vue';

import Dashboard from '@/views/Dashboard.vue';
import Users from '@/views/Users.vue';
// ...import the rest

const routes = [
  {
    path: '/',
    component: AdminLayout,
    children: [
      { path: '', component: Dashboard },
      { path: 'users', component: Users },
      { path: 'roles', component: () => import('@/views/Roles.vue') },
      { path: 'departments', component: () => import('@/views/Departments.vue') },
      { path: 'profiles', component: () => import('@/views/Profiles.vue') },
      { path: 'permission-requests', component: () => import('@/views/PermissionRequests.vue') },
      { path: 'my-requests', component: () => import('@/views/PermissionRequests.vue') },
      { path: 'approvals', component: () => import('@/views/Approvals.vue') },
      { path: 'notifications', component: () => import('@/views/Notifications.vue') },
      { path: 'permission-types', component: () => import('@/views/PermissionTypes.vue') },
      { path: 'access-control', component: () => import('@/views/AccessController.vue') },
      { path: 'audit-logs', component: () => import('@/views/AuditLogs.vue') },
    ]
  }
];


const router = createRouter({
  history: createWebHistory(),
  routes
});

export default router;
