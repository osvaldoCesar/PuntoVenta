<template>
    <div>
        <div class="content-header">
            <div class="container-fluid">
                <div class="row mb-2">
                    <div class="col-sm-6">
                        <h1 class="m-0">Dashboard</h1>
                    </div><!-- /.col -->
                </div><!-- /.row -->
            </div><!-- /.container-fluid -->
        </div>

        <div class="content container-fluid">
            <div class="card">
                <div class="card-body">
                    <div class="container-fluid">
                        <div class="row">
                            <template v-if="listaRolPermisosByUsuario.includes('productos.mas.vendidos')">
                                <div class="col-md-6">
                                    <canvas id="myChart" width="400" height="400"></canvas>
                                </div>
                            </template>
                            <template v-if="listaRolPermisosByUsuario.includes('ventas.por.dia')">
                                <div class="col-md-6">
                                    <canvas id="myChart2" width="400" height="400"></canvas>
                                </div>
                            </template>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import Chart from 'chart.js';
    export default {
        data(){
            return{
                listProductosMasVendidos: {
                    all: [],
                    name: [],
                    cantidad: [],
                    colores: [],
                },
                listVentasPorDia: {
                    all: [],
                    name: [],
                    cantidad: [],
                },
                listaRolPermisosByUsuario: JSON.parse(sessionStorage.getItem('listRolPermisosByUsuario')),
            }
        },
        mounted(){
            const loading = this.$vs.loading({
                type: 'points',
                color: '#90A637',
                background: '#DBE6B1',
                text: 'Cargando...'
            })
            this.getProductosMasVendidos();
            this.getVentasPorDia();
            loading.close();
        },
        methods: {
            getProductosMasVendidos(){
                var ruta = '/dashboard/getProductosMasVendidos';
                axios.get(ruta).then(response => {
                    this.listProductosMasVendidos.all = response.data;
                    this.getProductosMasVendidosFiltrar();
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
            getProductosMasVendidosFiltrar(){
                let me = this;
                this.listProductosMasVendidos.all.map(function(x, y) {
                    me.listProductosMasVendidos.name.push(x.name);
                    me.listProductosMasVendidos.cantidad.push(x.cantidad);

                    // Colores
                    let parametro1 = Math.floor(Math.random() * 256)
                    let parametro2 = Math.floor(Math.random() * 256)
                    let parametro3 = Math.floor(Math.random() * 256)
                    let color = 'rgba('+parametro1+', '+parametro2+', '+parametro3+', 0.2)';
                    me.listProductosMasVendidos.colores.push(color);
                })
                this.getGraficoBar();
            },
            getGraficoBar(){
                let me = this;
                var ctx = document.getElementById('myChart');
                var myChart = new Chart(ctx, {
                    type: 'bar',
                    data: {
                        labels: me.listProductosMasVendidos.name,
                        datasets: [{
                            label: 'Gráfico: Productos más vendidos',
                            data: me.listProductosMasVendidos.cantidad,
                            backgroundColor: me.listProductosMasVendidos.colores,
                            borderColor: me.listProductosMasVendidos.colores,
                            borderWidth: 1
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    }
                });
            },
            getVentasPorDia(){
                var ruta = '/dashboard/getVentasPorDia';
                axios.get(ruta).then(response => {
                    this.listVentasPorDia.all = response.data;
                    this.getVentasPorDiaFiltrar();
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
            getVentasPorDiaFiltrar(){
                let me = this;
                this.listVentasPorDia.all.map(function(x, y) {
                    me.listVentasPorDia.name.push(x.dia);
                    me.listVentasPorDia.cantidad.push(x.total);
                })
                this.getGraficoLine();
            },
            getGraficoLine(){
                let me = this;
                var ctx = document.getElementById('myChart2');
                var myChart = new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: me.listVentasPorDia.name,
                        datasets: [{
                            label: 'Gráfico: Ventas por día',
                            data: me.listVentasPorDia.cantidad
                        }]
                    },
                    options: {
                        scales: {
                            yAxes: [{
                                ticks: {
                                    beginAtZero: true
                                }
                            }]
                        }
                    }
                });
            }
        },
    }
</script>

<style>

</style>
