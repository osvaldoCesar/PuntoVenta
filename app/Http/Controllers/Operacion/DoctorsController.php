<?php

namespace App\Http\Controllers\Operacion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class DoctorsController extends Controller
{
    public function getListarDoctores(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdDoctor   =   $request->nIdDoctor;
        $dRfc        =   $request->dRfc;
        $dNombre     =   $request->dNombre;


        $nIdDoctor   =    ($nIdDoctor   ==  NULL)  ?  ($nIdDoctor  =    0)  :  $nIdDoctor;
        $dRfc        =    ($dRfc        ==  NULL)  ?  ($dRfc       =   '')  :  $dRfc;
        $dNombre     =    ($dNombre     ==  NULL)  ?  ($dNombre    =   '')  :  $dNombre;

        $rpta        =      DB::select('call sp_Doctor_getListardoctors(?, ?, ?)',
                                                                            [
                                                                                $nIdDoctor,
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
}
