<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function getProductosMasVendidos(Request $request)
    {
        if(!$request->ajax()) return redirect('/');

        $rpta       =   DB::select('call sp_Dashboard_getProductosMasVendidos');
        return $rpta;
    }

    public function getVentasPorDia(Request $request)
    {
        if(!$request->ajax()) return redirect('/');

        $rpta       =   DB::select('call sp_Dashboard_getVentasPorDia');
        return $rpta;
    }
}
