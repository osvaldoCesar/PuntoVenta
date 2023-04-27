<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Crear Producto</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/producto'">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </router-link>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">Formulario Registrar Producto</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Nombre</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillCrearProducto.cNombre" @keyup.enter="setRegistrarProducto">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Descripción</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillCrearProducto.cDescripcion" @keyup.enter="setRegistrarProducto">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Stock</label>
                                                <div class="col-md-9">
                                                    <el-input-number v-model="fillCrearProducto.nStock" controls-position="right" @keyup.enter="setRegistrarProducto" :min="1" :max="1000000000"></el-input-number>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Precio</label>
                                                <div class="col-md-9">
                                                    <el-input-number v-model="fillCrearProducto.fPrecio" controls-position="right" @keyup.enter="setRegistrarProducto" :min="1"></el-input-number>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Categoría</label>
                                                <div class="col-md-9">
                                                    <el-select v-model="fillCrearProducto.nIdCategoria"
                                                    placeholder="Seleccione una Categoría"
                                                    clearable>
                                                        <el-option
                                                            v-for="item in listCategorias"
                                                            :key="item.id"
                                                            :label="item.name"
                                                            :value="item.id">
                                                        </el-option>
                                                    </el-select>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-4 offset-4">
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="setRegistrarProducto" v-loading.fullscreen.lock="fullscreenLoading">Registrar</button>
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
    export default {
        data() {
            return {
                fillCrearProducto: {
                    cNombre: '',
                    cDescripcion: '',
                    nStock: 1,
                    fPrecio: 1,
                    nIdCategoria: '',
                },
                listCategorias: [],
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
        mounted() {
            this.getListarCategorias();
        },
        methods: {
            limpiarCriterios(){
                this.fillCrearProducto.cNombre      =  '';
                this.fillCrearProducto.cDescripcion =  '';
                this.fillCrearProducto.nStock       =  1;
                this.fillCrearProducto.fPrecio      =  1;
                this.fillCrearProducto.nIdCategoria =  '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            getListarCategorias(){
                this.fullscreenLoading = true;
                var url = '/configuracion/categoria/getListarCategorias'
                axios.get(url).then(response => {
                    this.listCategorias =  response.data;
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
            setRegistrarProducto(){
                if (this.validarRegistrarProductos()) {
                    this.modalShow = true;
                    return;
                }
                this.fullscreenLoading = true;
                var url = '/configuracion/producto/setRegistrarProducto'
                axios.post(url, {
                    'cNombre'       :  this.fillCrearProducto.cNombre,
                    'cDescripcion'  :  this.fillCrearProducto.cDescripcion,
                    'nStock'        :  this.fillCrearProducto.nStock,
                    'fPrecio'       :  this.fillCrearProducto.fPrecio,
                    'nIdCategoria'  :  this.fillCrearProducto.nIdCategoria,
                }).then(response => {
                    this.fullscreenLoading = false;
                    this.$router.push('/producto');
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
            validarRegistrarProductos(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillCrearProducto.cNombre) {
                    this.mensajeError.push("El Nombre es un campo obligatorio");
                }

                if (!this.fillCrearProducto.nIdCategoria) {
                    this.mensajeError.push("Debe seleccionar una Categoría, es un campo obligatorio");
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
