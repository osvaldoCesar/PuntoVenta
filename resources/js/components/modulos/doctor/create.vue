<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Crear Doctor</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/doctor'">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </router-link>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="card card-info" >
                            <div class="card-header">
                                <h3 class="card-title">Formulario Registrar Técnicos</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">RFC</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control" v-model="fillCrearDoctor.dRfc" @keyup.enter="setRegistrarDoctor">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Nombre</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control"
                                                    v-model="fillCrearDoctor.dNombre"
                                                    @keyup.enter="setRegistrarDoctor">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Apellido</label>
                                                <div class="col-md-12">
                                                    <input type="text" class="form-control"
                                                    v-model="fillCrearDoctor.dApellido"
                                                    @keyup.enter="setRegistrarDoctor">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Email</label>
                                                <div class="col-md-12">
                                                    <vs-input v-model="fillCrearDoctor.dEmail"
                                                            placeholder="correo@gmail.com"
                                                            @keyup.enter="setRegistrarDoctor">
                                                        <template v-if="validEmail" #message-success>Correo Electrónico válido</template>
                                                        <template v-if="!validEmail && fillCrearDoctor.dEmail !== ''" #message-danger>Correo Electrónico inválido</template>
                                                    </vs-input>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-12 col-form-label">Teléfono</label>
                                                <div class="col-md-12">
                                                    <input type="tel" class="form-control"
                                                    v-model="fillCrearDoctor.dTelefono"
                                                    @keyup.enter="setRegistrarDoctor">
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-4 offset-4">
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="setRegistrarDoctor"
                                        element-loading-text="Cargando..."
                                        element-loading-background="rgba(0, 0, 0, 0.5)"
                                        v-loading.fullscreen.lock="fullscreenLoading">Registrar</button>
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
                fillCrearDoctor: {
                    dRfc: '',
                    dNombre: '',
                    dApellido: '',
                    dEmail: '',
                    dTelefono: '',
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
                mensajeError: []
            }
        },
        computed: {
            validEmail() {
                return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.fillCrearDoctor.dEmail)
            }
        },
        methods: {
            limpiarCriterios(){
                this.fillCrearDoctor.dRfc    = '';
                this.fillCrearDoctor.dNombre       = '';
                this.fillCrearDoctor.dApellido     = '';
                this.fillCrearDoctor.dEmail        = '';
                this.fillCrearDoctor.dTelefono     = '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            setRegistrarDoctor(){
                if (this.validarRegistrarDoctor()) {
                    this.modalShow = true;
                    return;
                }
                this.loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Registrando Doctor...'
                })
                var url = '/operacion/doctor/setRegistrarDoctor'
                axios.post(url, {
                    'dRfc'    :  this.fillCrearDoctor.dRfc,
                    'dNombre'       :  this.fillCrearDoctor.dNombre,
                    'dApellido'     :  this.fillCrearDoctor.dApellido,
                    'dEmail'        :  this.fillCrearDoctor.dEmail,
                    'dTelefono'     :  this.fillCrearDoctor.dTelefono,
                }).then(response => {
                    this.loading.close();
                    this.$router.push('/doctor');
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
            validarRegistrarDoctor(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillCrearDoctor.dRfc) {
                    this.mensajeError.push("El RFC es un campo obligatorio");
                }else{
                    if (this.fillCrearDoctor.dRfc.length != 8) {
                        this.mensajeError.push("El RFC requiere 8 caracteres");
                    }
                }
                if (!this.fillCrearDoctor.dNombre) {
                    this.mensajeError.push("El Nombre es un campo obligatorio");
                }
                if (!this.fillCrearDoctor.dApellido) {
                    this.mensajeError.push("El apellido es un campo obligatorio");
                }
                if (this.fillCrearDoctor.dEmail) {
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
