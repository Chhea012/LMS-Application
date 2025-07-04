<template>
  <div class="h-screen overflow-y-auto bg-gray-50 scrollbar-hide">
    <div class="p-6">
      <!-- Header -->
      <header class="mb-8">
        <h1 class="text-3xl font-bold text-gray-900">Welcome to the LMS Dashboard</h1>
        <p class="text-gray-600 mt-1">Manage your Permission Management System efficiently.</p>
      </header>

      <!-- Cards -->
      <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-10">
        <!-- Departments Card -->
        <div class="p-6 bg-white rounded-lg shadow border border-gray-200 hover:shadow-lg transition-shadow">
          <h2 class="text-xl font-semibold text-gray-700">Departments</h2>
          <p class="text-gray-500 mt-2">Manage all departments in your system.</p>
          <button class="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">Go to Departments</button>
        </div>

        <!-- Permissions Card -->
        <div class="p-6 bg-white rounded-lg shadow border border-gray-200 hover:shadow-lg transition-shadow">
          <h2 class="text-xl font-semibold text-gray-700">Permissions</h2>
          <p class="text-gray-500 mt-2">Track and handle permission requests.</p>
          <button class="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">View Permissions</button>
        </div>

        <!-- Users Card -->
        <div class="p-6 bg-white rounded-lg shadow border border-gray-200 hover:shadow-lg transition-shadow">
          <h2 class="text-xl font-semibold text-gray-700">Users</h2>
          <p class="text-gray-500 mt-2">View and manage user accounts. Admin can see all.</p>
          <button class="mt-4 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700 transition">Manage Users</button>
        </div>
      </div>

      <!-- Statistics -->
      <section class="mb-10">
        <h3 class="text-2xl font-semibold text-gray-800 mb-4">Statistics</h3>
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-6">
          <div class="bg-white rounded-lg shadow border border-gray-200 p-6 text-center">
            <p class="text-4xl font-bold text-blue-600">12</p>
            <p class="text-gray-600 mt-1">Active Departments</p>
          </div>
          <div class="bg-white rounded-lg shadow border border-gray-200 p-6 text-center">
            <p class="text-4xl font-bold text-green-600">34</p>
            <p class="text-gray-600 mt-1">Pending Permissions</p>
          </div>
          <div class="bg-white rounded-lg shadow border border-gray-200 p-6 text-center">
            <p class="text-4xl font-bold text-purple-600">102</p>
            <p class="text-gray-600 mt-1">Registered Users</p>
          </div>
        </div>
      </section>

      <!-- Recent Activity and Quick Actions -->
      <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-12">
        <!-- Recent Activity -->
        <section class="lg:col-span-2 bg-white rounded-lg shadow border border-gray-200 p-6">
          <h3 class="text-2xl font-semibold text-gray-800 mb-4">Recent Activity</h3>
          <ul class="divide-y divide-gray-200 max-h-72 overflow-y-auto scrollbar-hide">
            <li class="py-3">
              <p class="text-gray-700"><span class="font-semibold">User John Doe</span> requested permission.</p>
              <p class="text-xs text-gray-500">2 hours ago</p>
            </li>
            <li class="py-3">
              <p class="text-gray-700"><span class="font-semibold">Department Finance</span> was updated.</p>
              <p class="text-xs text-gray-500">5 hours ago</p>
            </li>
            <li class="py-3">
              <p class="text-gray-700"><span class="font-semibold">New user Jane Smith</span> was added.</p>
              <p class="text-xs text-gray-500">1 day ago</p>
            </li>
          </ul>
        </section>

        <!-- Quick Actions -->
        <section class="bg-white rounded-lg shadow border border-gray-200 p-6 flex flex-col justify-center gap-4">
          <h3 class="text-2xl font-semibold text-gray-800">Quick Actions</h3>
          <button class="w-full px-4 py-3 bg-blue-600 text-white rounded hover:bg-blue-700 transition">
            Create New Department
          </button>
          <button class="w-full px-4 py-3 bg-green-600 text-white rounded hover:bg-green-700 transition">
            Approve Permissions
          </button>
          <button class="w-full px-4 py-3 bg-purple-600 text-white rounded hover:bg-purple-700 transition">
            Add New User
          </button>
        </section>
      </div>
    </div>
  </div>
</template>

<script setup>
// No extra logic needed for scroll hiding
</script>

<style scoped>
.scrollbar-hide::-webkit-scrollbar {
  display: none;
}
.scrollbar-hide {
  -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;     /* Firefox */
}
</style>
