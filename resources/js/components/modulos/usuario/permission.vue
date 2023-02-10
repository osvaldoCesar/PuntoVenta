<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Asignar Permiso</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/usuario'">
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
                                        <h3 class="card-title">Listar Permisos del Rol {{ fillPermiso.cNombreRol }}</h3>
                                    </div>
                                    <div class="card-body table-responsive">
                                        <template v-if="listPermisosByRolAsignado.length">
                                            <div class="scrollTable">
                                                <table class="table table-hover table-head-fixed text-nowrap">
                                                    <thead>
                                                        <tr>
                                                            <th>Nombre</th>
                                                            <th>Url amigable</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="(item, index) in listPermisosByRolAsignado" :key="index" @click.prevent="marcarFila(index)">
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
                                    <div class="card-footer">
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="setRegistrarPermisosByUsuario"
                                        v-loading.fullscreen.lock="fullscreenLoading">Registrar</button>
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
                        <h5 class="modal-title">Sistema Laravel y Vue</h5>
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
                fillPermiso: {
                    nIdUsuario: this.$attrs.id,
                    cNombreRol: '',
                },
                listPermisosByRolAsignado: [],
                listPermisos: [],
                listPermisosFilter: [],
                listRolPermisosByUsuario: [],
                listRolPermisosByUsuarioFilter: [],
                fullscreenLoading: false,
                modalShow: false,
                mostrarModal: {
                    display: 'block',
                    background: '#0000006b',
                },
                ocultarModal: {
                    display: 'none',
                },
                error: 0,
                mensajeError: []
            }
        },
        computed: {

        },
        mounted (){
            this.getListarPermisosByRolAsignado();
            this.getRolByUsuario();
            this.getListarPermisosByUsuario();
        },
        methods: {
            limpiarCriterios(){
                this.fillPermiso.cNombre  = '';
                this.fillPermiso.cSlug = '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            getListarPermisosByRolAsignado(){
                var ruta = '/administracion/usuario/getListarPermisosByRolAsignado';
                axios.get(ruta, {
                    params: {
                        'nIdUsuario'    :   this.fillPermiso.nIdUsuario,
                    }
                }).then(response => {
                    this.listPermisosByRolAsignado = response.data;
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                });
            },
            getRolByUsuario(){
                var url = '/administracion/usuario/getRolByUsuario'
                axios.get(url, {
                    params: {
                        'nIdUsuario' : this.fillPermiso.nIdUsuario
                    }
                }).then(response => {
                    this.fillPermiso.cNombreRol = (response.data.length == 0) ? '' : response.data[0].name;
                    this.fullscreenLoading = false;
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                });
            },
            getListarPermisosByUsuario(){
                var ruta = '/administracion/usuario/getListarPermisosByUsuario';
                axios.get(ruta, {
                    params: {
                        'nIdUsuario' : this.fillPermiso.nIdUsuario
                    }
                }).then(response => {
                    this.listPermisos = response.data;
                    this.filterPermisosByUsuario();
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                });
            },
            filterPermisosByUsuario(){
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
            setRegistrarPermisosByUsuario(){
                if (this.validarRegistrarPermisosByUsuario()) {
                    this.modalShow = true;
                    return;
                }
                this.fullscreenLoading = true;
                console.log(this.fillPermiso.listPermisosFilter);
                var url = '/administracion/usuario/setRegistrarPermisosByUsuario'
                axios.post(url, {
                    'nIdUsuario'             :  this.fillPermiso.nIdUsuario,
                    'listPermisosFilter'  :  this.listPermisosFilter
                }).then(response => {
                    this.getListarRolPermisosByUsuario();

                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
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
                        this.fullscreenLoading = false;
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
                Swal.fire({
                    icon: 'success',
                    title: 'Se otorgaron los permisos al usuario correctamente',
                    showConfirmButton: false,
                    timer: 1500
                })
            },
            validarRegistrarPermisosByUsuario(){
                this.error = 0;
                this.mensajeError = [];
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
