<?php

namespace App\Http\Controllers\Operacion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class TechnicalsController extends Controller
{
    public function getListarTecnicos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdTecnico   =   $request->nIdTecnico;
        $dRfc        =   $request->dRfc;
        $dNombre     =   $request->dNombre;


        $nIdTecnico   =    ($nIdTecnico   ==  NULL)  ?  ($nIdTecnico  =    0)  :  $nIdTecnico;
        $dRfc        =    ($dRfc        ==  NULL)  ?  ($dRfc       =   '')  :  $dRfc;
        $dNombre     =    ($dNombre     ==  NULL)  ?  ($dNombre    =   '')  :  $dNombre;

        $rpta        =      DB::select('call sp_Tecnico_getListarTecnicos(?, ?, ?)',
                                                                            [
                                                                                $nIdTecnico,
                                                                                $dNombre,
                                                                                $dRfc,
                                                                            ]);
        return $rpta;
    }

    public function setRegistrarTecnico(Request $request){
        if(!$request->ajax()) return redirect('/');

        $dRfc           =      $request->dRfc;
        $dNombre        =      $request->dNombre;
        $dApellido      =      $request->dApellido;
        $dEmail         =      $request->dEmail;
        $dTelefono      =      $request->dTelefono;
        $nIdAuthUser    =      Auth::id();

        $dRfc     =    ($dRfc   ==  NULL)  ?  ($dRfc  =   '')  :  $dRfc;
        $dNombre        =    ($dNombre      ==  NULL)  ?  ($dNombre     =   '')  :  $dNombre;
        $dApellido      =    ($dApellido    ==  NULL)  ?  ($dApellido   =   '')  :  $dApellido;
        $dEmail         =    ($dEmail       ==  NULL)  ?  ($dEmail      =   '')  :  $dEmail;
        $dTelefono      =    ($dTelefono    ==  NULL)  ?  ($dTelefono   =   '')  :  $dTelefono;

        $rpta        =      DB::select('call sp_Tecnico_setRegistrarTecnico(?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $dRfc,
                                                                        $dNombre,
                                                                        $dApellido,
                                                                        $dEmail,
                                                                        $dTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
    public function setEditarTecnico(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdTecnico      =       $request->nIdTecnico;
        $dRfc     =       $request->dRfc;
        $dNombre        =       $request->dNombre;
        $dApellido      =       $request->dApellido;
        $dEmail         =       $request->dEmail;
        $dTelefono      =       $request->dTelefono;
        $nIdAuthUser    =       Auth::id();


        $nIdTecnico     =    ($nIdTecnico   ==  NULL)  ?  ($nIdTecnico  =   0)   :  $nIdTecnico;
        $dRfc     =    ($dRfc   ==  NULL)  ?  ($dRfc  =   '')  :  $dRfc;
        $dNombre        =    ($dNombre      ==  NULL)  ?  ($dNombre     =   '')  :  $dNombre;
        $dApellido      =    ($dApellido    ==  NULL)  ?  ($dApellido   =   '')  :  $dApellido;
        $dEmail         =    ($dEmail       ==  NULL)  ?  ($dEmail      =   '')  :  $dEmail;
        $dTelefono      =    ($dTelefono    ==  NULL)  ?  ($dTelefono   =   '')  :  $dTelefono;

        $rpta        =      DB::select('call sp_Tecnico_setEditarTecnico(?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdTecnico,
                                                                        $dRfc,
                                                                        $dNombre,
                                                                        $dApellido,
                                                                        $dEmail,
                                                                        $dTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
}
