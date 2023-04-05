import axios from 'axios';
<template>
    <aside class="main-sidebar sidebar-dark-primary elevation-4 sidebar-no-expand">
        <!-- Brand Logo -->
        <a href="#" class="brand-link">
            <vs-avatar circle>
                <img :src="ruta + '/img/adminLTELogo.png'" alt="Punto de venta Welldent">
            </vs-avatar>
            <!-- <img :src="ruta + '/img/adminLTELogo.png'" alt="Punto de venta Welldent" class="brand-image img-circle elevation-3" style="opacity: .8"> -->
            <span class="brand-text font-weight-light">Punto de venta</span>
        </a>
        <!-- Sidebar -->
        <div class="sidebar">
            <!-- Sidebar user (optional) -->
            <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                <div class="image">
                    <template v-if="!usuario.file_id">
                        <vs-avatar circle>
                            <img :src="ruta + '/img/avatar.png'" :alt="usuario.fullname">
                        </vs-avatar>
                        <!-- <img :src="ruta + '/img/avatar.png'" class="img-circle elevation-2" :alt="usuario.fullname"> -->
                    </template>
                    <template v-else>
                        <vs-avatar circle>
                            <img :src="usuario.file.path" :alt="usuario.fullname">
                        </vs-avatar>
                        <!-- <img :src="usuario.file.path" class="img-circle elevation-2" :alt="usuario.fullname" style="height: 34px !important"> -->
                    </template>
                </div>
                <div class="info">
                    <router-link class="d-block" :to="{name:'usuario.ver', params:{id: usuario.id}}">
                        {{usuario.fullname}}
                    </router-link>
                </div>
            </div>

            <div class="user-panel mt-3 pb-3 mb-3 d-flex">
                <div class="info">
                    <a href="#" class="d-block" @click.prevent="logout" v-loading.fullscreen.lock="fullscreenLoading">
                        <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
                    </a>
                </div>
            </div>

            <!-- Sidebar Menu -->
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu" data-accordion="false">
                    <li class="nav-item has-treeview menu-open">
                        <template v-if="listPermisos.includes('dashboard.index')">
                            <router-link :to="'/'" class="nav-link active">
                                <i class="nav-icon fas fa-tachometer-alt"></i>
                                <p>Dashboard</p>
                            </router-link>
                        </template>
                    </li>
                    <template v-if="listPermisos.includes('pedido.index', 'cliente.index', 'doctor.index')">
                        <li class="nav-header">OPERACIONES</li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('pedido.index')">
                                <router-link :to="'/pedido'" class="nav-link">
                                    <i class="nav-icon fas fa-cash-register"></i>
                                    <p>Pedidos</p>
                                </router-link>
                            </template>
                        </li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('tecnico.index')">
                                <router-link :to="'/tecnico'" class="nav-link">
                                    <i class="nav-icon fa-solid fa-tooth"></i>
                                    <p>Técnicos</p>
                                </router-link>
                            </template>
                        </li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('doctor.index')">
                                <router-link :to="'/doctor'" class="nav-link">
                                    <i class="nav-icon fas fa-user-friends"></i>
                                    <p>Doctores</p>
                                </router-link>
                            </template>
                        </li>
                    </template>

                    <template v-if="listPermisos.includes('categoria.index', 'producto.index')">
                        <li class="nav-header">CONFIGURACIÓN</li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('categoria.index')">
                                <router-link :to="'/categoria'" class="nav-link">
                                    <i class="fas fa-sitemap nav-icon"></i>
                                    <p>Categorías</p>
                                </router-link>
                            </template>
                        </li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('producto.index')">
                                <router-link :to="'/producto'" class="nav-link">
                                    <i class="fas fa-apple-alt nav-icon"></i>
                                    <p>Productos</p>
                                </router-link>
                            </template>
                        </li>
                    </template>

                    <template v-if="listPermisos.includes('usuario.index', 'rol.index', 'permiso.index')">
                        <li class="nav-header">ADMINISTRACIÓN</li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('usuario.index')">
                                <router-link :to="'/usuario'" class="nav-link">
                                    <i class="nav-icon fas fa-users"></i>
                                    <p>Usuarios</p>
                                </router-link>
                            </template>
                        </li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('rol.index')">
                                <router-link :to="'/rol'" class="nav-link">
                                    <i class="nav-icon fas fa-unlock-alt"></i>
                                    <p>Roles</p>
                                </router-link>
                            </template>
                        </li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('permiso.index')">
                                <router-link :to="'/permiso'" class="nav-link">
                                    <i class="nav-icon fas fa-key"></i>
                                    <p>Permisos</p>
                                </router-link>
                            </template>
                        </li>
                    </template>

                    <template v-if="listPermisos.includes('reporte.pedido.index')">
                        <li class="nav-header">REPORTES</li>
                        <li class="nav-item">
                            <template v-if="listPermisos.includes('reporte.pedido.index')">
                                <router-link :to="'/reporte'" class="nav-link">
                                    <i class="nav-icon fas fa-file-export"></i>
                                    <p>Pedidos</p>
                                </router-link>
                            </template>
                        </li>
                    </template>
                </ul>
            </nav>
        <!-- /.sidebar-menu -->
        </div>
    <!-- /.sidebar -->
    </aside>
</template>

<script>
    export default {
        props: ['ruta', 'usuario', 'listPermisos'],
        data() {
            return {
                fullscreenLoading: false,
            }
        },
        mounted() {
            Echo.private(`logout.user.${this.usuario.id}`)
                .listen('Logout', (e) => {
                    // console.log(e)
                    this.logout();
                });
        },
        methods: {
            logout(){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Cerrando sesión...'
                })
                var url = '/authenticate/logout'
                axios.post(url).then(response => {
                    if (response.data.code == 204) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        loading.close()
                    }
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        loading.close()
                    }
                });
            }
        },
    }
</script>
<style>

</style>
