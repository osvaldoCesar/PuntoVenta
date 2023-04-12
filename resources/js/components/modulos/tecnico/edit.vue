<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Editar Técnico</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/tecnico'">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </router-link>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="card card-info" >
                            <div class="card-header">
                                <h3 class="card-title">Formulario Editar Tecnico</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">RFC</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control" v-model="fillEditarTecnico.tRfc" @keyup.enter="setEditarTecnico">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Nombre</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control"
                                                    v-model="fillEditarTecnico.tNombre"
                                                    @keyup.enter="setEditarTecnico">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Apellido</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control"
                                                    v-model="fillEditarTecnico.tApellido"
                                                    @keyup.enter="setEditarTecnico">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Email</label>
                                                <div class="col-md-12">
                                                    <vs-input v-model="fillEditarTecnico.tEmail"
                                                            placeholder="correo@gmail.com"
                                                            @keyup.enter="setEditarTecnico">
                                                        <template v-if="valitEmail" #message-success>Correo Electrónico válido</template>
                                                        <template v-if="!valitEmail && fillEditarTecnico.tEmail !== ''" #message-danger>Correo Electrónico inválido</template>
                                                    </vs-input>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Teléfono</label>
                                                <div class="col-md-12">
                                                    <input type="tel" class="form-control"
                                                    v-model="fillEditarTecnico.tTelefono"
                                                    @keyup.enter="setEditarTecnico">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-4 offset-4">
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="setEditarTecnico" v-loading.fullscreen.lock="fullscreenLoading">Editar</button>
                                        <button class="btn btn-flat btn-default btnWidth" @click.prevent="limpiarCriterios">Limpiar</button>
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
import { nextTick } from 'vue';
    export default {
        data() {
            return {
                fillEditarTecnico: {
                    nIdTecnico: this.$attrs.id,
                    tRfc: '',
                    tNombre: '',
                    tApellido: '',
                    tEmail: '',
                    tTelefono: '',
                },
                fullscreenLoading: false,
                loading: '',
                modalShow: false,
                mostrarModal: {
                    display: 'block',
                    background: '#0000006b',
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
            valitEmail() {
                return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.fillEditarTecnico.tEmail)
            }
        },
        mounted(){
            this.getListarTecnicos();
        },
        methods: {
            limpiarCriterios(){
                this.fillEditarTecnico.tRfc          = '';
                this.fillEditarTecnico.tNombre       = '';
                this.fillEditarTecnico.tApellido     = '';
                this.fillEditarTecnico.tEmail        = '';
                this.fillEditarTecnico.tTelefono     = '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            getListarTecnicos(){
                this.fullscreenLoading = true;
                var url = '/operacion/tecnico/getListarTecnicos'
                axios.get(url, {
                    params: {
                        'nIdTecnico'  : this.fillEditarTecnico.nIdTecnico
                    }
                }).then(response => {
                    console.log(response.data[0].rfc);
                    this.fillEditarTecnico.tRfc          = response.data[0].rfc;
                    this.fillEditarTecnico.tNombre       = response.data[0].name;
                    this.fillEditarTecnico.tApellido     = response.data[0].lastname;
                    this.fillEditarTecnico.tEmail        = response.data[0].email;
                    this.fillEditarTecnico.tTelefono     = response.data[0].phone;
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
            setEditarTecnico(){
                if (this.validarEditarTecnico()) {
                    this.modalShow = true;
                    return;
                }
                var url = '/operacion/tecnico/setEditarTecnico'
                axios.post(url, {
                    'nIdTecnico'  :   this.fillEditarTecnico.nIdTecnico,
                    'tRfc'       :   this.fillEditarTecnico.tRfc,
                    'tNombre'    :   this.fillEditarTecnico.tNombre,
                    'tApellido'  :   this.fillEditarTecnico.tApellido,
                    'tEmail'     :   this.fillEditarTecnico.tEmail,
                    'tTelefono'  :   this.fillEditarTecnico.tTelefono,
                }).then(response => {
                    this.notificacion = this.$vs.notification({
                        title: 'Notificación Punto de venta',
                        text: 'Se actualizó el Técnico correctamente',
                        color: 'success',
                    })
                    this.$router.push('/tecnico');
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
            validarEditarTecnico(){
                this.error = 0;
                this.mensajeError = [];

                // if (!this.fillEditarTecnico.tRfc) {
                //     this.mensajeError.push("El RFC es un campo obligatorio");
                // }else{
                //     if (this.fillEditarTecnico.tRfc.length != 8) {
                //         this.mensajeError.push("El RFC requiere 8 caracteres");
                //     }
                // }
                if (!this.fillEditarTecnico.tNombre) {
                    this.mensajeError.push("El Nombre es un campo obligatorio");
                }
                if (!this.fillEditarTecnico.tApellido) {
                    this.mensajeError.push("El apellido es un campo obligatorio");
                }
                if (this.fillEditarTecnico.tEmail) {
                    if (!this.valitEmail) {
                        this.mensajeError.push("El correo electrónico tiene un formato inválido");
                    }
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
    .el-row {
        margin-bottom: 20px;
    }
    .el-col {
        border-radius: 4px;
    }
    .bg-purple-dark {
        background: #99a9bf;
    }
    .bg-purple {
        background: #d3dce6;
    }
    .bg-purple-light {
        background: #e5e9f2;
    }
    .grid-content {
        border-radius: 4px;
        min-height: 36px;
    }
    .row-bg {
        padding: 10px 0;
        background-color: #f9fafc;
    }

</style>
