require('./bootstrap');

window.Vue = require('vue');
// ElementUI - biblioteca inferfaz de usuario
import ElementUI from 'element-ui';
import 'element-ui/lib/theme-chalk/index.css';
import locale from 'element-ui/lib/locale/lang/es'

Vue.use(ElementUI, { locale })
// SweetAlert2 - Ventanas emergentes
import Swal from 'sweetalert2';
window.Swal = Swal;
// Vuesax - biblioteca inferfaz de usuario
import Vuesax from 'vuesax'
import 'vuesax/dist/vuesax.css' //Vuesax styles
Vue.use(Vuesax, {
// options here
})
// EventBus -  biblioteca para comunicación entre componentes
export const EventBus = new Vue();
window.EventBus = EventBus;

Vue.component('App', require('./components/App.vue').default);
Vue.component('Auth', require('./components/Auth.vue').default);

import router from './routes'

const app = new Vue({
    el: '#app',
    router
});
