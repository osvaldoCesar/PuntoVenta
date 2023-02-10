<template>
    <div>
        <!-- Navbar -->
        <Navbar :ruta="ruta" :usuario="authUser" :listPermisos="listRolPermisosByUsuario"></Navbar>
        <!-- /.navbar -->

        <!-- Main Sidebar Container -->
        <Sidebar :ruta="ruta" :usuario="authUser" :listPermisos="listRolPermisosByUsuario"></Sidebar>

        <!-- Contenido Principal del Sitio Web -->
        <div class="content-wrapper">
            <transition name="slide-fade" mode="out-in">
                <router-view></router-view>
            </transition>
        </div>
        <!-- /.content-wrapper -->

        <Footer></Footer>

        <!-- Control Sidebar -->
        <aside class="control-sidebar control-sidebar-dark">
            <!-- Control sidebar content goes here -->
        </aside>
        <!-- /.control-sidebar -->
    </div>
</template>

<script>
    import Navbar from './plantilla/Navbar';
    import Sidebar from './plantilla/Sidebar';
    import Footer from './plantilla/Footer';

    export default {
        props: ['ruta', 'usuario'],
        components: {Navbar, Sidebar, Footer},
        data() {
            return {
                authUser: this.usuario,
                listRolPermisosByUsuario: [],
            }
        },
        mounted() {
            // console.log( JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario')) );

            this.listRolPermisosByUsuario   =   JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario'));

            EventBus.$on('verifyAuthenticatedUser', data => {
                // console.log('Evento ejecutado desde el Componente App.vue');
                // console.log(data);
                this.authUser = data;
            })
            EventBus.$on('notifyRolPermisosByUsuario', data => {
                this.listRolPermisosByUsuario = data;
            })
        },
    }
</script>

<style>

</style>
