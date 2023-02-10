<?php

namespace App\Http\Controllers;

use App\Exports\UsersExport;
use Illuminate\Http\Request;
use App\Exports\OrdersExport;
use Illuminate\Support\Facades\DB;
use Maatwebsite\Excel\Facades\Excel;

class ReportesController extends Controller
{
    public function getListarPedidos(Request $request)
    {
        if(!$request->ajax()) return redirect('/');

        $cNombre        =   $request->cNombre;
        $cDocumento     =   $request->cDocumento;
        $cPedido        =   $request->cPedido;
        $cEstado        =   $request->cEstado;
        $dFechaInicio   =   $request->dFechaInicio;
        $dFechaFin      =   $request->dFechaFin;

        $cNombre        =   ($cNombre   ==  NULL) ? ($cNombre   =   '') :   $cNombre;
        $cDocumento     =   ($cDocumento   ==  NULL) ? ($cDocumento   =   '') :   $cDocumento;
        $cPedido        =   ($cPedido   ==  NULL) ? ($cPedido   =   '') :   $cPedido;
        $cEstado        =   ($cEstado   ==  NULL) ? ($cEstado   =   '') :   $cEstado;
        $dFechaInicio   =   ($dFechaInicio   ==  NULL) ? ($dFechaInicio   =   '') :   $dFechaInicio;
        $dFechaFin      =   ($dFechaFin   ==  NULL) ? ($dFechaFin   =   '') :   $dFechaFin;

        $rpta       =   DB::select('call sp_Reporte_getListarPedidos (?, ?, ?, ?, ?, ?)',
                                                                [
                                                                    $cNombre,
                                                                    $cDocumento,
                                                                    $cPedido,
                                                                    $cEstado,
                                                                    $dFechaInicio,
                                                                    $dFechaFin
                                                                ]);
        return $rpta;
    }

    public function export(Request $request)
    {
        if(!$request->ajax()) return redirect('/');

        $listPedidos    =   json_decode($request->listPedidos);

        return (new OrdersExport)->getPedidos($listPedidos)->download('invoices.xlsx');

        // return Excel::download(new UsersExport, 'users.xlsx');
    }
}
