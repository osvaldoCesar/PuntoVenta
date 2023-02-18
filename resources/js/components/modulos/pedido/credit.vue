<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Abono a Pedido</h1>
                    </div>
                </div>
            </div>
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <router-link class="btn btn-info btn-sm" :to="'/pedido'">
                            <i class="fas fa-arrow-left"></i> Regresar
                        </router-link>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">Cantidad a abonar</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Cantidad a abonar</label>
                                                <div class="col-md-9">
                                                    <el-input-number ref="abono_total" v-model="fillAbonarPedido.fAbono" controls-position="right" @keyup.enter="setRegistrarAbono" :min="1" :max="this.fTotalRestante"></el-input-number>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Comentario</label>
                                                <div class="col-md-9">
                                                    <el-input
                                                        type="textarea"
                                                        :rows="3"
                                                        :autosize="{ minRows: 2, maxRows: 3}"
                                                        placeholder="Agrega un comentario al abono"
                                                        @keyup.enter="setRegistrarAbono"
                                                        v-model="fillAbonarPedido.cComentario">
                                                    </el-input>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group row">
                                                <table class="table">
                                                    <tbody>
                                                        <tr>
                                                            <th scope="row">Total Abonos</th>
                                                            <td><label v-text="this.formatoMoneda(this.fTotalAbonos)"></label></td>
                                                        </tr>
                                                        <tr>
                                                          <th scope="row">Restante</th>
                                                          <td><label v-text="this.formatoMoneda(this.fTotalRestante)"></label></td>
                                                        </tr>
                                                        <tr>
                                                          <th scope="row">Total</th>
                                                          <td><label v-text="this.formatoMoneda(this.fTotal)"></label></td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="card-footer">
                    <div class="row">
                        <div class="col-md-4 offset-4">
                            <button class="btn btn-flat btn-info btnWidth" @click.prevent="setRegistrarAbono" v-loading.fullscreen.lock="fullscreenLoading">Registrar</button>
                            <button class="btn btn-flat btn-default btnWidth" @click.prevent="limpiarCriteriosBsq">Limpiar</button>
                        </div>
                    </div>
                </div>
            </div>
            <div class="card card-info">
                <div class="card-header">
                    <h3 class="card-title">Bandeja de Resultados</h3>
                </div>
                <div class="card-body table-responsive">
                    <template v-if="listarPedidosPaginated.length">
                        <table class="table table-hover table-head-fixed text-nowrap">
                            <thead>
                                <tr>
                                    <th>#</th>
                                    <th>Abono</th>
                                    <th>Fecha de abono</th>
                                    <th>Comentario</th>
                                    <th>Usuario</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(item, index) in listarPedidosPaginated" :key="index">
                                    <td v-text="index+1"></td>
                                    <td v-text="item.abonos"></td>
                                    <td v-text="item.fecha"></td>
                                    <td v-text="item.comentario"></td>
                                    <td v-text="item.vendedor"></td>
                                </tr>
                            </tbody>
                        </table>
                        <div class="card-footer clearfix">
                            <ul class="pagination pagination-sm m-0 float-right">
                                <li class="page-item" v-if="pageNumber > 0">
                                    <a href="#" class="page-link" @click.prevent="prevPage">Ant</a>
                                </li>
                                <li class="page-item" v-for="(page, index) in pagesList" :key="index"
                                    :class="[page == pageNumber ? 'active' : '']">
                                    <a href="#" class="page-link" @click.prevent="selectPage(page)">{{ page+1 }}</a>
                                </li>
                                <li class="page-item" v-if="pageNumber < pageCount - 1">
                                    <a href="#" class="page-link" @click.prevent="nextPage">Post</a>
                                </li>
                            </ul>
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
                fillAbonarPedido: {
                    nIdPedido: this.$attrs.id,
                    fAbono         :   '',
                    cComentario    :   '',
                },
                listAbonoPedidos: [],
                listTotales: [],
                listEstados: [
                    {value: 'A', label: 'Activo'},
                    {value: 'I', label: 'Inactivo'},
                    {value: 'L', label: 'Liquidado'},
                ],
                listaRolPermisosByUsuario: JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario')),
                pageNumber: 0,
                perPage: 5,
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
                mensajeError: [],
                notificacion: '',
                fTotalAbonos: 0.00,
                fTotalRestante: 0.00,
                fTotal: 0.00,
            }
        },
        mounted() {
            this.getListarAbonoPedidos();
            this.$refs.abono_total.focus();
        },
        computed: {
            totalPedido(){
                return this.listAbonoPedidos.reduce(function(valorAnterior, valorActual){
                    return valorAnterior + parseFloat(valorActual.fSubTotal)
                },0)
            },
            // Obtener el número de páginas
            pageCount(){
                let a = this.listAbonoPedidos.length,
                    b = this.perPage;
                return Math.ceil(a / b);
            },
            // Obtener registros paginados
            listarPedidosPaginated(){
                let inicio = this.pageNumber * this.perPage,
                    fin    = inicio + this.perPage;
                return this.listAbonoPedidos.slice(inicio, fin);
            },
            //
            pagesList() {
                let a = this.listAbonoPedidos.length,
                    b = this.perPage;
                let pageCount = Math.ceil(a / b);
                let count = 0,
                    pagesArray = [];
                while (count < pageCount) {
                    pagesArray.push(count);
                    count++;
                }
                return pagesArray;
            }
        },
        methods: {
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            limpiarCriteriosBsq(){
                this.fillAbonarPedido.fAbono        = '';
                this.fillAbonarPedido.cComentario   = '';
            },
            getListarAbonoPedidos(){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Listando abonos...'
                })
                var url = '/operacion/pedido/getListarAbonoPedidos'
                axios.get(url, {
                    params: {
                        'nIdPedido'  :  this.fillAbonarPedido.nIdPedido
                    }
                }).then(response => {
                    this.inicializarPaginacion();
                    this.listAbonoPedidos =  response.data;
                    this.getListarTotales();
                    loading.close();
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        loading.close();
                    }
                });
            },
            setGenerarDocumento(nIdPedido){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Generando documento...'
                })

                var config = {
                    responseType: 'blob'
                }
                var url = '/operacion/pedido/setGenerarDocumento'
                axios.post(url, {
                        'nIdPedido'  : nIdPedido
                }, config).then(response => {
                    console.log(response.data);
                    var oMyBlob = new Blob([response.data], {type : 'application/pdf'});
                    var url = URL.createObjectURL(oMyBlob);
                    window.open(url);
                    loading.close();
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        loading.close();
                    }
                });
            },
            setCambiarEstadoPedido(op, id){
                Swal.fire({
                    title: '¿Está seguro de ' + ((op == 1) ? 'rechazar' : 'activar') + ' el pedido?',
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33',
                    confirmButtonText: ((op == 1) ? 'Si, rechazar' : 'Si, activar')
                }).then((result) => {
                    if (result.value) {
                        // Aquí irá la confirmación del botón, petición al servidor
                        const loading = this.$vs.loading({
                            type: 'points',
                            color: '#90A637',
                            background: '#DBE6B1',
                            text: 'Validando...'
                        })
                        var url = '/operacion/pedido/setCambiarEstadoPedido';
                        axios.post(url, {
                            'nIdPedido': id,
                            'cEstado': (op == 1) ? 'I' : 'A'
                        }).then(response =>{
                            Swal.fire({
                                icon: 'success',
                                title: 'Se ' + ((op == 1) ? 'rechazó' : 'activó') + ' el pedido',
                                showConfirmButton: false,
                                timer: 1500,
                            })
                            loading.close();
                            this.getListarAbonoPedidos();
                        }).catch(error =>{
                            if (error.response.status == 401) {
                                this.$router.push({name: 'login'})
                                location.reload();
                                sessionStorage.clear();
                                loading.close();
                            }
                        });
                    }
                })
            },
            getListarTotales(){
                var url = '/operacion/pedido/getListarTotales'
                axios.get(url, {
                    params: {
                        'nIdPedido'  :  this.fillAbonarPedido.nIdPedido
                    }
                }).then(response => {
                    this.listTotales =  response.data;
                    this.fTotalAbonos      =  0
                    this.fTotal            =  0
                    this.fTotalRestante    =  0
                    for(let i of this.listTotales){
                        this.fTotalAbonos       +=  i.totalAbonos
                        this.fTotal             =   i.totalPedido
                        this.fTotalRestante     =   i.restante
                    }
                }).catch(error =>{
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        sessionStorage.clear();
                    }
                });
            },
            setRegistrarAbono(){
                if (this.validarRegistroAbono()) {
                    this.modalShow = true;
                    return;
                }
                this.loading = this.$vs.loading({
                    type: 'circles',
                    color: '#AC8600',
                    background: '#E5D9AF',
                    text: 'Registrando abono...'
                })
                var url = '/operacion/pedido/setRegistrarAbono'
                axios.post(url, {
                    'nIdPedido'    :  this.fillAbonarPedido.nIdPedido,
                    'fAbono'    :  this.fillAbonarPedido.fAbono,
                    'cComentario'    :  this.fillAbonarPedido.cComentario,
                }).then(response => {
                    this.notificacion = this.$vs.notification({
                        title: 'Notificación Punto de venta',
                        text: 'Se agregó el abono correctamente',
                        color: 'success',
                    })
                    setTimeout(() => {
                        this.notificacion.toggleClass('new-class')
                    }, 2000)
                    let resultado = response.data[0].resultado;
                    if(resultado<=0){
                        this.loading.close();
                        this.$router.push('/pedido');
                    }else{
                        this.getListarAbonoPedidos();
                        this.limpiarCriteriosBsq();
                        this.loading.close();
                    }
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
            validarRegistroAbono(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillAbonarPedido.fAbono) {
                    this.mensajeError.push("Introduzca una cantidad válida");
                }

                if (this.mensajeError.length){
                    this.error = 1;
                }
                return this.error;
            },
            formatoMoneda(numero){
                return new Intl.NumberFormat('en-US', {
                    style: 'currency',
                    currency: 'USD'
                }).format(numero)
            },
            nextPage() {
                this.pageNumber++;
            },
            prevPage() {
                this.pageNumber--;
            },
            selectPage(page){
                this.pageNumber = page;
            },
            inicializarPaginacion(){
                this.pagenumber = 0;
            }
        }
    }
</script>

<style>

</style>
