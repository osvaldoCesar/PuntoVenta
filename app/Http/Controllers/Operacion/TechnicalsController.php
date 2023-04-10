<?php

namespace App\Http\Controllers\Operacion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class TechnicalsController extends Controller
{
    public function getNuevoDniTecnico(Request $request){
        if(!$request->ajax()) return redirect('/');

        $rpta        =      DB::select('call sp_Tecnico_getNuevoDniTecnico()');
        return $rpta;
    }

    public function getListarTecnicos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdTecnico   =   $request->nIdTecnico;
        $tDni        =   $request->tDni;
        $tRfc        =   $request->tRfc;
        $tNombre     =   $request->tNombre;


        $nIdTecnico   =    ($nIdTecnico   ==  NULL)  ?  ($nIdTecnico  =    0)  :  $nIdTecnico;
        $tDni        =    ($tDni        ==  NULL)  ?  ($tDni       =   '')  :  $tDni;
        $tRfc        =    ($tRfc        ==  NULL)  ?  ($tRfc       =   '')  :  $tRfc;
        $tNombre     =    ($tNombre     ==  NULL)  ?  ($tNombre    =   '')  :  $tNombre;

        $rpta        =      DB::select('call sp_Tecnico_getListarTecnicos(?, ?, ?, ?)',
                                                                            [
                                                                                $nIdTecnico,
                                                                                $tDni,
                                                                                $tNombre,
                                                                                $tRfc,
                                                                            ]);
        return $rpta;
    }

    public function setRegistrarTecnico(Request $request){
        if(!$request->ajax()) return redirect('/');

        $tRfc           =      $request->tRfc;
        $tNombre        =      $request->tNombre;
        $tApellido      =      $request->tApellido;
        $tEmail         =      $request->tEmail;
        $tTelefono      =      $request->tTelefono;
        $nIdAuthUser    =      Auth::id();

        $tRfc     =    ($tRfc   ==  NULL)  ?  ($tRfc  =   '')  :  $tRfc;
        $tNombre        =    ($tNombre      ==  NULL)  ?  ($tNombre     =   '')  :  $tNombre;
        $tApellido      =    ($tApellido    ==  NULL)  ?  ($tApellido   =   '')  :  $tApellido;
        $tEmail         =    ($tEmail       ==  NULL)  ?  ($tEmail      =   '')  :  $tEmail;
        $tTelefono      =    ($tTelefono    ==  NULL)  ?  ($tTelefono   =   '')  :  $tTelefono;

        $rpta        =      DB::select('call sp_Tecnico_setRegistrarTecnico(?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $tRfc,
                                                                        $tNombre,
                                                                        $tApellido,
                                                                        $tEmail,
                                                                        $tTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
    public function setEditarTecnico(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdTecnico      =       $request->nIdTecnico;
        $tRfc     =       $request->tRfc;
        $tNombre        =       $request->tNombre;
        $tApellido      =       $request->tApellido;
        $tEmail         =       $request->tEmail;
        $tTelefono      =       $request->tTelefono;
        $nIdAuthUser    =       Auth::id();


        $nIdTecnico     =    ($nIdTecnico   ==  NULL)  ?  ($nIdTecnico  =   0)   :  $nIdTecnico;
        $tRfc     =    ($tRfc   ==  NULL)  ?  ($tRfc  =   '')  :  $tRfc;
        $tNombre        =    ($tNombre      ==  NULL)  ?  ($tNombre     =   '')  :  $tNombre;
        $tApellido      =    ($tApellido    ==  NULL)  ?  ($tApellido   =   '')  :  $tApellido;
        $tEmail         =    ($tEmail       ==  NULL)  ?  ($tEmail      =   '')  :  $tEmail;
        $tTelefono      =    ($tTelefono    ==  NULL)  ?  ($tTelefono   =   '')  :  $tTelefono;

        $rpta        =      DB::select('call sp_Tecnico_setEditarTecnico(?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdTecnico,
                                                                        $tRfc,
                                                                        $tNombre,
                                                                        $tApellido,
                                                                        $tEmail,
                                                                        $tTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
}
