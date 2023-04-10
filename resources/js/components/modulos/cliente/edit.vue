<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Editar Cliente</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/cliente'">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </router-link>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="card card-info" >
                            <div class="card-header">
                                <h3 class="card-title">Formulario Editar Cliente</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">RFC</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control" v-model="fillEditarCliente.cDocumento" @keyup.enter="setEditarCliente">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Nombre</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control"
                                                    v-model="fillEditarCliente.cNombre"
                                                    @keyup.enter="setEditarCliente">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Apellido</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control"
                                                    v-model="fillEditarCliente.cApellido"
                                                    @keyup.enter="setEditarCliente">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Email</label>
                                                <div class="col-md-12">
                                                    <vs-input v-model="fillEditarCliente.cEmail"
                                                            placeholder="correo@gmail.com"
                                                            @keyup.enter="setEditarCliente">
                                                        <template v-if="validEmail" #message-success>Correo Electrónico válido</template>
                                                        <template v-if="!validEmail && fillEditarCliente.cEmail !== ''" #message-danger>Correo Electrónico inválido</template>
                                                    </vs-input>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Teléfono</label>
                                                <div class="col-md-12">
                                                    <input type="tel" class="form-control"
                                                    v-model="fillEditarCliente.cTelefono"
                                                    @keyup.enter="setEditarCliente">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-4 offset-4">
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="setEditarCliente" v-loading.fullscreen.lock="fullscreenLoading">Editar</button>
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
                fillEditarCliente: {
                    nIdCliente: this.$attrs.id,
                    cDocumento: '',
                    cNombre: '',
                    cApellido: '',
                    cEmail: '',
                    cTelefono: '',
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
            validEmail() {
                return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.fillEditarCliente.cEmail)
            }
        },
        mounted(){
            this.getListarClientes();
        },
        methods: {
            limpiarCriterios(){
                this.fillEditarCliente.cDocumento    = '';
                this.fillEditarCliente.cNombre       = '';
                this.fillEditarCliente.cApellido     = '';
                this.fillEditarCliente.cEmail        = '';
                this.fillEditarCliente.cTelefono     = '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            getListarClientes(){
                var url = '/operacion/cliente/getListarClientes'
                axios.get(url, {
                    params: {
                        'nIdCliente'  : this.fillEditarCliente.nIdCliente
                    }
                }).then(response => {
                    this.fillEditarCliente.cDocumento    = response.data[0].document;
                    this.fillEditarCliente.cNombre       = response.data[0].name;
                    this.fillEditarCliente.cApellido     = response.data[0].lastname;
                    this.fillEditarCliente.cEmail        = response.data[0].email;
                    this.fillEditarCliente.cTelefono     = response.data[0].phone;
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                    }
                });
            },
            setEditarCliente(){
                if (this.validarEditarCliente()) {
                    this.modalShow = true;
                    return;
                }
                var url = '/operacion/cliente/setEditarCliente'
                axios.post(url, {
                    'nIdCliente'    :  this.fillEditarCliente.nIdCliente,
                    'cDocumento'    :  this.fillEditarCliente.cDocumento,
                    'cNombre'       :  this.fillEditarCliente.cNombre,
                    'cApellido'     :  this.fillEditarCliente.cApellido,
                    'cEmail'        :  this.fillEditarCliente.cEmail,
                    'cTelefono'     :  this.fillEditarCliente.cTelefono,
                }).then(response => {
                    this.notificacion = this.$vs.notification({
                        title: 'Notificación Punto de venta',
                        text: 'Se actualizó el Cliente correctamente',
                        color: 'success',
                    })
                    // setTimeout(() => {
                    //     notificacion.toggleClass('new-class')
                    // }, 2000)
                    this.$router.push('/cliente');
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        this.loading.close();
                    }
                });
            },
            validarEditarCliente(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillEditarCliente.cDocumento) {
                    this.mensajeError.push("El Documento es un campo obligatorio");
                }else{
                    if (this.fillEditarCliente.cDocumento.length != 8) {
                        this.mensajeError.push("El Documento requiere 8 caracteres");
                    }
                }
                if (!this.fillEditarCliente.cNombre) {
                    this.mensajeError.push("El Nombre es un campo obligatorio");
                }
                if (!this.fillEditarCliente.cApellido) {
                    this.mensajeError.push("El apellido es un campo obligatorio");
                }
                if (this.fillEditarCliente.cEmail) {
                    if (!this.validEmail) {
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
