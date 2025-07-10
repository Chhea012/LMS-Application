
<template>
  <div class="container mx-auto p-4">
    <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-4">
      <div class="bg-white shadow-lg rounded-lg p-4 flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="bg-blue-500 text-white w-12 h-12 flex items-center justify-center rounded mr-4">
            <font-awesome-icon icon="fa-users" class="text-xl" />
          </div>
          <div>
            <h3 class="text-lg text-gray-600">Total Employees</h3>
          </div>
        </div>
        <div class="text-right">
          <p class="text-2xl font-bold text-gray-800">{{ totalEmployees }}</p>
        </div>
      </div>
      <div class="bg-white shadow-lg rounded-lg p-4 flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="bg-blue-500 text-white w-12 h-12 flex items-center justify-center rounded mr-4">
            <font-awesome-icon icon="fa-user" class="text-xl" />
          </div>
          <div>
            <h3 class="text-lg text-gray-600">Total Users</h3>
          </div>
        </div>
        <div class="text-right">
          <p class="text-2xl font-bold text-gray-800">{{ totalUsers }}</p>
        </div>
      </div>
      <div class="bg-white shadow-lg rounded-lg p-4 flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="bg-green-500 text-white w-12 h-12 flex items-center justify-center rounded mr-4">
            <font-awesome-icon icon="fa-building" class="text-xl" />
          </div>
          <div>
            <h3 class="text-lg text-gray-600">Total Departments</h3>
          </div>
        </div>
        <div class="text-right">
          <p class="text-2xl font-bold text-gray-800">{{ totalDepartments }}</p>
        </div>
      </div>
      <div class="bg-white shadow-lg rounded-lg p-4 flex items-center justify-between w-full">
        <div class="flex items-center">
          <div class="bg-blue-500 text-white w-12 h-12 flex items-center justify-center rounded mr-4">
            <font-awesome-icon icon="fa-users" class="text-xl" />
          </div>
          <div>
            <h3 class="text-lg text-gray-600">Total Managers</h3>
          </div>
        </div>
        <div class="text-right">
          <p class="text-2xl font-bold text-gray-800">{{ totalManagers }}</p>
        </div>
      </div>
    </div>
    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
      <div class="bg-white p-4 rounded-lg shadow">
        <h3 class="text-lg mb-2">Permission Type Requests</h3>
        <div style="position: relative; height: 300px;">
          <Bar :data="userStatsData" :options="chartOptions" />
        </div>
      </div>
      <div class="bg-white shadow-lg rounded-lg p-4 w-full">
        <h3 class="text-lg text-gray-600 mb-2">Daily Permission Requests</h3>
        <div style="position: relative; height: 300px;">
          <Pie :data="permissionData" :options="permissionOptions" />
        </div>
        <p class="text-sm text-gray-500 mt-2">July 03 - July 04, 2025</p>
      </div>
    </div>
    <div class="mt-4 bg-white shadow-lg rounded-lg p-4 flex items-center justify-between w-full">
      <div class="flex items-center">
        <div class="bg-blue-500 text-white w-12 h-12 flex items-center justify-center rounded mr-4">
          <font-awesome-icon icon="fa-users" class="text-xl" />
        </div>
        <div>
          <h3 class="text-lg text-gray-600">Users Online</h3>
          <p v-if="onlineUsersBreakdown" class="text-sm text-gray-500">
            Admins: {{ onlineUsersBreakdown.admins }}, Employees: {{ onlineUsersBreakdown.employees }}
          </p>
          <p v-else class="text-sm text-red-500">Unable to fetch online users</p>
        </div>
      </div>
      <div class="text-right">
        <p class="text-2xl font-bold text-gray-800">{{ totalOnlineUsers }}</p>
        <p class="text-sm text-gray-500">+{{ onlineUsersGrowth }}%</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Bar, Pie } from 'vue-chartjs'
import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, LinearScale, CategoryScale, ArcElement } from 'chart.js'
import apiInstance from '@/plugin/axios'

ChartJS.register(Title, Tooltip, Legend, BarElement, LinearScale, CategoryScale, ArcElement)

const totalUsers = ref(0)
const totalEmployees = ref(0)
const totalManagers = ref(0)
const totalDepartments = ref(0)
const totalOnlineUsers = ref(0)
const onlineUsersBreakdown = ref(null)
const onlineUsersGrowth = ref(0)

const permissionData = ref({
  labels: ['Pending', 'Approved', 'Rejected'],
  datasets: [
    {
      data: [0, 0, 0],
      backgroundColor: ['#FFCE56', '#36A2EB', '#FF6384'],
      hoverOffset: 4,
    },
  ],
})

const userStatsData = ref({
  labels: [],
  datasets: [
    {
      label: 'Permission Requests by Type',
      backgroundColor: [],
      borderColor: [],
      data: [],
    },
  ],
})

const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: true, position: 'top' },
  },
  scales: {
    y: {
      beginAtZero: true,
      title: { display: true, text: 'Number of Requests' },
    },
  },
})

const permissionOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { display: true, position: 'bottom' },
    title: { display: true, text: 'Permission Status' },
    tooltip: {
      enabled: true,
      callbacks: {
        label: function (context) {
          let label = context.label || ''
          let value = context.raw || 0
          return `${label}: ${value}`
        },
      },
    },
  },
})

const fetchDashboardData = async () => {
  try {
    // Fetch users
    const usersResponse = await apiInstance.get('/users', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    const users = usersResponse.data.users || []
    totalUsers.value = users.length
    totalEmployees.value = users.filter(user => user.role_id === 4).length
    totalManagers.value = users.filter(user => user.role_id === 3).length

    // Fetch online users (with fallback)
    let onlineUsers = []
    try {
      const onlineUsersResponse = await apiInstance.get('/users/online', {
        headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
      })
      onlineUsers = onlineUsersResponse.data.users || []
    } catch (onlineError) {
      console.warn('Failed to fetch online users:', onlineError)
      // Fallback: Simulate online users (remove in production if endpoint exists)
      onlineUsers = users.slice(0, Math.min(5, users.length)) // Mock data
    }
    totalOnlineUsers.value = onlineUsers.length

    // Calculate breakdown for admins and employees
    const admins = onlineUsers.filter(user => user.role_id === 1).length
    const employees = onlineUsers.filter(user => user.role_id === 4).length
    onlineUsersBreakdown.value = { admins, employees }

    // Simulate growth percentage (replace with actual logic if available)
    onlineUsersGrowth.value = onlineUsers.length > 0 ? Math.round((onlineUsers.length / users.length) * 100) : 0

    // Fetch departments
    const departmentsResponse = await apiInstance.get('/department', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    totalDepartments.value = departmentsResponse.data.department.length

    // Fetch permission requests
    const permissionsResponse = await apiInstance.get('/permissionrequests', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    const permissions = permissionsResponse.data || []

    // Fetch permission types
    const permissionTypesResponse = await apiInstance.get('/permissiontypes', {
      headers: { Authorization: `Bearer ${localStorage.getItem('token')}` },
    })
    const permissionTypes = Array.isArray(permissionTypesResponse.data.data)
      ? permissionTypesResponse.data.data
      : permissionTypesResponse.data || []

    // Define color palette for bars
    const colorPalette = [
      '#FF6384', // Red
      '#36A2EB', // Blue
      '#FFCE56', // Yellow
      '#4BC0C0', // Cyan
      '#9966FF', // Purple
      '#FF9F40', // Orange
    ]

    // Count permission requests by type
    const typeCounts = {}
    permissionTypes.forEach(type => {
      typeCounts[type.id] = { name: type.name, count: 0 }
    })
    permissions.forEach(permission => {
      if (permission.permission_type_id && typeCounts[permission.permission_type_id]) {
        typeCounts[permission.permission_type_id].count++
      }
    })

    // Prepare data for bar chart
    const labels = Object.values(typeCounts).map(type => type.name)
    const data = Object.values(typeCounts).map(type => type.count)
    const backgroundColors = labels.map((_, index) => colorPalette[index % colorPalette.length])
    const borderColors = backgroundColors

    userStatsData.value = {
      labels,
      datasets: [
        {
          label: 'Permission Requests by Type',
          backgroundColor: backgroundColors,
          borderColor: borderColors,
          data,
        },
      ],
    }

    // Update permission status counts for pie chart
    const statusCounts = {
      pending: 0,
      approved: 0,
      rejected: 0,
    }
    permissions.forEach(permission => {
      if (permission.status in statusCounts) {
        statusCounts[permission.status.toLowerCase()]++
      }
    })

    permissionData.value = {
      labels: ['Pending', 'Approved', 'Rejected'],
      datasets: [
        {
          data: [statusCounts.pending, statusCounts.approved, statusCounts.rejected],
          backgroundColor: ['#FFCE56', '#36A2EB', '#FF6384'],
          hoverOffset: 4,
        },
      ],
    }
  } catch (error) {
    console.error('Error fetching dashboard data:', error)
  }
}

onMounted(fetchDashboardData)
</script>