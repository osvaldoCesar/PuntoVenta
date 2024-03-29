<?php

namespace App\Http\Controllers\Operacion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class DoctorsController extends Controller
{
    public function getNuevoDniDoctor(Request $request){
        if(!$request->ajax()) return redirect('/');

        $rpta        =      DB::select('call sp_Doctor_getNuevoDniDoctor()');
        return $rpta;
    }

    public function getListarDoctores(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdDoctor   =   $request->nIdDoctor;
        $dDni        =   $request->dDni;
        $dRfc        =   $request->dRfc;
        $dNombre     =   $request->dNombre;


        $nIdDoctor   =    ($nIdDoctor   ==  NULL)  ?  ($nIdDoctor  =    0)  :  $nIdDoctor;
        $dDni        =    ($dDni        ==  NULL)  ?  ($dDni       =   '')  :  $dDni;
        $dRfc        =    ($dRfc        ==  NULL)  ?  ($dRfc       =   '')  :  $dRfc;
        $dNombre     =    ($dNombre     ==  NULL)  ?  ($dNombre    =   '')  :  $dNombre;

        $rpta        =      DB::select('call sp_Doctor_getListarDoctores(?, ?, ?, ?)',
                                                                            [
                                                                                $nIdDoctor,
                                                                                $dDni,
                                                                                $dNombre,
                                                                                $dRfc,
                                                                            ]);
        return $rpta;
    }

    public function setRegistrarDoctor(Request $request){
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

        $rpta        =      DB::select('call sp_Doctor_setRegistrarDoctor(?, ?, ?, ?, ?, ?)',
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
    public function setEditarDoctor(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdDoctor      =       $request->nIdDoctor;
        $dRfc     =       $request->dRfc;
        $dNombre        =       $request->dNombre;
        $dApellido      =       $request->dApellido;
        $dEmail         =       $request->dEmail;
        $dTelefono      =       $request->dTelefono;
        $nIdAuthUser    =       Auth::id();


        $nIdDoctor     =    ($nIdDoctor   ==  NULL)  ?  ($nIdDoctor  =   0)   :  $nIdDoctor;
        $dRfc     =    ($dRfc   ==  NULL)  ?  ($dRfc  =   '')  :  $dRfc;
        $dNombre        =    ($dNombre      ==  NULL)  ?  ($dNombre     =   '')  :  $dNombre;
        $dApellido      =    ($dApellido    ==  NULL)  ?  ($dApellido   =   '')  :  $dApellido;
        $dEmail         =    ($dEmail       ==  NULL)  ?  ($dEmail      =   '')  :  $dEmail;
        $dTelefono      =    ($dTelefono    ==  NULL)  ?  ($dTelefono   =   '')  :  $dTelefono;

        $rpta        =      DB::select('call sp_Doctor_setEditarDoctor(?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdDoctor,
                                                                        $dRfc,
                                                                        $dNombre,
                                                                        $dApellido,
                                                                        $dEmail,
                                                                        $dTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }

    public function getNuevoDniPaciente(Request $request){
        if(!$request->ajax()) return redirect('/');

        $rpta        =      DB::select('call sp_Paciente_getNuevoDniPaciente()');
        return $rpta;
    }

    public function getListarPacientes(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdPaciente  =   $request->nIdPaciente;
        $nIdDoctor    =   $request->nIdDoctor;
        $pDni         =   $request->pDni;
        $pNombre      =   $request->pNombre;


        $nIdPaciente  =    ($nIdPaciente   ==  NULL)  ?  ($nIdPaciente  =   0)   :  $nIdPaciente;
        $nIdDoctor    =    ($nIdDoctor     ==  NULL)  ?  ($nIdDoctor    =    0)  :  $nIdDoctor;
        $pDni         =    ($pDni          ==  NULL)  ?  ($pDni         =   '')  :  $pDni;
        $pNombre      =    ($pNombre       ==  NULL)  ?  ($pNombre      =   '')  :  $pNombre;

        $rpta         =      DB::select('call sp_Paciente_getListarPacientes(?, ?, ?, ?)',
                                                                            [
                                                                                $nIdPaciente,
                                                                                $nIdDoctor,
                                                                                $pDni,
                                                                                $pNombre,
                                                                            ]);
        return $rpta;
    }

    public function setRegistrarPaciente(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdDoctor    =   $request->nIdDoctor;
        $pRfc           =      $request->pRfc;
        $pNombre        =      $request->pNombre;
        $pApellido      =      $request->pApellido;
        $pEmail         =      $request->pEmail;
        $pTelefono      =      $request->pTelefono;
        $nIdAuthUser    =      Auth::id();

        $nIdDoctor    =    ($nIdDoctor     ==  NULL)  ?  ($nIdDoctor    =    0)  :  $nIdDoctor;
        $pRfc           =    ($pRfc   ==  NULL)  ?  ($pRfc  =   '')  :  $pRfc;
        $pNombre        =    ($pNombre      ==  NULL)  ?  ($pNombre     =   '')  :  $pNombre;
        $pApellido      =    ($pApellido    ==  NULL)  ?  ($pApellido   =   '')  :  $pApellido;
        $pEmail         =    ($pEmail       ==  NULL)  ?  ($pEmail      =   '')  :  $pEmail;
        $pTelefono      =    ($pTelefono    ==  NULL)  ?  ($pTelefono   =   '')  :  $pTelefono;

        $rpta        =      DB::select('call sp_Paciente_setRegistrarPaciente(?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdDoctor,
                                                                        $pRfc,
                                                                        $pNombre,
                                                                        $pApellido,
                                                                        $pEmail,
                                                                        $pTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
}
