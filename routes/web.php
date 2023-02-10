<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/

// Login
// Auth::routes();
Route::post('/authenticate/login/', "Auth\LoginController@login");

Route::group(['middleware' => ['auth']], function () {
    Route::post('/authenticate/logout/', "Auth\LoginController@logout");
    Route::get('/authenticate/getRefrescarUsuarioAutenticado', function () {
        return Auth::user()->load('file');
    });

    /* Usuarios*/
    Route::get("/administracion/usuario/getListarRolPermisosByUsuario", "Administracion\UsersController@getListarRolPermisosByUsuario");
    Route::get("/administracion/usuario/getListarUsuarios",  "Administracion\UsersController@getListarUsuarios");
    Route::post("/administracion/usuario/setRegistrarUsuario", "Administracion\UsersController@setRegistrarUsuario");
    Route::post("/administracion/usuario/setRegistrarUsuario", "Administracion\UsersController@setRegistrarUsuario");
    Route::post("/administracion/usuario/setEditarUsuario", "Administracion\UsersController@setEditarUsuario");
    Route::post("/administracion/usuario/setCambiarEstadoUsuario", "Administracion\UsersController@setCambiarEstadoUsuario");
    Route::post("/administracion/usuario/setEditarRolByUsuario", "Administracion\UsersController@setEditarRolByUsuario");
    Route::get("/administracion/usuario/getRolByUsuario", "Administracion\UsersController@getRolByUsuario");
    Route::get('/administracion/usuario/getListarPermisosByRolAsignado', "Administracion\UsersController@getListarPermisosByRolAsignado");
    Route::get('/administracion/usuario/getListarPermisosByUsuario', "Administracion\UsersController@getListarPermisosByUsuario");
    Route::post('/administracion/usuario/setRegistrarPermisosByUsuario', "Administracion\UsersController@setRegistrarPermisosByUsuario");

    /* Roles */
    Route::get("/administracion/rol/getListarRoles", "Administracion\RolesController@getListarRoles");
    Route::get("/administracion/rol/getListarPermisosByRol", "Administracion\RolesController@getListarPermisosByRol");
    Route::post("/administracion/rol/setRegistrarRolPermisos", "Administracion\RolesController@setRegistrarRolPermisos");
    Route::post("/administracion/rol/setEditarRolPermisos", "Administracion\RolesController@setEditarRolPermisos");

    /* Permisos */
    Route::get("/administracion/permiso/getListarPermisos", "Administracion\PermissionController@getListarPermisos");
    Route::post("/administracion/permiso/setRegistrarPermisos", "Administracion\PermissionController@setRegistrarPermisos");
    Route::post("/administracion/permiso/setEditarPermiso", "Administracion\PermissionController@setEditarPermiso");

    /* Archivos */
    Route::post('/archivo/setRegistrarArchivo', "FilesController@setRegistrarArchivo");

    /* Categorías */
    // Listar
    Route::get("/configuracion/categoria/getListarCategorias", "Configuracion\CategoriaController@getListarCategorias");
    // Crear
    Route::post("/configuracion/categoria/setRegistrarCategoria", "Configuracion\CategoriaController@setRegistrarCategoria");
    // Editar
    Route::post("/configuracion/categoria/setEditarCategoria", "Configuracion\CategoriaController@setEditarCategoria");

    /* Productos */
    // Listar
    Route::get("/configuracion/producto/getListarProductos", "Configuracion\ProductsController@getListarProductos");
    // Crear
    Route::post("/configuracion/producto/setRegistrarProducto", "Configuracion\ProductsController@setRegistrarProducto");
    // Editar
    Route::post("/configuracion/producto/setEditarProducto", "Configuracion\ProductsController@setEditarProducto");

    /* Pedidos */
    // Listar
    Route::get("/operacion/pedido/getListarPedidos", "Operacion\OrdersController@getListarPedidos");
    // Crear
    Route::post("/operacion/pedido/setRegistrarPedido", "Operacion\OrdersController@setRegistrarPedido");
    // Generar un Documento
    Route::post("/operacion/pedido/setGenerarDocumento", "Operacion\OrdersController@setGenerarDocumento");
    // Cambiar estado
    Route::post("/operacion/pedido/setCambiarEstadoPedido", "Operacion\OrdersController@setCambiarEstadoPedido");
    // Enviar Correo
    Route::post("/operacion/pedido/setGenerarEmail", "Operacion\OrdersController@setGenerarEmail");

    /* Clientes */
    // Listar
    Route::get("/operacion/cliente/getListarClientes", "Operacion\CustomersController@getListarClientes");
    // Crear
    Route::post("/operacion/cliente/setRegistrarCliente", "Operacion\CustomersController@setRegistrarCliente");
    // Editar
    Route::post("/operacion/cliente/setEditarCliente", "Operacion\CustomersController@setEditarCliente");

    /* Doctores */
    // Listar
    Route::get("/operacion/doctor/getListarDoctores", "Operacion\DoctorsController@getListarDoctores");
    // Crear
    Route::post("/operacion/doctor/setRegistrarCliente", "Operacion\DoctorsController@setRegistrarCliente");
    // Editar
    Route::post("/operacion/doctor/setEditarCliente", "Operacion\DoctorsController@setEditarCliente");

    /* Dashboard */
    // Productos más vendidos
    Route::get("/dashboard/getProductosMasVendidos", "DashboardController@getProductosMasVendidos");
    // Ventas por día
    Route::get("/dashboard/getVentasPorDia", "DashboardController@getVentasPorDia");

    /* Reportes */
    // Productos más vendidos
    Route::get("/reporte/pedido/getListarPedidos", "ReportesController@getListarPedidos");
    // Exportar a excel
    Route::get("/reporte/pedido/export", "ReportesController@export");
});


Route::get('/{optional?}', function () {
    return view('app');
})->name('basepath')
    ->where('optional', '.*');
