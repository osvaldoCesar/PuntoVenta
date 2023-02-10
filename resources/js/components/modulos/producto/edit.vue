<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Editar Producto</h1>
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
                                <h3 class="card-title">Formulario Editar Producto</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Nombre</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillEditarProducto.cNombre" @keyup.enter="setEditarProducto">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Descripción</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillEditarProducto.cDescripcion" @keyup.enter="setEditarProducto">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Stock</label>
                                                <div class="col-md-9">
                                                    <el-input-number v-model="fillEditarProducto.nStock" controls-position="right" @keyup.enter="setEditarProducto" :min="1"></el-input-number>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Precio</label>
                                                <div class="col-md-9">
                                                    <el-input-number v-model="fillEditarProducto.fPrecio" controls-position="right" @keyup.enter="setEditarProducto" :min="1"></el-input-number>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Categoría</label>
                                                <div class="col-md-9">
                                                    <el-select v-model="fillEditarProducto.nIdCategoria"
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
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="setEditarProducto" v-loading.fullscreen.lock="fullscreenLoading">Editar</button>
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
                fillEditarProducto: {
                    nIdProducto: this.$attrs.id,
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
            this.getListarProductos();
        },
        methods: {
            limpiarCriterios(){
                this.fillEditarProducto.cNombre      =  '';
                this.fillEditarProducto.cDescripcion =  '';
                this.fillEditarProducto.nStock       =  1;
                this.fillEditarProducto.fPrecio      =  1;
                this.fillEditarProducto.nIdCategoria =  '';
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
            getListarProductos(){
                this.fullscreenLoading = true;
                var url = '/configuracion/producto/getListarProductos'
                axios.get(url, {
                    params: {
                        'nIdProducto'  : this.fillEditarProducto.nIdProducto
                    }
                }).then(response => {
                    this.fillEditarProducto.cNombre         =  response.data[0].name;
                    this.fillEditarProducto.cDescripcion    =  response.data[0].description;
                    this.fillEditarProducto.nStock          =  response.data[0].stock;
                    this.fillEditarProducto.fPrecio         =  response.data[0].price;
                    this.fillEditarProducto.nIdCategoria    =  response.data[0].nIdCategoria;
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
            setEditarProducto(){
                if (this.validarEditarProductos()) {
                    this.modalShow = true;
                    return;
                }
                this.fullscreenLoading = true;
                var url = '/configuracion/producto/setEditarProducto'
                axios.post(url, {
                    'nIdProducto'       :  this.fillEditarProducto.nIdProducto,
                    'cNombre'       :  this.fillEditarProducto.cNombre,
                    'cDescripcion'  :  this.fillEditarProducto.cDescripcion,
                    'nStock'        :  this.fillEditarProducto.nStock,
                    'fPrecio'       :  this.fillEditarProducto.fPrecio,
                    'nIdCategoria'  :  this.fillEditarProducto.nIdCategoria,
                }).then(response => {
                    this.fullscreenLoading = false;
                    Swal.fire({
                        icon: 'success',
                        title: 'Se actualizó el producto correctamente',
                        showConfirmButton: false,
                        timer: 1500
                    })
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
            validarEditarProductos(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillEditarProducto.cNombre) {
                    this.mensajeError.push("El Nombre es un campo obligatorio");
                }

                if (!this.fillEditarProducto.nStock) {
                    this.mensajeError.push("El Stock es un campo obligatorio");
                }

                if (!this.fillEditarProducto.fPrecio) {
                    this.mensajeError.push("El Precio es un campo obligatorio");
                }

                if (!this.fillEditarProducto.nIdCategoria) {
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
