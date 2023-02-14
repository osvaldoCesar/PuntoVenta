<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0 text-dark">Reporte de Pedido</h1>
                    </div>
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>

        <div class="content container-fluid">
            <div class="card">
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
                                                    <input type="text" class="form-control" v-model="fillBsqPedido.cPedido" @keyup.enter="getListarPedidos">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Estado</label>
                                                <div class="col-md-9">
                                                    <el-select  v-model="fillBsqPedido.cEstado"
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
                                        <div class="col-md-12">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Rango de Fechas</label>
                                                <div class="col-md-9">
                                                    <el-date-picker
                                                        v-model="fillBsqPedido.dfecharango"
                                                        type="daterange"
                                                        range-separator="Hasta"
                                                        start-placeholder="Fecha Inicio"
                                                        end-placeholder="Fecha Fin"
                                                        value-format="yyyy-MM-dd">
                                                    </el-date-picker>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </form>
                            </div>
                            <div class="card-footer">
                                <div class="row">
                                    <div class="col-md-4 offset-4">
                                        <button class="btn btn-flat btn-info btnWidth" @click.prevent="getListarPedidos" v-loading.fullscreen.lock="fullscreenLoading">Buscar</button>
                                        <button class="btn btn-flat btn-default btnWidth" @click.prevent="limpiarCriteriosBsq">Limpiar</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="card card-info">
                            <div class="card-header">
                                <h3 class="card-title">
                                    <template v-if="listPedidos.length">
                                        <el-tooltip class="item" effect="dark" content="Exportar en Formato Excel" placement="right">
                                            <i @click.prevent="setGenerarDocumento" class="fas fa-file-excel"></i>
                                        </el-tooltip>
                                    </template>
                                    Bandeja de Resultados
                                </h3>
                            </div>
                            <div class="card-body table-responsive">
                                <template v-if="listarPedidosPaginated.length">
                                    <table class="table table-hover table-head-fixed text-nowrap projects">
                                        <thead>
                                            <tr>
                                                <th>#Pedido</th>
                                                <th>RFC Cliente</th>
                                                <th>Cliente</th>
                                                <th>Total</th>
                                                <th>Vendedor</th>
                                                <th>Estado</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <tr v-for="(item, index) in listarPedidosPaginated" :key="index">
                                                <td v-text="item.pedido"></td>
                                                <td v-text="item.documento"></td>
                                                <td v-text="item.cliente"></td>
                                                <td v-text="item.total"></td>
                                                <td v-text="item.vendedor"></td>
                                                <td>
                                                    <span v-if="item.state == 'A'" class="badge badge-success" v-text="item.estado"></span>
                                                    <span v-else class="badge badge-danger" v-text="item.estado"></span>
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
                                                <a href="#" class="page-link" @click.prevent="selectPage(page)"> {{ page+1 }} </a>
                                            </li>
                                            <li class="page-item" v-if="pageNumber < pageCount - 1">
                                                <a href="#" class="page-link" @click.prevent="nextPage" >Post</a>
                                            </li>
                                        </ul>
                                    </div>
                                </template>
                                <template v-else>
                                    <div class="callout callout-info">
                                        <h5>No se encontraron resultados...</h5>
                                    </div>
                                </template>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    export default {
        data(){
            return {
                fillBsqPedido: {
                    cNombre : '',
                    cDocumento: '',
                    cPedido: '',
                    cEstado: '',
                    dfecharango: ''
                },
                listPedidos: [],
                listEstados: [
                    {value: 'A', label: 'Activo'},
                    {value: 'I', label: 'Inactivo'}
                ],
                listRolPermisosByUsuario: JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario')),
                fullscreenLoading: false,
                pageNumber: 0,
                perPage: 5
            }
        },
        mounted(){
            this.getListarPedidos()
        },
        computed: {
            // Obtener el número de páginas
            pageCount() {
                // 20
                // 5
                // 20 /5 = 4
                let a = this.listPedidos.length,
                    b = this.perPage;
                return Math.ceil(a / b);
            },
            // Obtener registros paginados
            listarPedidosPaginated(){
                // 0 * 5 = 0
                // 0 + 5 = 5
                // 0 - (5-1)
                // 1 * 5 = 5
                // 5 + 5 = 10
                // 5 - (10-1)
                // 2 * 5 = 10
                // 10 + 5 = 15
                // 10 - (15-1)

                let inicio = this.pageNumber * this.perPage,
                    fin    = inicio + this.perPage;
                return this.listPedidos.slice(inicio, fin);
            },
            pagesList() {
                let a = this.listPedidos.length,
                    b = this.perPage;
                let pageCount = Math.ceil(a / b);
                let count = 0,
                    pagesArray = [];

                // 0 < 4 => 0
                // 1 < 4 => 0, 1
                // 2 < 4 => 0, 1, 2
                // 3 < 4 => 0, 1, 2, 3
                // 4 < 4 ??
                while (count < pageCount) {
                    pagesArray.push(count);
                    count++;
                }
                return pagesArray;
            }
        },
        methods: {
            limpiarCriteriosBsq(){
                this.fillBsqPedido.cNombre      =   '';
                this.fillBsqPedido.cDocumento   =   '';
                this.fillBsqPedido.cPedido      =   '';
                this.fillBsqPedido.cEstado    =   '';
                this.fillBsqPedido.dfecharango    =   '';
            },
            getListarPedidos(){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Listando pedidos...'
                })

                var url = '/reporte/pedido/getListarPedidos'
                axios.get(url, {
                    params: {
                        'cNombre'       :   this.fillBsqPedido.cNombre,
                        'cDocumento'    :   this.fillBsqPedido.cDocumento,
                        'cPedido'       :   this.fillBsqPedido.cPedido,
                        'cEstado'       :   this.fillBsqPedido.cEstado,
                        'dFechaInicio'  :   (!this.fillBsqPedido.dfecharango) ? '' : this.fillBsqPedido.dfecharango[0],
                        'dFechaFin'     :   (!this.fillBsqPedido.dfecharango) ? '' : this.fillBsqPedido.dfecharango[1],
                    }
                }).then(response => {
                    this.inicializarPaginacion();
                    this.listPedidos   =   response.data;
                    loading.close()
                }).catch(error => {
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        loading.close()
                    }
                })
            },
            setGenerarDocumento(){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Generando documento...'
                });
                var url = '/reporte/pedido/export'
                axios.get(url, {
                    responseType: 'blob',
                    params: {
                        'listPedidos'   : JSON.stringify(this.listPedidos)
                    }
                }).then(response => {
                    var oMyBlob = new Blob([response.data], {type : 'application/vnd.ms-excel'}); // the blob
                    var url = document.createElement('a')
                    url.href = URL.createObjectURL(oMyBlob);
                    url.download = 'usuarios.xlsx'
                    url.click()
                    loading.close()
                }).catch(error => {
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        loading.close()
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
                this.pageNumber = 0;
            }
        }
    }
</script>

<style>
    .el-range-editor.el-input__inner{
        width: 100% !important;
    }
    .el-date-editor .el-range-separator{
        width: 7% !important;
    }
</style>
