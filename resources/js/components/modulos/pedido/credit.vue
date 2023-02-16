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
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Cantidad a abonar</label>
                                                <div class="col-md-9">
                                                    <el-input-number ref="abono_total" v-model="fillAbonarPedido.fAbono" controls-position="right" @keyup.enter="setAbonarPedido" :min="1"></el-input-number>
                                                </div>
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
                            <button class="btn btn-flat btn-info btnWidth" @click.prevent="getListarAbonoPedidos"
                            element-loading-text="Cargando..."
                            element-loading-background="rgba(0, 0, 0, 0.5)"
                            v-loading.fullscreen.lock="fullscreenLoading">Buscar</button>
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
                                    <th>Total</th>
                                    <th>Abono</th>
                                    <th>Fecha de abono</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(item, index) in listarPedidosPaginated" :key="index">
                                    <td v-text="item.total"></td>
                                    <td v-text="item.abonos"></td>
                                    <td v-text="item.fecha"></td>

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
    </div>
</template>

<script>
// import axios from 'axios';

    export default {
        data() {
            return {
                fillAbonarPedido: {
                    nIdPedido: this.$attrs.id,
                    fAbono: '',
                },
                listAbonoPedidos: [],
                listEstados: [
                    {value: 'A', label: 'Activo'},
                    {value: 'I', label: 'Inactivo'},
                    {value: 'L', label: 'Liquidado'},
                ],
                listaRolPermisosByUsuario: JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario')),
                pageNumber: 0,
                perPage: 5,
                fullscreenLoading: false,
            }
        },
        mounted() {
            this.getListarAbonoPedidos();
            this.$refs.abono_total.focus()
        },
        computed: {
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
            limpiarCriteriosBsq(){
                this.fillAbonarPedido.fAbono   = '';
            },
            limpiarBandejaUsuarios(){
                this.listAbonoPedidos = [];
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
                    console.log(response.data)
                    this.listAbonoPedidos =  response.data;
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
