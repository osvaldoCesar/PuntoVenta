<?php

namespace App\Http\Controllers\Operacion;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;

class DoctorsController extends Controller
{
    public function getListarDoctores(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdDoctor    =   $request->nIdDoctor;
        $cRfcDoc       =   $request->cRfcDoc;
        $cNombreDoc    =   $request->cNombreDoc;


        $nIdDoctor     =    ($nIdDoctor   ==  NULL)  ?  ($nIdDoctor  =   0)   :  $nIdDoctor;
        $cRfcDoc        =    ($cRfcDoc      ==  NULL)  ?  ($cRfcDoc     =   '')  :  $cRfcDoc;
        $cNombreDoc     =    ($cNombreDoc   ==  NULL)  ?  ($cNombreDoc  =   '')  :  $cNombreDoc;

        $rpta        =      DB::select('call sp_doctor_getListardoctors(?, ?, ?)',
                                                                            [
                                                                                $nIdDoctor,
                                                                                $cNombreDoc,
                                                                                $cRfcDoc,
                                                                            ]);
        return $rpta;
    }
}
