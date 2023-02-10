<template>
    <div class="login-page">
        <transition name="slide-fade" mode="out-in">
            <router-view></router-view>
        </transition>
    </div>
</template>

<script>
    export default {
        mounted() {
            this.getRefrescarUsuarioAutenticado();
        },
        methods: {
            getRefrescarUsuarioAutenticado() {
                if (this.$router.currentRoute.name != 'login') {
                    var url = '/authenticate/getRefrescarUsuarioAutenticado'
                    axios.get(url).then(response => {
                    }).catch(error => {
                        if (error.response.status == 401) {
                            this.$router.push({name: 'login'})
                            location.reload();
                            sessionStorage.clear();
                        }
                    })
                }
            },
        },
    }
</script>

<style>

</style>
