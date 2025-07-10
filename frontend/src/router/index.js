import { createRouter, createWebHistory } from 'vue-router'
import MainLayout from '@/components/layout/MainLayout.vue'
import LoginView from '@/views/LoginView.vue'
import HomeView from '@/views/HomeView.vue'
import DepartmentView from '@/views/DepartmentView.vue'
import UserView from '@/views/UserView.vue'
import RequestView from '@/views/permission/RequestView.vue'
import TypeView from '@/views/permission/TypeView.vue'
import ApprovalView from '@/views/permission/ApprovalView.vue'
import UserHomeView from '@/views/UserRole/UserHomeView.vue'
import ProfileSettingView from '@/views/profile/ProfileSettingView.vue'
import RequestDayView from '@/views/UserRole/RequestDayView.vue'
import PermissionRequestView from '@/views/UserRole/PermissionRequestView.vue'
import HistoryDetailView from '@/views/UserRole/HistoryDetailView.vue'

// Fallback components for missing imports
const loadComponent = (component) => {
  return () => import(`@/views/${component}.vue`).catch(() => ({
    template: `<div>Component ${component} not found</div>`
  }))
}

const routes = [
  {
    path: '/login',
    name: 'login',
    component: LoginView,
    meta: { requiresAuth: false },
  },
  {
    path: '/userhome',
    name: 'userhome',
    component: UserHomeView,
    meta: { requiresAuth: true, roles: [4] },
  },
  {
    path: '/request-days',
    name: 'RequestDays',
    component: RequestDayView,
    meta: { requiresAuth: true, roles: [4] },
  },
  {
    path: '/request-permission',
    name: 'RequestPermission',
    component: PermissionRequestView,
    meta: { requiresAuth: true, roles: [4] },
  },
  {
    path: '/history-detail',
    name: 'HistoryDetail',
    component: HistoryDetailView,
    meta: { requiresAuth: true, roles: [4] },
  },
  {
    path: '/',
    component: MainLayout,
    meta: { requiresAuth: true, roles: [1, 2, 3] },
    children: [
      {
        path: '',
        name: 'home',
        component: HomeView,
        meta: { requiresAuth: true, roles: [1, 2, 3] },
      },
      {
        path: 'profile-settings',
        name: 'profile-settings',
        component: ProfileSettingView,
        meta: { requiresAuth: true, roles: [1, 2, 3, 4] },
      },
      {
        path: 'department',
        name: 'department',
        component: DepartmentView,
        meta: { requiresAuth: true, roles: [1, 2, 3] },
      },
      {
        path: 'user',
        name: 'user',
        component: UserView,
        meta: { requiresAuth: true, roles: [1, 2, 3] },
      },
      {
        path: 'permission/request',
        name: 'request',
        component: RequestView,
        meta: { requiresAuth: true, roles: [1, 2, 3] },
      },
      {
        path: 'permission/type',
        name: 'type',
        component: TypeView,
        meta: { requiresAuth: true, roles: [1, 2, 3] },
      },
      {
        path: 'permission/approval',
        name: 'approval',
        component: ApprovalView,
        meta: { requiresAuth: true, roles: [1, 2, 3] },
      },
    ],
  },
  {
    path: '/:pathMatch(.*)*',
    redirect: '/login',
  },
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes,
})

router.beforeEach((to, from, next) => {
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true'
  const userRole = localStorage.getItem('role_id') ? parseInt(localStorage.getItem('role_id'), 10) : null

  console.log('Navigation check - Role:', userRole, 'Logged In:', isLoggedIn, 'To:', to.path)

  // Skip guard on initial login navigation (handled by LoginView)
  if (to.path === '/' || to.path === '/userhome') {
    if (isLoggedIn && userRole) {
      console.log(`Allowing initial navigation to ${to.path} for role ${userRole}`)
      return next()
    }
  }

  // Handle invalid or missing role_id after initial load
  if (isLoggedIn && (userRole === null || isNaN(userRole))) {
    console.warn('Invalid or missing role_id, logging out')
    localStorage.removeItem('token')
    localStorage.removeItem('isLoggedIn')
    localStorage.removeItem('role_id')
    return next('/login')
  }

  // Unauthenticated access to protected routes
  if (to.meta.requiresAuth && !isLoggedIn) {
    console.log(`Unauthenticated access to ${to.path}, redirecting to /login`)
    return next('/login')
  }

  // Role-based access control
  if (to.meta.roles && isLoggedIn && userRole && !to.meta.roles.includes(userRole)) {
    console.log(`Role ${userRole} not allowed for ${to.path}, redirecting`)
    return next(userRole === 4 ? '/userhome' : '/')
  }

  console.log(`Allowing navigation to ${to.path} for role ${userRole}`)
  next()
})

export default router