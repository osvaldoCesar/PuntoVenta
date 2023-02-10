<?php

namespace App\Http\Controllers\Administracion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class RolesController extends Controller
{

    public function getListarRoles(Request $request){
        if(!$request->ajax()) return redirect('/');


        $nIdRol    =      $request->nIdRol;
        $cNombre   =      $request->cNombre;
        $cSlug     =      $request->cSlug;

        $nIdRol    =      ($nIdRol   ==  NULL) ? ($nIdRol   = 0): $nIdRol;
        $cNombre   =      ($cNombre  ==  NULL) ? ($cNombre  = ''): $cNombre;
        $cSlug     =      ($cSlug    ==  NULL) ? ($cSlug    = ''): $cSlug;

        $rpta        =      DB::select('call sp_Rol_getListarRoles(?, ?, ?)',
                                                                    [
                                                                        $nIdRol,
                                                                        $cNombre,
                                                                        $cSlug
                                                                    ]);
        return $rpta;
    }

    public function getListarPermisosByRol(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdRol    =      $request->nIdRol;

        $nIdRol    =      ($nIdRol   ==  NULL) ? ($nIdRol   = 0): $nIdRol;
        $rpta = DB::select('call sp_Rol_getListarPermisosByRol (?)',[
                                                                    $nIdRol
                                                                ]);
        return $rpta;
    }

    public function setRegistrarRolPermisos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $cNombre   =      $request->cNombre;
        $cSlug     =      $request->cSlug;

        $cNombre   =      ($cNombre  ==  NULL) ? ($cNombre  = ''): $cNombre;
        $cSlug     =      ($cSlug ==  NULL) ? ($cSlug    = ''): $cSlug;




        try {
            // Irá todo el código que deseamos realizar y se ejecuta el commit
            DB::beginTransaction();

            $rpta        =      DB::select('call sp_Rol_setRegistrarRol(?, ?)',
            [
                                                                            $cNombre,
                                                                            $cSlug
                                                                        ]);

            $nIdRol =   $rpta[0]->nIdRol;
            $listPermisos       =    $request->listPermisosFilter;
            $listPermisosSize   =    sizeof($listPermisos);
            if ($listPermisosSize > 0) {
                foreach ($listPermisos as $key => $value) {
                    if ($value['checked'] == true) {
                        DB::select('call sp_Rol_setRegistrarRolPermiso(?, ?)',
                                                                    [
                                                                        $nIdRol,
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

    public function setEditarRolPermisos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdRol    =      $request->nIdRol;
        $cNombre   =      $request->cNombre;
        $cSlug     =      $request->cSlug;


        $nIdRol    =      ($nIdRol   ==  NULL) ? ($nIdRol  = ''): $nIdRol;
        $cNombre   =      ($cNombre  ==  NULL) ? ($cNombre  = ''): $cNombre;
        $cSlug     =      ($cSlug    ==  NULL) ? ($cSlug    = ''): $cSlug;




        try {
            // Irá todo el código que deseamos realizar y se ejecuta el commit
            DB::beginTransaction();

            $rpta        =      DB::select('call sp_Rol_setEditarRol(?, ?, ?)',
                                                                        [
                                                                            $nIdRol,
                                                                            $cNombre,
                                                                            $cSlug
                                                                        ]);

            $listPermisos       =    $request->listPermisosFilter;
            $listPermisosSize   =    sizeof($listPermisos);
            if ($listPermisosSize > 0) {
                foreach ($listPermisos as $key => $value) {
                    if ($value['checked'] == true) {
                        DB::select('call sp_Rol_setRegistrarRolPermiso(?, ?)',
                                                                    [
                                                                        $nIdRol,
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
}
