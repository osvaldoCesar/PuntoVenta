<template>
    <div class="login-box">
        <!-- /.login-logo -->
        <div class="card card-outline card-primary">
            <div class="card-header text-center">
                <router-link class="h1" :to="{name:'login'}">
                    <b>Iniciar Sesión</b>
                </router-link>

            </div>
            <div class="card-body">
                <p class="login-box-msg">Ingresa tus credenciales para Iniciar Sesión</p>
                <form method="post">
                    <div class="input-group mb-3">
                        <vs-input :state="(error) ? 'danger' : ''" @keyup.enter="login" icon-after v-model="fillLogin.cEmail" label-placeholder="Correo electrónico">
                            <template #icon>
                            <i class='fas fa-envelope'></i>
                            </template>
                        </vs-input>
                    </div>
                    <div class="input-group mb-3">
                        <vs-input :state="(error) ? 'danger' : ''" type="password" icon-after @keyup.enter="login" v-model="fillLogin.cContrasena" label-placeholder="Password">
                            <template #icon>
                            <i class='fas fa-lock'></i>
                            </template>
                        </vs-input>
                    </div>
                </form>

                <div class="row">
                    <div class="col-md-12">
                        <span v-if="error">
                            <vs-alert class="mb-2" border v-for="(e, index) in mensajeError" :key="index" danger flat>
                               <div v-text="e"></div>
                            </vs-alert>
                            <!-- <div v-for="(e, index) in mensajeError" :key="index" v-text="e" class="callout callout-danger"></div> -->
                        </span>
                    </div>
                </div>

                <div class="social-auth-links text-center mt-2 mb-3">
                    <vs-button class="col-12" circle success size="large" flat :active="active == 1" @click="active = 1" @click.prevent="login">Iniciar Sesión</vs-button>
                </div>
                <!-- /.social-auth-links -->
            </div>
            <!-- /.card-body -->
        </div>
        <!-- /.card -->
    </div>
</template>

<script>
// import axios from 'axios';
    export default {
        data() {
            return {
                fillLogin: {
                    cEmail: '',
                    cContrasena: '',
                },
                listRolPermisosByUsuario: [],
                listRolPermisosByUsuarioFilter: [],
                fullscreenLoading: false,
                error: 0,
                mensajeError: [],
            }
        },
        methods: {
            login(){
                if (this.validarLogin()){
                    return;
                }
                const loading = this.$vs.loading({
                    type: 'points',
                    color: '#90A637',
                    background: '#DBE6B1',
                    text: 'Iniciando sesión...'
                })
                var url = '/authenticate/login'
                axios.post(url,{
                    'cEmail'       :  this.fillLogin.cEmail,
                    'cContrasena'  :  this.fillLogin.cContrasena,
                }).then(response =>{
                    // console.log( reponse.data );
                    if (response.data.code == 401) {
                        this.loginFailed();
                    }
                     if (response.data.code == 200) {
                        this.getListarRolPermisosByUsuario(response.data.authUser);
                    }
                    setTimeout(() => {
                        loading.close()
                    }, 3000)
                })
            },
            getListarRolPermisosByUsuario(authUser){
                var ruta = '/administracion/usuario/getListarRolPermisosByUsuario';
                axios.get(ruta, {
                    params: {
                        'nIdUsuario' : authUser.id
                    }
                }).then(response => {
                    this.listRolPermisosByUsuario = response.data;
                    this.filterListarRolPermisosByUsuario(authUser);
                })
            },
            filterListarRolPermisosByUsuario(authUser){
                let me = this;
                me.listRolPermisosByUsuario.map(function(x, y){
                    me.listRolPermisosByUsuarioFilter.push(x.slug);
                });
                sessionStorage.setItem('listRolPermisosByUsuario', JSON.stringify(me.listRolPermisosByUsuarioFilter));
                sessionStorage.setItem('authUser', JSON.stringify(authUser));
                this.loginSuccess();
            },
            validarLogin(){
                this.error = 0;
                this.mensajeError = [];

                if(!this.fillLogin.cEmail){
                    this.mensajeError.push("El correo electrónico es un campo obligatorio")
                }
                if(!this.fillLogin.cContrasena){
                    this.mensajeError.push("La contraseña es un campo obligatorio")
                }

                if(this.mensajeError.length){
                    this.error = 1;
                }
                return this.error;
            },
            loginFailed(){
                this.error = 0;
                this.mensajeError = [];

                this.mensajeError.push("Estas credenciales no coinciden con nuestros registros");
                this.fillLogin.cContrasena = '';

                if(this.mensajeError.length){
                    this.error = 1;
                }
                return this.error;
            },
            loginSuccess(){
                this.$router.push({name: 'dashboard.index'});
                location.reload();
            }
        },
    }
</script>

<style>

</style>
