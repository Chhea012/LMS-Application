import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'
import router from './router'
import installFontAwesome from './plugin/icons';
import 'boxicons/css/boxicons.min.css';

const app = createApp(App)

app.use(router)
installFontAwesome(app);

app.mount('#app')
