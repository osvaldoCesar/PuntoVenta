<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Editar Rol</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/rol'">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </router-link>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="row">
                            <div class="col-md-5">
                                <div class="card card-info">
                                    <div class="card-header">
                                        <h3 class="card-title">Formulario Editar Rol</h3>
                                    </div>
                                    <div class="card-body">
                                        <form role="form">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-3 col-form-label">Nombre</label>
                                                        <div class="col-md-9">
                                                            <input type="text" class="form-control" v-model="fillEditarRol.cNombre" @keyup.enter="setEditarRolPermisos">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-3 col-form-label">Url Amigable</label>
                                                        <div class="col-md-9">
                                                            <input type="text" class="form-control" v-model="fillEditarRol.cSlug" @keyup.enter="setEditarRolPermisos">
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer">
                                        <div class="row">
                                            <button class="btn btn-flat btn-info btnWidth" @click.prevent="setEditarRolPermisos" v-loading.fullscreen.lock="fullscreenLoading">Editar</button>
                                            <button class="btn btn-flat btn-default btnWidth" @click.prevent="limpiarCriterios">Limpiar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-7">
                                <div class="card card-info">
                                    <div class="card-header">
                                        <h3 class="card-title">Listar Permisos</h3>
                                    </div>
                                    <div class="card-body table-responsive">
                                        <template v-if="listPermisosFilter.length">
                                            <div class="scrollTable">
                                                <table class="table table-hover table-head-fixed text-nowrap">
                                                    <thead>
                                                        <tr>
                                                            <th>Acción</th>
                                                            <th>Nombre</th>
                                                            <th>Url amigable</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="(item, index) in listPermisosFilter" :key="index" @click.prevent="marcarFila(index)">
                                                            <td>
                                                                <!-- Irán los checkbox para seleccionar los permisos que se le asignarán -->
                                                                <el-checkbox v-model="item.checked"></el-checkbox>
                                                            </td>
                                                            <td v-text="item.name"></td>
                                                            <td v-text="item.slug"></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </template>
                                        <template v-else>
                                            <div class="callout callout-info">
                                                <h5>No se encontraron registros...</h5>
                                            </div>
                                        </template>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" :class="{ show: modalShow }" :style=" modalShow ? mostrarModal : ocultarModal">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">Punto de venta</h5>
                        <button class="close" @click="abrirModal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="callout callout-danger" style="padding: 5px" v-for="(item, index) in mensajeError" :key="index" v-text="item"></div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-secondary" @click="abrirModal">Cerrar</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import axios from 'axios';
    export default {
        data() {
            return {
                fillEditarRol: {
                    nIdRol: this.$attrs.id,
                    cNombre: '',
                    cSlug: '',
                },
                listPermisos: [],
                listPermisosFilter: [],
                listRolPermisosByUsuario: [],
                listRolPermisosByUsuarioFilter: [],
                fullscreenLoading: false,
                modalShow: false,
                mostrarModal: {
                    display: 'block',
                    bacground: '#0000006b',
                },
                ocultarModal: {
                    display: 'none',
                },
                error: 0,
                mensajeError: [],
                notificacion: '',
            }
        },
        computed: {

        },
        mounted (){
            this.getListarRoles();
            this.getListarPermisosByRol();
        },
        methods: {
            limpiarCriterios(){
                this.fillEditarRol.cNombre  = '';
                this.fillEditarRol.cSlug = '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            getListarRoles(){
                var url = '/administracion/rol/getListarRoles'
                axios.get(url, {
                    params: {
                        'nIdRol'  : this.fillEditarRol.nIdRol
                    }
                }).then(response => {
                    this.fillEditarRol.cNombre  =   response.data[0].name;
                    this.fillEditarRol.cSlug    =   response.data[0].slug;
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                    }
                });
            },
            getListarPermisosByRol(){
                var ruta = '/administracion/rol/getListarPermisosByRol';
                axios.get(ruta, {
                    params: {
                        'nIdRol'  : this.fillEditarRol.nIdRol
                    }
                }).then(response => {
                    this.listPermisos = response.data;
                    this.filterPermisosByRol();
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                    }
                });
            },
            filterPermisosByRol(){
                let me = this;
                me.listPermisos.map(function(x, y){
                    me.listPermisosFilter.push({
                        'id'        :   x.id,
                        'name'      :   x.name,
                        'slug'      :   x.slug,
                        'checked'   :   (x.checked == 1) ? true : false
                    });
                });
            },
            marcarFila(index){
                this.listPermisosFilter[index].checked = !this.listPermisosFilter[index].checked;
            },
            setEditarRolPermisos(){
                if (this.validarEditarRolPermisos()) {
                    this.modalShow = true;
                    return;
                }

                var url = '/administracion/rol/setEditarRolPermisos'
                axios.post(url, {
                    'nIdRol'              :  this.fillEditarRol.nIdRol,
                    'cNombre'             :  this.fillEditarRol.cNombre,
                    'cSlug'               :  this.fillEditarRol.cSlug,
                    'listPermisosFilter'  :  this.listPermisosFilter
                }).then(response => {
                    this.getListarRolPermisosByUsuario();
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                    }
                });
            },
            getListarRolPermisosByUsuario(){
                var ruta = '/administracion/usuario/getListarRolPermisosByUsuario';
                axios.get(ruta).then(response => {
                    this.listRolPermisosByUsuario = response.data;
                    this.filterListarRolPermisosByUsuario();
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                    }
                });
            },
            filterListarRolPermisosByUsuario(){
                let me = this;
                this.listRolPermisosByUsuarioFilter = [];
                me.listRolPermisosByUsuario.map(function(x, y){
                    me.listRolPermisosByUsuarioFilter.push(x.slug);
                });

                sessionStorage.setItem("listRolPermisosByUsuario", JSON.stringify(me.listRolPermisosByUsuarioFilter));
                EventBus.$emit('notifyRolPermisosByUsuario', me.listRolPermisosByUsuarioFilter);
                this.fullscreenLoading = false;
                this.notificacion = this.$vs.notification({
                    title: 'Notificación Punto de venta',
                    text: 'Se actualizó el rol correctamente',
                    color: 'success',
                })
                setTimeout(() => {
                    notificacion.toggleClass('new-class')
                }, 2000)
                this.$router.push('/rol');
            },
            validarEditarRolPermisos(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillEditarRol.cNombre) {
                    this.mensajeError.push("El Nombre es un campo obligatorio");
                }
                if (!this.fillEditarRol.cSlug) {
                    this.mensajeError.push("La URL Amigable es un campo obligatorio");
                }

                let contador = 0;
                this.listPermisosFilter.map(function(x, y){
                    if (x.checked == true) {
                        contador++;
                    }
                })

                if (contador == 0) {
                    this.mensajeError.push("Debe seleccionar al menos un permiso");
                }

                if (this.mensajeError.length){
                    this.error = 1;
                }
                return this.error;
            }
        }
    }
</script>

<style>

</style>
