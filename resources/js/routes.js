import Vue from 'vue'
import Router from 'vue-router'

Vue.use(Router)

function verificarAcceso(to, from ,next){
    let authUser = JSON.parse(sessionStorage.getItem('authUser'));
    if (authUser) {
        let listRolPermisosByUsuario = JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario'));
        if (listRolPermisosByUsuario.includes(to.name)) {
            next();
        }else{
            let listRolPermisosByUsuarioFilter = [];
            listRolPermisosByUsuario.map(function(x){
                if(x.includes('index')){
                    listRolPermisosByUsuarioFilter.push(x);
                }
            })
            if (to.name == 'dashboard.index') {
                next({name:listRolPermisosByUsuarioFilter[0]});
            }else{
                next(from.path)
            }
        }
    }else{
        next('/login');
    }
}

export const rutas = [
    // Login
    {
        path: '/login',
        name: 'login',
        component: require('./components/modulos/authenticate/login').default,
        beforeEnter: (to, from, next) => {
            let authUser = JSON.parse(sessionStorage.getItem('authUser'));
            if (authUser) {
                next({ name: 'dashboard.index'});
            } else {
                next();
            }
        }
    },

    // Dashboard
    {path: '/', name: 'dashboard.index', component: require('./components/modulos/dashboard/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },

    /* Pedidos */
    // Index
    {path: '/pedido', name: 'pedido.index', component: require('./components/modulos/pedido/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Crear
    {path: '/pedido/crear', name: 'pedido.crear', component: require('./components/modulos/pedido/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Abonar a pedido
    {
        path: '/pedido/abonar/:id',
        name: 'pedido.abonar',
        component: require('./components/modulos/pedido/credit').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },

    /* Clientes */
    // Index
    {path: '/cliente', name: 'cliente.index', component: require('./components/modulos/cliente/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Crear
    {path: '/cliente/crear', name: 'cliente.crear', component: require('./components/modulos/cliente/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Editar
    {
        path: '/cliente/editar/:id',
        name: 'cliente.editar',
        component: require('./components/modulos/cliente/edit').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },

    /* Categorías */
    // Index
    {path: '/categoria', name: 'categoria.index', component: require('./components/modulos/categoria/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Registrar
    {
        path: '/categoria/crear',
        name: 'categoria.crear',
        component: require('./components/modulos/categoria/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Editar
    {
        path: '/categoria/editar/:id',
        name: 'categoria.editar',
        component: require('./components/modulos/categoria/edit').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },

    /* Productos */
    {path: '/producto', name: 'producto.index', component: require('./components/modulos/producto/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Registrar
    {
        path: '/producto/crear',
        name: 'producto.crear',
        component: require('./components/modulos/producto/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Editar
    {
        path: '/producto/editar/:id',
        name: 'producto.editar',
        component: require('./components/modulos/producto/edit').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from, next);
        },
        props: true
    },

    /* Usuarios */
    {path: '/usuario', name: 'usuario.index', component: require('./components/modulos/usuario/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Crear
    {path: '/usuario/crear', name: 'usuario.crear', component: require('./components/modulos/usuario/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Editar
    {
        path: '/usuario/editar/:id',
        name: 'usuario.editar',
        component: require('./components/modulos/usuario/edit').default,
        props: true,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    {
        path: '/usuario/ver/:id',
        name: 'usuario.ver',
        component: require('./components/modulos/usuario/view').default,
        props: true,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    {
        path: '/usuario/permiso/:id',
        name: 'usuario.permiso',
        component: require('./components/modulos/usuario/permission').default,
        props: true,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },

    /* Roles */
    {path: '/rol', name: 'rol.index', component: require('./components/modulos/rol/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    {path: '/rol/crear', name: 'rol.crear', component: require('./components/modulos/rol/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    {
        path: '/rol/editar/:id',
        name: 'rol.editar',
        component: require('./components/modulos/rol/edit').default,
        props: true,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },

    // Permisos
    {path: '/permiso', name: 'permiso.index', component: require('./components/modulos/permiso/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    {path: '/permiso/crear', name: 'permiso.crear', component: require('./components/modulos/permiso/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    {
        path: '/permiso/editar/:id',
        name: 'permiso.editar',
        component: require('./components/modulos/permiso/edit').default,
        props: true,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },

    /* Técnicos */
    // Index
    {path: '/tecnico', name: 'tecnico.index', component: require('./components/modulos/tecnico/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Crear
    {path: '/tecnico/crear', name: 'tecnico.crear', component: require('./components/modulos/tecnico/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Editar
    {
        path: '/tecnico/editar/:id',
        name: 'tecnico.editar',
        component: require('./components/modulos/tecnico/edit').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },

    /* Doctores */
    // Index
    {path: '/doctor', name: 'doctor.index', component: require('./components/modulos/doctor/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Crear
    {path: '/doctor/crear', name: 'doctor.crear', component: require('./components/modulos/doctor/create').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        }
    },
    // Editar
    {
        path: '/doctor/editar/:id',
        name: 'doctor.editar',
        component: require('./components/modulos/doctor/edit').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },
    // Ver Pacientes
    {
        path: '/doctor/verPacientes/:id',
        name: 'paciente.ver',
        component: require('./components/modulos/doctor/viewPatients').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },
    // Crear Pacientes
    {
        path: '/doctor/crearPacientes/:id',
        name: 'paciente.crear',
        component: require('./components/modulos/doctor/createPatients').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from ,next);
        },
        props: true,
    },


    // Reportes
    {
        path: '/reporte',
        name: 'reporte.pedido.index',
        component: require('./components/modulos/reporte/index').default,
        beforeEnter: (to, from, next) => {
            verificarAcceso(to, from, next);
        }
    },

    // Error 404
    {
        path: '*',
        component: require('./components/plantilla/404').default
    }
]

export default new Router({
    routes: rutas,
    mode: 'history',
    linkActiveClass: 'active',
})
