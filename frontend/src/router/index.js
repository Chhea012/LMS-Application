import { createRouter, createWebHistory } from 'vue-router'

// Layout
import MainLayout from '@/components/layout/MainLayout.vue'

// Pages
import LoginView from '@/views/LoginView.vue'
import HomeView from '@/views/HomeView.vue'
import DepartmentView from '@/views/DepartmentView.vue'
import UserView from '@/views/UserView.vue'
import RequestView from '@/views/permission/RequestView.vue'
import TypeView from '@/views/permission/TypeView.vue'
import ApprovalView from '@/views/permission/ApprovalView.vue'

const routes = [
  {
    path: '/login',
    name: 'login',
    component: LoginView
  },
  {
    path: '/',
    component: MainLayout,
    children: [
      { path: '', name: 'home', component: HomeView },
      { path: 'department', name: 'department', component: DepartmentView },
      { path: 'user', name: 'user', component: UserView },
      { path: 'permission/request', name: 'request', component: RequestView },
      { path: 'permission/type', name: 'type', component: TypeView },
      { path: 'permission/approval', name: 'approval', component: ApprovalView }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

// Auth guard
router.beforeEach((to, from, next) => {
  const isLoggedIn = localStorage.getItem('isLoggedIn') === 'true'

  if (to.path !== '/login' && !isLoggedIn) {
    next('/login')
  } else if (to.path === '/login' && isLoggedIn) {
    next('/')
  } else {
    next()
  }
})

export default router
