<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Levantar Pedido</h1>
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
                        <div class="row">
                            <div class="col-md-4">
                                <div class="card card-success">
                                    <div class="card-header">
                                        <h3 class="card-title">Parámetros del Pedido</h3>
                                    </div>
                                    <div class="card-body">
                                        <form role="form">
                                            <div class="row">
                                                <div class="col-md-12">
                                                    <div class=" row">
                                                        <label class="col-md-12 col-form-label">Técnico</label>
                                                        <div class="col-md-12">
                                                            <el-autocomplete
                                                                class="inline-input"
                                                                v-model="cBusquedaTecnico"
                                                                :fetch-suggestions="querySearchTecnico"
                                                                placeholder="Buscar..."
                                                                :trigger-on-focus="true"
                                                                size="medium"
                                                                @select="tecnicoSelect">
                                                                <i @click="limpiarCriteriosTecnicos" class="el-icon-search el-input__icon" slot="suffix">
                                                                </i>
                                                            </el-autocomplete>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-md-12">
                                                    <div class=" row">
                                                        <label class="col-md-12 col-form-label">Doctor</label>
                                                        <div class="col-md-12">
                                                            <el-autocomplete
                                                            name="dniDoc"
                                                                class="inline-input"
                                                                v-model="cBusquedaDoctor"
                                                                :fetch-suggestions="querySearchDoctor"
                                                                placeholder="Buscar..."
                                                                :trigger-on-focus="true"
                                                                size="medium"
                                                                @select="doctorSelect">
                                                                <i @click="limpiarCriteriosDoctores" class="el-icon-search el-input__icon" slot="suffix">
                                                                </i>
                                                            </el-autocomplete>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-md-12">
                                                    <div class=" row">
                                                        <label class="col-md-12 col-form-label">Paciente</label>
                                                        <div class="col-md-12">
                                                            <el-autocomplete
                                                                class="inline-input"
                                                                v-model="cBusquedaPacientes"
                                                                :fetch-suggestions="querySearchPaciente"
                                                                placeholder="Buscar..."
                                                                :trigger-on-focus="true"
                                                                size="medium"
                                                                @select="pacienteSelect">
                                                                <i @click="limpiarCriteriosPacientes" class="el-icon-search el-input__icon" slot="suffix">
                                                                </i>
                                                            </el-autocomplete>
                                                        </div>
                                                    </div>
                                                </div>

                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">Fecha de entrega</label>
                                                        <div class="col-md-12">
                                                            <el-date-picker
                                                                v-model="dFechaCita"
                                                                type="datetime"
                                                                format="yyyy-MM-dd HH:mm:ss"
                                                                value-format="yyyy-MM-dd HH:mm:ss"
                                                                placeholder="Selecciona la fecha y la hora de la entrega"
                                                                default-time="12:00:00">
                                                            </el-date-picker>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                    <div class="card-footer">
                                        <div class="row">
                                            <button v-if="fTotalPedido > 0 && listPedidos.length > 0" class="btn btn-flat btn-info btnFull" @click.prevent="setRegistrarPedido">Registrar</button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-8">
                                <div class="card card-info">
                                    <div class="card-header">
                                        <h3 class="card-title">Seleccionar Productos</h3>
                                    </div>
                                    <div class="card-body table-responsive">
                                        <vs-tooltip not-arrow right>
                                            <vs-button
                                            @click.prevent="agregarProducto"
                                                icon
                                                color="rgb(59,222,200)">
                                                <i class="fas fa-plus-square"></i>
                                            </vs-button>
                                            <template #tooltip>
                                                Agregar Producto
                                            </template>
                                        </vs-tooltip>

                                        <template v-if="listPedidos.length">
                                            <div class="scrollTable">
                                                <table class="table table-hover table-head-fixed text-nowrap">
                                                    <thead>
                                                        <tr>
                                                            <th>Artículo</th>
                                                            <th>Stock</th>
                                                            <th>Precio</th>
                                                            <th>SubTotal</th>
                                                            <th>Acción</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <tr v-for="(item, index) in listPedidos" :key="index">
                                                            <td>
                                                                <el-select v-model="item.nIdProducto"
                                                                    @change="obtenerProducto(item.nIdProducto, index)"
                                                                    placeholder="Seleccione un Producto"
                                                                    clearable
                                                                    filterable>
                                                                    <el-option
                                                                        v-for="item in listProductos"
                                                                        :key="item.id"
                                                                        :label="item.name + ' - ' + item.categoria"
                                                                        :value="item.id">
                                                                    </el-option>
                                                                </el-select>
                                                            </td>
                                                            <td>
                                                                <el-input-number v-model="item.nStock"
                                                                                controls-position="right"
                                                                                :min="1"
                                                                                :max="(item.nIdProducto) ? item.nStockFlag : 1"></el-input-number>
                                                            </td>
                                                            <td v-text="item.fPrecio"></td>
                                                            <td>{{ item.fSubTotal = item.nStock * item.fPrecio }}</td>
                                                            <td>
                                                                <el-tooltip class="item" effect="dark" content="Remover Producto" placement="left">
                                                                    <vs-button
                                                                        @click.prevent="removerProducto(index)"
                                                                        icon
                                                                        danger
                                                                        gradient>
                                                                        <i class="fas fa-trash"></i>
                                                                    </vs-button>
                                                                </el-tooltip>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                            <el-row :gutter="24">
                                                <el-col :span="12">
                                                    <vs-input border v-model="cComentario" placeholder="Comentario" />
                                                </el-col>
                                                <el-col :span="12">
                                                    <el-input-number border v-model="pAbono" placeholder="Abono/Pago"
                                                                                controls-position="right"
                                                                                :min="0"
                                                                                :max="fTotalPedido"></el-input-number>
                                                </el-col>

                                            </el-row>
                                            <el-row :gutter="24">
                                                <el-col :span="6">
                                                    <strong>SubTotal = </strong> <strong style="color: red"> $&nbsp;{{ fTotalPedido = totalPedido}} </strong>
                                                </el-col>
                                                <el-col :span="6">
                                                    <strong>Abono = </strong> <strong style="color: red"> $&nbsp;{{ pAbono }} </strong>
                                                </el-col>
                                                <el-col :span="6">
                                                    <strong>Restante = </strong> <strong style="color: red"> $&nbsp;{{ totalPedido - pAbono }} </strong>
                                                </el-col>
                                            </el-row>
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
                fillCrearTecnico: {
                    nIdTecnico: '',
                },

                fillCrearDoctor: {
                    nIdDoctor: '',
                },

                fillCrearPaciente: {
                    nIdPaciente: '',
                },

                cBusquedaTecnico: '',
                listTecnicos: [],
                listTecnicosFilter: [],

                cBusquedaDoctor: '',
                listDoctores: [],
                listDoctoresFilter: [],

                cBusquedaPacientes: '',
                listPacientes: [],
                listPacientesFilter: [],

                listProductos: [],
                listPedidos: [],
                cComentario: '',
                pAbono: 0,
                fTotalPedido: 0,

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
                dFechaCita: ''
            }
        },
        computed: {
            totalPedido(){
                return this.listPedidos.reduce(function(valorAnterior, valorActual){
                    return valorAnterior + parseFloat(valorActual.fSubTotal)
                },0)
            }
        },
        mounted (){
            this.agregarProducto();
            this.getListarTecnicos();
            this.getListarDoctores();
            this.getListarProductos();
        },
        methods: {
            querySearchTecnico(queryString, cb) {
                var links = this.listTecnicosFilter;
                var results = queryString ? links.filter(this.createFilterTecnico(queryString)) : links;
                // call callback function to return suggestions
                cb(results);
            },
            querySearchDoctor(queryString, cb) {
                var links = this.listDoctoresFilter;
                var results = queryString ? links.filter(this.createFilterDoctor(queryString)) : links;
                // call callback function to return suggestions
                cb(results);
            },
            querySearchPaciente(queryString, cb) {
                var links = this.listPacientesFilter;
                var results = queryString ? links.filter(this.createfilterPaciente(queryString)) : links;
                // call callback function to return suggestions
                cb(results);
            },
            createFilterTecnico(queryString) {
                return (link) => {
                    return (link.value.toLowerCase().indexOf(queryString.toLowerCase()) != -1);
                };
            },
            createFilterDoctor(queryString) {
                return (link) => {
                    return (link.value.toLowerCase().indexOf(queryString.toLowerCase()) != -1);
                };
            },
            createfilterPaciente(queryString) {
                return (link) => {
                    return (link.value.toLowerCase().indexOf(queryString.toLowerCase()) != -1);
                };
            },
            getListarTecnicos(){
                var ruta = '/operacion/tecnico/getListarTecnicos';
                axios.get(ruta).then(response => {
                    this.listTecnicos = response.data;
                    this.filterListarTecnicos();
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
            getListarDoctores(){
                var ruta = '/operacion/doctor/getListarDoctores';
                axios.get(ruta).then(response => {
                    this.listDoctores = response.data;
                    this.filterListarDoctores();
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
            getListarPacientes(id){
                console.log(id)
                var url = '/operacion/doctor/getListarPacientes'
                axios.get(url, {
                    params: {
                        'nIdDoctor'   : id
                    }
                }).then(response => {
                    this.listPacientes =  response.data;
                    console.log(response.data)
                    this.filterListarPacientes();
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
            getListarProductos(){
                var ruta = '/configuracion/producto/getListarProductos';
                axios.get(ruta).then(response => {
                    this.listProductos = response.data;
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
            filterListarTecnicos(){
                let me = this;
                me.listTecnicosFilter = [];
                me.listTecnicos.map(function(x, y){
                    me.listTecnicosFilter.push({
                        'value' :   x.dni + ' - ' + x.fullname,
                        'link'  :   x.id
                    });
                });
            },
            tecnicoSelect(item) {
                let rpta = this.listTecnicos.filter(tecnico => {
                    return ((String(tecnico.id)).indexOf(String(item.link)) != -1);
                });
                this.fillCrearTecnico.nIdTecnico            = rpta[0].id;
            },
            filterListarDoctores(){
                let me = this;
                me.listDoctoresFilter = [];
                me.listDoctores.map(function(x, y){
                    me.listDoctoresFilter.push({
                        'value' :   x.dni + ' - ' + x.fullname,
                        'link'  :   x.id
                    });
                });
            },
            doctorSelect(item) {
                let rpta = this.listDoctores.filter(doctores => {
                    return ((String(doctores.id)).indexOf(String(item.link)) != -1);
                });
                this.fillCrearDoctor.nIdDoctor      = rpta[0].id;
                this.getListarPacientes(rpta[0].id);
            },
            filterListarPacientes(){
                let me = this;
                me.listPacientesFilter = [];
                me.listPacientes.map(function(x, y){
                    me.listPacientesFilter.push({
                        'value' :   x.dni + ' - ' + x.fullname,
                        'link'  :   x.id
                    });
                });
            },
            pacienteSelect(item) {
                let rpta = this.listPacientes.filter(pacientes => {
                    return ((String(pacientes.id)).indexOf(String(item.link)) != -1);
                });
                this.fillCrearPaciente.nIdPaciente      = rpta[0].id;
            },
            limpiarCriteriosTecnicos(){
                this.fillCrearTecnico.nIdTecnico    = '';
                this.cBusquedaTecnico                      = '';
            },
            limpiarCriteriosDoctores(){
                this.fillCrearDoctor.nIdDoctor      = '';
                this.cBusquedaDoctor                   = '';
            },
            limpiarCriteriosPacientes(){
                this.fillCrearPaciente.nIdPaciente      = '';
                this.cBusquedaPacientes                   = '';
            },
            abrirModal(){
                this.modalShow = !this.modalShow;
            },
            agregarProducto(){
                let me = this;
                if (this.listPedidos.length == 0) {
                    this.listPedidos.push({
                        'nIdProducto'   : '',
                        'nStock'        : '',
                        'nStockFlag'    : '',
                        'fPrecio'       : '',
                        'fSubTotal'     : '',
                    })
                }else{
                    let contador = 0;
                    this.listPedidos.map(function(x, y){
                        if (!x.nIdProducto || !x.nStock || !x.fPrecio || !x.fSubTotal) {
                            contador++;
                            // Notificación
                            const noti = me.$vs.notification({
                                square: true,
                                color: 'danger',
                                position: 'bottom-right',
                                title: 'Alerta',
                                text: 'Debe completar la información de la fila = ' + (y+1)
                            })
                        }
                    })
                    if (contador == 0) {
                        this.listPedidos.push({
                            'nIdArticulo'   : '',
                            'nStock'        : '',
                            'nStockFlag'    : '',
                            'fPrecio'       : '',
                            'fSubTotal'     : '',
                        })
                    }
                }
            },
            removerProducto(index){
                this.$delete(this.listPedidos, index);
            },
            obtenerProducto(nIdProducto, index){
                let me = this;

                if (!nIdProducto) {
                    Vue.nextTick(function(){
                        me.listPedidos[index].nStock      =  '';
                        me.listPedidos[index].nStockFlag  =  '';
                        me.listPedidos[index].fPrecio     =  '';
                    })
                }
                let contador = 0;
                this.listPedidos.map(function(x, y){
                    if (x.nIdProducto == nIdProducto && y != index) {
                        contador++;
                        // Notificación
                        const noti = me.$vs.notification({
                            square: true,
                            color: 'danger',
                            position: 'bottom-right',
                            title: 'Alerta',
                            text: 'El producto ya se encuentra en la fila = ' + (y+1)
                        })
                    }
                })
                if (contador == 0) {
                    let rpta = this.listProductos.filter(producto => {
                        return ((String(producto.id)).indexOf(String(nIdProducto)) != -1);
                    })
                    if (rpta[0].stock > 0) {
                        this.listPedidos[index].nStock      = 1;
                        this.listPedidos[index].nStockFlag  = rpta[0].stock;
                        this.listPedidos[index].fPrecio     = rpta[0].price;
                    }else{
                        this.listPedidos[index].nIdProducto = '';
                        // Notificación
                        const noti = me.$vs.notification({
                            square: true,
                            color: 'danger',
                            position: 'bottom-right',
                            title: 'Alerta',
                            text: 'El producto seleccionado no cuenta con stock disponible'
                        })
                    }
                }else{
                    this.listPedidos[index].nIdProducto = '';
                }

            },
            setRegistrarPedido(){
                if (this.validarRegistrarPedido()) {
                    this.modalShow = true;
                    return;
                }
                this.loading = this.$vs.loading({
                    type: 'circles',
                    color: '#AC8600',
                    background: '#E5D9AF',
                    text: 'Cargando...'
                })
                this.setGuardarPedido(this.fillCrearTecnico.nIdTecnico, this.fillCrearPaciente.nIdPaciente);
            },
            setGuardarPedido(nIdTecnico, nIdPaciente){
                var url = '/operacion/pedido/setRegistrarPedido'
                axios.post(url, {
                    'nIdTecnico'   :  nIdTecnico,
                    'nIdPaciente'    :  nIdPaciente,
                    'cComentario'  :  this.cComentario,
                    'fTotalPedido' :  this.fTotalPedido,
                    'listPedido'   :  this.listPedidos,
                    'dFechaCita'   :  this.dFechaCita,
                }).then(response => {
                    console.log(response.data)
                    console.log(this.pAbono)

                    // this.setGenerarEmail(response.data);
                    if(this.pAbono>0){
                        this.setRegistrarAbono(response.data)
                    }
                    this.setGenerarTicket(response.data);
                    this.setGenerarDocumento(response.data);
                }).catch(error =>{
                    console.log( `Estoy dentro del error de que el documento no se creó "correctamente"` );
                    console.log(error.response);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'})
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                });
            },
            setGenerarEmail(nIdPedido){
                var url = '/operacion/pedido/setGenerarEmail'
                axios.post(url, {
                    'nIdPedido'       :   nIdPedido
                }).then(response => {
                    this.setGenerarDocumento(nIdPedido);
                }).catch(error => {
                    console.log(error);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'});
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                })
            },
            setGenerarDocumento(nIdPedido){
                var config = {
                    responseType: 'blob'
                }
                var url = '/operacion/pedido/setGenerarDocumento'
                axios.post(url, {
                    'nIdPedido'       :   nIdPedido
                }, config).then(response => {
                    var oMyBlob = new Blob([response.data], {type : 'application/pdf'}); // the blob
                    var url = URL.createObjectURL(oMyBlob);
                    window.open(url);
                    this.loading.close();
                    this.$router.push('/pedido');
                }).catch(error => {
                    console.log(error);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'});
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                })
            },
            setRegistrarAbono(idPedido){
                var url = '/operacion/pedido/setRegistrarAbono'
                axios.post(url, {
                    'nIdPedido'     :  idPedido,
                    'fAbono'        :  this.pAbono,
                    'cComentario'   :  'Se' + ((this.fTotalPedido> 0 && this.pAbono<this.fTotalPedido) ? ` abona $` + this.pAbono : ' liquida'),
                }).then(response => {
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
            setGenerarTicket(nIdPedido){
                var config = {
                    responseType: 'blob'
                }
                var url = '/operacion/pedido/setGenerarTicket'
                axios.post(url, {
                    'nIdPedido'       :   nIdPedido
                }, config).then(response => {
                    var oMyBlob = new Blob([response.data], {type : 'application/pdf'}); // the blob
                    var url = URL.createObjectURL(oMyBlob);
                    window.open(url);
                    this.loading.close();
                    this.$router.push('/pedido');
                }).catch(error => {
                    console.log("Dentro de catch de gnerar ticker")
                    console.log(error);
                    if (error.response.status == 401) {
                        this.$router.push({name: 'login'});
                        location.reload();
                        sessionStorage.clear();
                        this.fullscreenLoading = false;
                    }
                })
            },
            validarRegistrarPedido(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillCrearDoctor.nIdDoctor) {
                    this.mensajeError.push("Eliga primero el Doctor y posteriormente su Paciente");
                }

                if (!this.fillCrearTecnico.nIdTecnico) {
                    this.mensajeError.push("Se debe asignar un Técnico");
                }

                if (!this.fillCrearPaciente.nIdPaciente) {
                    this.mensajeError.push("Se debe seleccionar el Paciente del Doctor");
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
    .el-date-editor.el-input, .el-date-editor.el-input__inner {
        width: 100%;
    }

</style>
