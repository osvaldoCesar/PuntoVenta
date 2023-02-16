<template>
    <div>
        <!-- <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Pedido</h1>
                    </div>
                </div>
            </div>
        </div> -->
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <template v-if="listaRolPermisosByUsuario.includes('pedido.crear')">
                            <router-link class="btn btn-info btn-sm" :to="{name: 'pedido.crear'}">
                                <i class="fas fa-plus-square"></i> Nuevo Pedido
                            </router-link>
                        </template>
                    </div>
                </div>
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">Criterios de Búsqueda</h3>
                            </div>
                            <div class="card-body">
                                <form role="form">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Nombre</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillBsqPedido.cNombre" @keyup.enter="getListarPedidos">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">RFC Cliente</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillBsqPedido.cDocumento" @keyup.enter="getListarPedidos">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">#Pedido</label>
                                                <div class="col-md-9">
                                                    <!-- <el-input ref="num_pedido" placeholder="Número de pedido" type="text" v-model="fillBsqPedido.cPedido" @keyup.enter="getListarPedidos"/> -->
                                                    <input ref="num_pedido" placeholder="Número de pedido" type="text" class="form-control" v-model="fillBsqPedido.cPedido" @keyup.enter="getListarPedidos">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Fecha de cita</label>
                                                <div class="col-md-9">
                                                    <el-date-picker
                                                        v-model="fillBsqPedido.dFechaCita"
                                                        type="date"
                                                        format="yyyy-MM-dd"
                                                        value-format="yyyy-MM-dd"
                                                        placeholder="Selecciona la fecha de la cita">
                                                    </el-date-picker>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Estado</label>
                                                <div class="col-md-9">
                                                    <el-select v-model="fillBsqPedido.cEstado"
                                                    placeholder="Seleccione un Estado"
                                                    clearable>
                                                        <el-option
                                                            v-for="item in listEstados"
                                                            :key="item.value"
                                                            :label="item.label"
                                                            :value="item.value">
                                                        </el-option>
                                                    </el-select>
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
                            <button class="btn btn-flat btn-info btnWidth" @click.prevent="getListarPedidos"
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
                                    <th>#Pedido</th>
                                    <th>RFC Cliente</th>
                                    <th>Cliente</th>
                                    <th>Doctor</th>
                                    <th>Total</th>
                                    <!-- <th>Vendedor</th> -->
                                    <th>Estado</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(item, index) in listarPedidosPaginated" :key="index">
                                    <td v-text="item.pedido"></td>
                                    <td v-text="item.documento"></td>
                                    <td v-text="item.cliente"></td>
                                    <td v-text="item.doctor"></td>
                                    <td v-text="item.total"></td>
                                    <!-- <td v-text="item.vendedor"></td> -->
                                    <td>
                                        <span v-if="item.state == 'A'" class="badge badge-success" v-text="item.estado"></span>
                                        <span v-else-if="item.state == 'I'" class="badge badge-danger" v-text="item.estado"></span>
                                        <span v-else class="badge badge-primary" v-text="item.estado"></span>
                                    </td>
                                    <td>
                                        <template v-if="listaRolPermisosByUsuario.includes('pedido.ver')">
                                            <button class="btn btn-flat btn-info btn-sm" @click.prevent="setGenerarDocumento(item.id)">
                                                <i class="far fa-file-pdf"></i> Ver PDF
                                            </button>
                                        </template>
                                        <template v-if="listaRolPermisosByUsuario.includes('pedido.rechazar')">
                                            <button v-if="item.state == 'A'" class="btn btn-flat btn-danger btn-sm" @click.prevent="setCambiarEstadoPedido(1, item.id)">
                                                <i class="fas fa-trash"></i> Rechazar
                                            </button>
                                        </template>
                                        <template v-if="listaRolPermisosByUsuario.includes('pedido.abonar')">
                                            <router-link v-if="item.state == 'A'" class="btn btn-flat btn-warning btn-sm" :to="{ name: 'cliente.editar', params: {id: item.id}}">
                                                <i class="fa-solid fa-cash-register"></i> Abono/Pago
                                            </router-link>
                                        </template>
                                    </td>
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
                fillBsqPedido: {
                    cNombre: '',
                    cDocumento: '',
                    cPedido: '',
                    cEstado: '',
                    dFechaCita: ''
                },
                listPedidos: [],
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
            this.getListarPedidos();
            this.$refs.num_pedido.focus()
        },
        computed: {
            // Obtener el número de páginas
            pageCount(){
                let a = this.listPedidos.length,
                    b = this.perPage;
                return Math.ceil(a / b);
            },
            // Obtener registros paginados
            listarPedidosPaginated(){
                let inicio = this.pageNumber * this.perPage,
                    fin    = inicio + this.perPage;
                return this.listPedidos.slice(inicio, fin);
            },
            //
            pagesList() {
                let a = this.listPedidos.length,
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
                this.fillBsqPedido.cNombre      = '';
                this.fillBsqPedido.cDocumento   = '';
                this.fillBsqPedido.cPedido      = '';
                this.fillBsqPedido.cEstado      = '';
                this.fillBsqPedido.dFechaCita   = '';
            },
            limpiarBandejaUsuarios(){
                this.listPedidos = [];
            },
            getListarPedidos(){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Listando pedidos...'
                })
                var url = '/operacion/pedido/getListarPedidos'
                axios.get(url, {
                    params: {
                        'cNombre'      :  this.fillBsqPedido.cNombre,
                        'cDocumento'   :  this.fillBsqPedido.cDocumento,
                        'cPedido'      :  this.fillBsqPedido.cPedido,
                        'cEstado'      :  this.fillBsqPedido.cEstado,
                        'dFechaCita'   :  this.fillBsqPedido.dFechaCita
                    }
                }).then(response => {
                    this.inicializarPaginacion();
                    this.listPedidos =  response.data;
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
                            this.getListarPedidos();
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
