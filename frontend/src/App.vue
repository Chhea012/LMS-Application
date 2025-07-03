<template>
  <div class="flex h-screen">
    <Sidebar :isVisible="true" />
    <main class="flex-1 overflow-y-auto">
      <router-view />
    </main>
  </div>
  <!-- root router outlet only -->
  <RouterView />
</template>
