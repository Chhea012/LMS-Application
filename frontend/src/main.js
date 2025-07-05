// Import global styles
import '/src/assets/main.css'

// Vue and router imports
import { createApp } from 'vue'
import App from '/src/App.vue'
import router from '/src/router/index.js'

// FontAwesome plugin import (assuming you have this setup)
import installFontAwesome from '/src/plugin/icons.js'

// Import Boxicons CSS the right way (npm package import)
import 'boxicons/css/boxicons.min.css'

const app = createApp(App)

// Use your router and FontAwesome plugin
app.use(router)
installFontAwesome(app)

// Mount the Vue app to the DOM
app.mount('#app')
