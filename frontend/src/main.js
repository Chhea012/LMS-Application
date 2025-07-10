import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import 'boxicons/css/boxicons.min.css'
import './assets/main.css'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'
import { library } from '@fortawesome/fontawesome-svg-core'
import { faUsers, faUser, faBuilding, faCheckCircle } from '@fortawesome/free-solid-svg-icons'

library.add(faUsers, faUser, faBuilding, faCheckCircle)

const app = createApp(App)
app.component('font-awesome-icon', FontAwesomeIcon)
app.use(router)
app.mount('#app')