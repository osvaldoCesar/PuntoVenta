<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Crear Pedido</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
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
                            <div class="col-md-12">
                                <div class="card card-secondary">
                                    <div class="card-header">
                                        <h3 class="card-title">Buscar Doctor</h3>
                                    </div>
                                    <div class="card-body">
                                        <form role="form">
                                            <div class="row">
                                                <div class="col-md-4">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">RFC</label>
                                                        <div class="col-md-12">
                                                            <el-autocomplete
                                                                class="inline-input"
                                                                v-model="cBusquedaDoc"
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
                                                <div class="col-md-8">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">Nombre</label>
                                                        <input type="text" class="form-control"
                                                            v-model="fillCrearDoctor.cNombreCompletoDoc"
                                                            @keyup.enter="setRegistrarPedido"
                                                            disabled=true>
                                                    </div>
                                                </div>
                                            </div>
                                        </form>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card" :class="(switchCliente) ? 'card-info' : 'card-success'">
                                    <div class="card-header">
                                        <h3 class="card-title">{{(switchCliente) ? 'Registrar' : 'Buscar'}} Cliente</h3>
                                    </div>
                                    <div class="card-body">
                                        <form role="form">
                                            <div class="row">
                                                <div class="col-md-3">
                                                    <vs-switch square v-model="switchCliente" @change="limpiarCriterios">
                                                        <template #off>
                                                            <i class="fas fa-plus-square"></i>
                                                        </template>
                                                        <template #on>
                                                            <i class="fas fa-search"></i>
                                                        </template>
                                                    </vs-switch>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">RFC</label>
                                                        <div class="col-md-12">
                                                            <template v-if="switchCliente">
                                                                <input type="text" class="form-control" v-model="fillCrearCliente.cDocumento" @keyup.enter="setRegistrarPedido">
                                                            </template>
                                                            <template v-else>
                                                                <el-autocomplete
                                                                    class="inline-input"
                                                                    v-model="cBusqueda"
                                                                    :fetch-suggestions="querySearch"
                                                                    placeholder="Buscar..."
                                                                    :trigger-on-focus="true"
                                                                    size="medium"
                                                                    @select="clientSelect">
                                                                    <i @click="limpiarCriterios" class="el-icon-search el-input__icon" slot="suffix">
                                                                    </i>
                                                                </el-autocomplete>
                                                            </template>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">Nombre</label>
                                                        <div class="col-md-12">
                                                            <input type="text" class="form-control"
                                                            v-model="fillCrearCliente.cNombre"
                                                            @keyup.enter="setRegistrarPedido"
                                                            :disabled="(switchCliente) ? false : true">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">Apellido</label>
                                                        <div class="col-md-12">
                                                            <input type="text" class="form-control"
                                                            v-model="fillCrearCliente.cApellido"
                                                            @keyup.enter="setRegistrarPedido"
                                                            :disabled="(switchCliente) ? false : true">
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">Email</label>
                                                        <div class="col-md-12">
                                                            <vs-input v-model="fillCrearCliente.cEmail"
                                                                    placeholder="correo@gmail.com"
                                                                    @keyup.enter="setRegistrarPedido"
                                                                    :disabled="(switchCliente) ? false : true">
                                                                <template v-if="validEmail" #message-success>Correo Electrónico válido</template>
                                                                <template v-if="!validEmail && fillCrearCliente.cEmail !== ''" #message-danger>Correo Electrónico inválido</template>
                                                            </vs-input>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-md-12">
                                                    <div class="form-group row">
                                                        <label class="col-md-12 col-form-label">Teléfono</label>
                                                        <div class="col-md-12">
                                                            <input type="tel" class="form-control"
                                                            v-model="fillCrearCliente.cTelefono"
                                                            @keyup.enter="setRegistrarPedido"
                                                            :disabled="(switchCliente) ? false : true">
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
                                                square
                                                icon
                                                color="rgb(59,222,200)"
                                                gradient>
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
                                                                    placeholder="Seleccione una Producto"
                                                                    clearable
                                                                    filterable>
                                                                    <el-option
                                                                        v-for="item in listProductos"
                                                                        :key="item.id"
                                                                        :label="item.name"
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
                                                                        square
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
                                            <el-row :gutter="20">
                                                <el-col :span="16">
                                                    <vs-input border v-model="cComentario" placeholder="Comentario" />
                                                </el-col>
                                                <el-col :span="8">
                                                    <strong>Total = </strong> <strong style="color: red"> {{ fTotalPedido = totalPedido}} </strong>
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
import { nextTick } from 'vue';
    export default {
        data() {
            return {
                fillCrearCliente: {
                    nIdCliente: '',
                    cDocumento: '',
                    cNombre: '',
                    cApellido: '',
                    cEmail: '',
                    cTelefono: '',
                },
                switchCliente: false,

                fillCrearDoctor: {
                    nIdDoctor: '',
                    cRfcDoc: '',
                    cNombreCompletoDoc: '',
                    cNombreDoc: '',
                    cApellidoDoc: '',
                    cEmailDoc: '',
                    cTelefonoDoc: '',
                },

                cBusqueda: '',
                listClientes: [],
                listClientesFilter: [],

                cBusquedaDoc: '',
                listDoctores: [],
                listDoctoresFilter: [],

                listProductos: [],
                listPedidos: [],
                cComentario: '',
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
                mensajeError: []
            }
        },
        computed: {
            validEmail() {
                return /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(this.fillCrearCliente.cEmail)
            },
            totalPedido(){
                return this.listPedidos.reduce(function(valorAnterior, valorActual){
                    return valorAnterior + parseFloat(valorActual.fSubTotal)
                },0)
            }
        },
        mounted (){
            this.agregarProducto();
            this.getListarClientes();
            this.getListarDoctores();
            this.getListarProductos();
        },
        methods: {
            querySearch(queryString, cb) {
                var links = this.listClientesFilter;
                var results = queryString ? links.filter(this.createFilter(queryString)) : links;
                // call callback function to return suggestions
                cb(results);
            },
            querySearchDoctor(queryString, cb) {
                var links = this.listDoctoresFilter;
                var results = queryString ? links.filter(this.createFilterDoc(queryString)) : links;
                // call callback function to return suggestions
                cb(results);
            },
            createFilter(queryString) {
                return (link) => {
                    return (link.value.toLowerCase().indexOf(queryString.toLowerCase()) != -1);
                };
            },
            createFilterDoc(queryString) {
                return (link) => {
                    return (link.value.toLowerCase().indexOf(queryString.toLowerCase()) != -1);
                };
            },
            getListarClientes(){
                var ruta = '/operacion/cliente/getListarClientes';
                axios.get(ruta).then(response => {
                    this.listClientes = response.data;
                    this.filterListarClientes();
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
            filterListarClientes(){
                let me = this;
                me.listClientesFilter = [];
                me.listClientes.map(function(x, y){
                    me.listClientesFilter.push({
                        'value' :   x.document + ' - ' + x.fullname,
                        'link'  :   x.id
                    });
                });
            },
            clientSelect(item) {
                let rpta = this.listClientes.filter(cliente => {
                    return ((String(cliente.id)).indexOf(String(item.link)) != -1);
                });
                this.fillCrearCliente.nIdCliente            = rpta[0].id;
                this.fillCrearCliente.cDocumento            = rpta[0].document;
                this.fillCrearCliente.cNombre               = rpta[0].name;
                this.fillCrearCliente.cApellido             = rpta[0].lastname;
                this.fillCrearCliente.cEmail                = rpta[0].email;
                this.fillCrearCliente.cTelefono             = rpta[0].phone;
            },
            filterListarDoctores(){
                let me = this;
                me.listDoctoresFilter = [];
                me.listDoctores.map(function(x, y){
                    me.listDoctoresFilter.push({
                        'value' :   x.rfc + ' - ' + x.fullname,
                        'link'  :   x.id
                    });
                });
            },
            doctorSelect(item) {
                let rpta = this.listDoctores.filter(doctores => {
                    return ((String(doctores.id)).indexOf(String(item.link)) != -1);
                });
                this.fillCrearDoctor.nIdDoctor      = rpta[0].id;
                this.fillCrearDoctor.cRfcDoc        = rpta[0].rfc;
                this.fillCrearDoctor.cNombreCompletoDoc    = rpta[0].name + ' ' + rpta[0].lastname;
                this.fillCrearDoctor.cNombreDoc     = rpta[0].name;
                this.fillCrearDoctor.cApellidoDoc   = rpta[0].lastname;
                this.fillCrearDoctor.cEmailDoc      = rpta[0].email;
                this.fillCrearDoctor.cTelefonoDoc   = rpta[0].phone;
            },
            limpiarCriterios(){
                this.fillCrearCliente.nIdCliente    = '';
                this.cBusqueda                      = '';
                this.fillCrearCliente.cDocumento    = '';
                this.fillCrearCliente.cNombre       = '';
                this.fillCrearCliente.cApellido     = '';
                this.fillCrearCliente.cEmail        = '';
                this.fillCrearCliente.cTelefono     = '';
            },
            limpiarCriteriosDoctores(){
                this.fillCrearDoctor.nIdDoctor      = '';
                this.cBusquedaDoc                   = '';
                this.fillCrearDoctor.cRfcDoc        = '';
                this.fillCrearDoctor.cNombreCompletoDoc    = '';
                this.fillCrearDoctor.cNombreDoc     = '';
                this.fillCrearDoctor.cApellidoDoc   = '';
                this.fillCrearDoctor.cEmailDoc      = '';
                this.fillCrearDoctor.cTelefonoDoc   = '';
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

                if (this.switchCliente) {
                    this.setRegistrarCliente();
                } else {
                    this.setGuardarPedido(this.fillCrearCliente.nIdCliente);
                }
            },
            setRegistrarCliente(){
                this.fullscreenLoading = true;
                var url = '/operacion/cliente/setRegistrarCliente'
                axios.post(url, {
                    'cDocumento'    :  this.fillCrearCliente.cDocumento,
                    'cNombre'       :  this.fillCrearCliente.cNombre,
                    'cApellido'     :  this.fillCrearCliente.cApellido,
                    'cEmail'        :  this.fillCrearCliente.cEmail,
                    'cTelefono'     :  this.fillCrearCliente.cTelefono,
                }).then(response => {
                    let nIdCliente = response.data[0].nIdCliente;
                    this.setGuardarPedido(nIdCliente);
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
            setGuardarPedido(nIdCliente){
                var url = '/operacion/pedido/setRegistrarPedido'
                axios.post(url, {
                    'nIdCliente'    : nIdCliente,
                    'cComentario'   :  this.cComentario,
                    'fTotalPedido'  :  this.fTotalPedido,
                    'listPedido'     :  this.listPedidos,
                }).then(response => {
                    // this.setGenerarEmail(response.data);
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
            validarRegistrarPedido(){
                this.error = 0;
                this.mensajeError = [];

                if (!this.fillCrearDoctor.nIdDoctor) {
                    this.mensajeError.push("Se debe asignar un doctor");
                }
                if (this.switchCliente) {
                    if (!this.fillCrearCliente.cDocumento) {
                        this.mensajeError.push("El Documento es un campo obligatorio");
                    }
                    if (!this.fillCrearCliente.cNombre) {
                        this.mensajeError.push("El Nombre es un campo obligatorio");
                    }
                    if (!this.fillCrearCliente.cApellido) {
                        this.mensajeError.push("El apellido es un campo obligatorio");
                    }
                    if (this.fillCrearCliente.cEmail) {
                        if (!this.validEmail) {
                            this.mensajeError.push("El correo electrónico tiene un formato inválido");
                        }
                    }
                }else{
                    if (!this.fillCrearCliente.nIdCliente) {
                        this.mensajeError.push("El Cliente es necesario cargar");
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
