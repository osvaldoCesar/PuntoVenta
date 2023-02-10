<?php

namespace App\Http\Controllers\Administracion;

use App\Events\Logout;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

class UsersController extends Controller
{
    public function getListarUsuarios(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario  =      $request->nIdUsuario;
        $cNombre     =      $request->cNombre;
        $cUsuario    =      $request->cUsuario;
        $cCorreo     =      $request->cCorreo;
        $cEstado     =      $request->cEstado;

        $nIdUsuario  =      ($nIdUsuario  == NULL) ? ($nIdUsuario  = 0) : $nIdUsuario;
        $cNombre     =      ($cNombre     == NULL) ? ($cNombre     = ''): $cNombre;
        $cUsuario    =      ($cUsuario    == NULL) ? ($cUsuario    = ''): $cUsuario;
        $cCorreo     =      ($cCorreo     == NULL) ? ($cCorreo     = ''): $cCorreo;
        $cEstado     =      ($cEstado     == NULL) ? ($cEstado     = ''): $cEstado;

        $rpta        =      DB::select('call sp_Usuario_getListarUsuarios(?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                        $cNombre,
                                                                        $cUsuario,
                                                                        $cCorreo,
                                                                        $cEstado
                                                                    ]);
        return $rpta;
    }

    public function setRegistrarUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $cPrimerNombre      =      $request->cPrimerNombre;
        $cSegundoNombre     =      $request->cSegundoNombre;
        $cApellido          =      $request->cApellido;
        $cUsuario           =      $request->cUsuario;
        $cCorreo            =      $request->cCorreo;
        $cContrasena        =      Hash::make($request->cContrasena);
        $oFotografia        =      $request->oFotografia;
        $nIdAuthUser        =      Auth::id();

        $cPrimerNombre      =      ($cPrimerNombre      ==      NULL) ? ($cPrimerNombre     =   '')     :   $cPrimerNombre;
        $cSegundoNombre     =      ($cSegundoNombre     ==      NULL) ? ($cSegundoNombre    =   '')     :   $cSegundoNombre;
        $cApellido          =      ($cApellido          ==      NULL) ? ($cApellido         =   '')     :   $cApellido;
        $cUsuario           =      ($cUsuario           ==      NULL) ? ($cUsuario          =   '')     :   $cUsuario;
        $cCorreo            =      ($cCorreo            ==      NULL) ? ($cCorreo           =   '')     :   $cCorreo;
        $cContrasena        =      ($cContrasena        ==      NULL) ? ($cContrasena       =   '')     :   $cContrasena;
        $oFotografia        =      ($oFotografia        ==      NULL) ? ($oFotografia       =   NULL)   :   $oFotografia;

        $rpta        =      DB::select('call sp_Usuario_setRegistrarUsuario(?, ?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $cPrimerNombre,
                                                                        $cSegundoNombre,
                                                                        $cApellido,
                                                                        $cUsuario,
                                                                        $cCorreo,
                                                                        $cContrasena,
                                                                        $oFotografia,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta[0]->nIdUsuario;
    }

    public function setEditarUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario         =      $request->nIdUsuario;
        $cPrimerNombre      =      $request->cPrimerNombre;
        $cSegundoNombre     =      $request->cSegundoNombre;
        $cApellido          =      $request->cApellido;
        $cUsuario           =      $request->cUsuario;
        $cCorreo            =      $request->cCorreo;
        $cContrasena        =      $request->cContrasena;
        $nIdAuthUser        =      Auth::id();
        if ($cContrasena != NULL) {
            $cContrasena    =      Hash::make($request->cContrasena);
        }
        $oFotografia        =      $request->oFotografia;

        $nIdUsuario         =      ($nIdUsuario         ==      NULL) ? ($nIdUsuario        =   '')     :   $nIdUsuario;
        $cPrimerNombre      =      ($cPrimerNombre      ==      NULL) ? ($cPrimerNombre     =   '')     :   $cPrimerNombre;
        $cSegundoNombre     =      ($cSegundoNombre     ==      NULL) ? ($cSegundoNombre    =   '')     :   $cSegundoNombre;
        $cApellido          =      ($cApellido          ==      NULL) ? ($cApellido         =   '')     :   $cApellido;
        $cUsuario           =      ($cUsuario           ==      NULL) ? ($cUsuario          =   '')     :   $cUsuario;
        $cCorreo            =      ($cCorreo            ==      NULL) ? ($cCorreo           =   '')     :   $cCorreo;
        $cContrasena        =      ($cContrasena        ==      NULL) ? ($cContrasena       =   '')     :   $cContrasena;


        // Crear un procedimiento para poder recibir el ID de la foto que tiene asignado el usuario y poderlo pasar a la variable
        // $oFotografia en caso de no querer actualizar la foto
        // $rpta        =      DB::select('call sp_Usuario_setEditarUsuario(?)',
        // [
        //     $nIdUsuario,
        // ]);

        $oFotografia        =      ($oFotografia        ==      NULL) ? ($oFotografia       =   NULL)   :   $oFotografia;

        $rpta        =      DB::select('call sp_Usuario_setEditarUsuario(?, ?, ?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                        $cPrimerNombre,
                                                                        $cSegundoNombre,
                                                                        $cApellido,
                                                                        $cUsuario,
                                                                        $cCorreo,
                                                                        $cContrasena,
                                                                        $oFotografia,
                                                                        $nIdAuthUser,
                                                                    ]);
    }

    public function setCambiarEstadoUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario         =      $request->nIdUsuario;
        $cEstado            =      $request->cEstado;
        $nIdAuthUser        =      Auth::id();

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   0)     :   $nIdUsuario;
        $cEstado      =      ($cEstado      ==      NULL) ? ($cEstado     =   0)     :   $cEstado;

        DB::select('call sp_Usuario_setCambiarEstadoUsuario(?, ?, ?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                        $cEstado,
                                                                        $nIdAuthUser,
                                                                    ]);
        if ($cEstado == 'I') {
            broadcast(new logout($nIdUsuario));
        }
    }

    public function setEditarRolByUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario    =      $request->nIdUsuario;
        $nIdRol        =      $request->nIdRol;

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   '')     :   $nIdUsuario;
        $nIdRol       =      ($nIdRol       ==      NULL) ? ($nIdRol      =   '')     :   $nIdRol;

        $rpta        =      DB::select('call sp_Usuario_setEditarRolByUsuario(?, ?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                        $nIdRol,
                                                                    ]);
    }

    public function getRolByUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario    =      $request->nIdUsuario;

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   '')     :   $nIdUsuario;

        $rpta        =      DB::select('call sp_Usuario_getRolByUsuario(?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                    ]);
        return $rpta;
    }

    public function getListarPermisosByRolAsignado(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario    =      $request->nIdUsuario;

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   '')     :   $nIdUsuario;

        $rpta        =      DB::select('call sp_Usuario_getListarPermisosByRolAsignado(?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                    ]);
        return $rpta;
    }

    public function getListarPermisosByUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario    =      $request->nIdUsuario;

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   0)     :   $nIdUsuario;

        $rpta        =      DB::select('call sp_Usuario_getListarPermisosByUsuario(?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                    ]);
        return $rpta;
    }

    public function setRegistrarPermisosByUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario    =      $request->nIdUsuario;

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   0)     :   $nIdUsuario;

        try {
            // Irá todo el código que deseamos realizar y se ejecuta el commit
            DB::beginTransaction();

            DB::select('call sp_Usuario_setEliminarPermisosByUsuario(?)',
                                                                [
                                                                    $nIdUsuario
                                                                ]);

            $listPermisos       =    $request->listPermisosFilter;
            $listPermisosSize   =    sizeof($listPermisos);
            if ($listPermisosSize > 0) {
                foreach ($listPermisos as $key => $value) {
                    if ($value['checked'] == true) {
                        DB::select('call sp_Usuario_setRegistrarPermisosByUsuario(?, ?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                        $value['id']
                                                                    ]);
                    }
                }
            }
            DB::commit();
        } catch (Exception $e) {
            // Capturará algún error ocurrido en el try y se ejecuta el rollback
            DB::rollBack();
        }
    }

    public function getListarRolPermisosByUsuario(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdUsuario    =      $request->nIdUsuario;

        if(!$nIdUsuario){
            $nIdUsuario     =   Auth::id();
        }

        $nIdUsuario   =      ($nIdUsuario   ==      NULL) ? ($nIdUsuario  =   0)     :   $nIdUsuario;

        $rpta        =      DB::select('call sp_Usuario_getListarRolPermisosByUsuario(?)',
                                                                    [
                                                                        $nIdUsuario,
                                                                    ]);
        return $rpta;
    }
}
