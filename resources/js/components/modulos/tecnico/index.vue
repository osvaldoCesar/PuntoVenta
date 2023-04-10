<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Técnicos</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>
        <div class="content container-fluid">
            <div class="card">
                <div class="card-header">
                    <div class="card-tools">
                        <template v-if="listaRolPermisosByUsuario.includes('tecnico.crear')">
                            <router-link class="btn btn-info btn-sm" :to="{name: 'tecnico.crear'}">
                                <i class="fas fa-plus-square"></i> Nuevo Técnico
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
                                                <label class="col-md-3 col-form-label">DNI</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillBsqTecnico.tDni" @keyup.enter="getListarTecnicos">
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6">
                                            <div class="form-group row">
                                                <label class="col-md-3 col-form-label">Nombre</label>
                                                <div class="col-md-9">
                                                    <input type="text" class="form-control" v-model="fillBsqTecnico.tNombre" @keyup.enter="getListarTecnicos">
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
                            <button class="btn btn-flat btn-info btnWidth" @click.prevent="getListarTecnicos"
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
                    <template v-if="listarTecnicosPaginated.length">
                        <table class="table table-hover table-head-fixed text-nowrap">
                            <thead>
                                <tr>
                                    <th>DNI</th>
                                    <th>Nombre</th>
                                    <th>RFC</th>
                                    <th>Correo</th>
                                    <th>Teléfono</th>
                                    <th>Acciones</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="(item, index) in listarTecnicosPaginated" :key="index">
                                    <td v-text="item.dni"></td>
                                    <td v-text="item.fullname"></td>
                                    <td v-text="item.rfc"></td>
                                    <td v-text="item.email"></td>
                                    <td v-text="item.phone"></td>
                                    <td>
                                        <template v-if="listaRolPermisosByUsuario.includes('tecnico.editar')">
                                            <router-link  class="btn btn-flat btn-info btn-sm" :to="{ name: 'tecnico.editar', params: {id: item.id}}">
                                                <i class="fas fa-pencil-alt"></i> Editar
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
                fillBsqTecnico: {
                    tDni: '',
                    tNombre: '',
                    tRfc: '',
                },
                listTecnicos: [],
                listaRolPermisosByUsuario: JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario')),
                pageNumber: 0,
                perPage: 5,
                fullscreenLoading: false,
            }
        },
        mounted() {
            this.getListarTecnicos();
        },
        computed: {
            // Obtener el número de páginas
            pageCount(){
                let a = this.listTecnicos.length,
                    b = this.perPage;
                return Math.ceil(a / b);
            },
            // Obtener registros paginados
            listarTecnicosPaginated(){
                let inicio = this.pageNumber * this.perPage,
                    fin    = inicio + this.perPage;
                return this.listTecnicos.slice(inicio, fin);
            },
            //
            pagesList() {
                let a = this.listTecnicos.length,
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
                this.fillBsqTecnico.tDni     = '';
                this.fillBsqTecnico.tNombre  = '';
                this.fillBsqTecnico.tRfc     = '';
            },
            getListarTecnicos(){
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Listando técnicos...'
                })
                var url = '/operacion/tecnico/getListarTecnicos'
                axios.get(url, {
                    params: {
                        'tDni'   : this.fillBsqTecnico.tDni,
                        'tNombre'   : this.fillBsqTecnico.tNombre,
                        'tRfc'      : this.fillBsqTecnico.tRfc
                    }
                }).then(response => {
                    this.inicializarPaginacion();
                    this.listTecnicos =  response.data;
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
