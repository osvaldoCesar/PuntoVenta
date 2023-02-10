<?php

namespace App\Http\Controllers\Operacion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class CustomersController extends Controller
{
    public function getListarClientes(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdCliente    =   $request->nIdCliente;
        $cNombre       =   $request->cNombre;
        $cDocumento    =   $request->cDocumento;


        $nIdCliente     =    ($nIdCliente   ==  NULL)  ?  ($nIdCliente  =   0)   :  $nIdCliente;
        $cNombre        =    ($cNombre      ==  NULL)  ?  ($cNombre     =   '')  :  $cNombre;
        $cDocumento     =    ($cDocumento   ==  NULL)  ?  ($cDocumento  =   '')  :  $cDocumento;

        $rpta        =      DB::select('call sp_Cliente_getListarClientes(?, ?, ?)',
                                                                            [
                                                                                $nIdCliente,
                                                                                $cNombre,
                                                                                $cDocumento,
                                                                            ]);
        return $rpta;
    }
    public function setRegistrarCliente(Request $request){
        if(!$request->ajax()) return redirect('/');

        $cDocumento     =      $request->cDocumento;
        $cNombre        =      $request->cNombre;
        $cApellido      =      $request->cApellido;
        $cEmail         =      $request->cEmail;
        $cTelefono      =      $request->cTelefono;
        $nIdAuthUser    =      Auth::id();

        $cDocumento     =    ($cDocumento   ==  NULL)  ?  ($cDocumento  =   '')  :  $cDocumento;
        $cNombre        =    ($cNombre      ==  NULL)  ?  ($cNombre     =   '')  :  $cNombre;
        $cApellido      =    ($cApellido    ==  NULL)  ?  ($cApellido   =   '')  :  $cApellido;
        $cEmail         =    ($cEmail       ==  NULL)  ?  ($cEmail      =   '')  :  $cEmail;
        $cTelefono      =    ($cTelefono    ==  NULL)  ?  ($cTelefono   =   '')  :  $cTelefono;

        $rpta        =      DB::select('call sp_Cliente_setRegistrarCliente(?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $cDocumento,
                                                                        $cNombre,
                                                                        $cApellido,
                                                                        $cEmail,
                                                                        $cTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
    public function setEditarCliente(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdCliente    =   $request->nIdCliente;
        $cDocumento     =      $request->cDocumento;
        $cNombre        =      $request->cNombre;
        $cApellido      =      $request->cApellido;
        $cEmail         =      $request->cEmail;
        $cTelefono      =      $request->cTelefono;
        $nIdAuthUser    =      Auth::id();


        $nIdCliente     =    ($nIdCliente   ==  NULL)  ?  ($nIdCliente  =   0)   :  $nIdCliente;
        $cDocumento     =    ($cDocumento   ==  NULL)  ?  ($cDocumento  =   '')  :  $cDocumento;
        $cNombre        =    ($cNombre      ==  NULL)  ?  ($cNombre     =   '')  :  $cNombre;
        $cApellido      =    ($cApellido    ==  NULL)  ?  ($cApellido   =   '')  :  $cApellido;
        $cEmail         =    ($cEmail       ==  NULL)  ?  ($cEmail      =   '')  :  $cEmail;
        $cTelefono      =    ($cTelefono    ==  NULL)  ?  ($cTelefono   =   '')  :  $cTelefono;

        $rpta        =      DB::select('call sp_Cliente_setEditarCliente(?, ?, ?, ?, ?, ?, ?)',
                                                                    [
                                                                        $nIdCliente,
                                                                        $cDocumento,
                                                                        $cNombre,
                                                                        $cApellido,
                                                                        $cEmail,
                                                                        $cTelefono,
                                                                        $nIdAuthUser
                                                                    ]);
        return $rpta;
    }
}
