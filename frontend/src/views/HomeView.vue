<template>
  <div class="container mx-auto p-4">
    <div class="grid grid-cols-4 gap-4 mb-4">
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
          <div class="bg-purple-500 text-white w-12 h-12 flex items-center justify-center rounded mr-4">
            <font-awesome-icon icon="fa-check-circle" class="text-xl" />
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
    <div class="grid grid-cols-2 gap-4">
      <div class="bg-white p-4 rounded-lg shadow">
        <h3 class="text-lg mb-2">User Statistics</h3>
        <div style="position: relative; height: 300px;">
          <Line :data="userStatsData" :options="chartOptions" />
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
        </div>
      </div>
      <div class="text-right">
        <p class="text-2xl font-bold text-gray-800">17</p>
        <p class="text-sm text-gray-500">+5%</p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { Line } from 'vue-chartjs';
import { Pie } from 'vue-chartjs';
import { Chart as ChartJS, Title, Tooltip, Legend, LineElement, PointElement, LinearScale, CategoryScale, ArcElement } from 'chart.js';
import apiInstance from '@/plugin/axios';

ChartJS.register(Title, Tooltip, Legend, LineElement, PointElement, LinearScale, CategoryScale, ArcElement);

// Reactive variables for API data
const totalUsers = ref(0);
const totalEmployees = ref(0);
const totalManagers = ref(0);
const totalDepartments = ref(0);
const permissionData = ref({
  labels: ['Pending', 'Approved', 'Rejected'],
  datasets: [
    {
      data: [0, 0, 0],
      backgroundColor: ['#FFCE56', '#36A2EB', '#FF6384'],
      hoverOffset: 4,
    },
  ],
});

// Fetch data from API
const fetchDashboardData = async () => {
  try {
    // Fetch users
    const usersResponse = await apiInstance.get('/users');
    const users = usersResponse.data.users || [];
    totalUsers.value = users.length;
    totalEmployees.value = users.filter(user => user.role_id === 4).length; // Employee role_id
    totalManagers.value = users.filter(user => user.role_id === 3).length; // Manager role_id

    // Fetch departments
    const departmentsResponse = await apiInstance.get('/department');
    totalDepartments.value = departmentsResponse.data.department.length;

    // Fetch permission requests
    const permissionsResponse = await apiInstance.get('/permissionrequests');
    const permissions = permissionsResponse.data || [];

    // Sum the status counts
    const statusCounts = {
      pending: 0,
      approved: 0,
      rejected: 0,
    };

    permissions.forEach(permission => {
      if (permission.status in statusCounts) {
        statusCounts[permission.status]++;
      }
    });

    // Update permissionData for the Pie chart
    permissionData.value = {
      labels: ['Pending', 'Approved', 'Rejected'],
      datasets: [
        {
          data: [statusCounts.pending, statusCounts.approved, statusCounts.rejected],
          backgroundColor: ['#FFCE56', '#36A2EB', '#FF6384'],
          hoverOffset: 4,
        },
      ],
    };
  } catch (error) {
    console.error('Error fetching dashboard data:', error);
  }
};

// Call fetchDashboardData when component is mounted
onMounted(fetchDashboardData);

// User statistics chart data (unchanged since no API data provided for this)
const userStatsData = ref({
  labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
  datasets: [
    {
      label: 'Subscribers',
      backgroundColor: 'rgba(255, 99, 132, 0.2)',
      borderColor: 'rgb(255, 99, 132)',
      data: [200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700, 750],
      fill: true,
    },
    {
      label: 'New Visitors',
      backgroundColor: 'rgba(255, 206, 86, 0.2)',
      borderColor: 'rgb(255, 206, 86)',
      data: [150, 200, 250, 300, 350, 400, 450, 500, 550, 600, 650, 700],
      fill: true,
    },
    {
      label: 'Active Users',
      backgroundColor: 'rgba(54, 162, 235, 0.2)',
      borderColor: 'rgb(54, 162, 235)',
      data: [300, 350, 400, 450, 500, 550, 600, 650, 700, 750, 800, 850],
      fill: true,
    },
  ],
});

const chartOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
});

const permissionOptions = ref({
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: {
      display: true, // Show the legend
      position: 'bottom',
    },
    title: {
      display: true,
      text: 'Permission Status',
    },
    tooltip: {
      enabled: true,
      callbacks: {
        label: function(context) {
          let label = context.label || '';
          let value = context.raw || 0;
          return `${label}: ${value}`;
        },
      },
    },
  },
});
</script>