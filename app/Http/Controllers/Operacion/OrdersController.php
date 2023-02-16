<?php

namespace App\Http\Controllers\Operacion;

use PDF;
use App\Mail\PedidoCrear;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;

class OrdersController extends Controller
{
    public function getListarPedidos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $cNombre        =      $request->cNombre;
        $cDocumento     =      $request->cDocumento;
        $cPedido        =      $request->cPedido;
        $cEstado        =      $request->cEstado;
        $dFechaCita      =   $request->dFechaCita;

        $cNombre        =    ($cNombre      ==  NULL)  ?  ($cNombre     =   '')  :  $cNombre;
        $cDocumento     =    ($cDocumento   ==  NULL)  ?  ($cDocumento  =   '')  :  $cDocumento;
        $cPedido        =    ($cPedido      ==  NULL)  ?  ($cPedido     =   '')  :  $cPedido;
        $cEstado        =    ($cEstado      ==  NULL)  ?  ($cEstado     =   '')  :  $cEstado;
        $dFechaCita      =      ($dFechaCita   ==  NULL) ? ($dFechaCita   =  '')    : $dFechaCita;

        $rpta        =      DB::select('call sp_Pedido_getListarPedidos(?, ?, ?, ?, ?)',
                                                                    [
                                                                        $cNombre,
                                                                        $cDocumento,
                                                                        $cPedido,
                                                                        $cEstado,
                                                                        $dFechaCita
                                                                    ]);
        return $rpta;
    }
    public function setRegistrarPedido(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdCliente     =    $request->nIdCliente;
        $nIdDoctor      =    $request->nIdDoctor;
        $cComentario    =    $request->cComentario;
        $fTotalPedido   =    $request->fTotalPedido;
        $listPedido     =    $request->listPedido;
        $dFechaCita      =   $request->dFechaCita;
        $nIdAuthUser    =    Auth::id();

        $cComentario     =      ($cComentario  ==  NULL) ? ($cComentario  =  '')    : $cComentario;
        $dFechaCita      =      ($dFechaCita   ==  NULL) ? ($dFechaCita   =  '')    : $dFechaCita;

        try {
            // Irá todo el código que deseamos realizar y se ejecuta el commit
            DB::beginTransaction();

            $rpta        =      DB::select('call sp_Pedido_setRegistrarPedido(?, ?, ?, ?, ?, ?)',
                                                                        [
                                                                            $nIdCliente,
                                                                            $nIdDoctor,
                                                                            $cComentario,
                                                                            $fTotalPedido,
                                                                            $dFechaCita,
                                                                            $nIdAuthUser
                                                                        ]);

            $nIdPedido =   $rpta[0]->nIdPedido;

            $listPedido       =    $request->listPedido;
            $listPedidoSize   =    sizeof($listPedido);
            if ($listPedidoSize > 0) {
                foreach ($listPedido as $key => $value) {
                    DB::select('call sp_Pedido_setRegistrarDetallePedido(?, ?, ?, ?)',
                                                                [
                                                                    $nIdPedido,
                                                                    $value['nIdProducto'],
                                                                    $value['nStock'],
                                                                    $value['fPrecio'],
                                                                ]);
                }
            }
            DB::commit();
            return $nIdPedido;
        } catch (Exception $e) {
            // Capturará algún error ocurrido en el try y se ejecuta el rollback
            DB::rollBack();
        }
    }
    // Listar Abonos del pedido
    public function getListarAbonoPedidos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdPedido       =      $request->nIdPedido;

        $nIdPedido       =    ($nIdPedido   ==  NULL)  ?  ($nIdPedido   =   0)   :  $nIdPedido;

        $rpta        =      DB::select('call sp_Pedido_getListarAbonoPedidos(?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);
        return $rpta;
    }

    public function setGenerarDocumento(Request $request)
    {
        if(!$request->ajax()) return redirect('/');

        $nIdPedido  =   $request->nIdPedido;

        $logo       =   public_path('img/AdminLTELogo.png');

        $rpta1       =   DB::select('call sp_Pedido_getPedido (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $rpta2       =   DB::select('call sp_Pedido_getDetallePedido (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $pdf = PDF::loadView('reportes.pedido.pdf.ver', [
            'rpta1' =>  $rpta1,
            'rpta2' =>  $rpta2,
            'logo'  =>  $logo
        ]);
        return $pdf->download('invoice.pdf');
    }
    public function setCambiarEstadoPedido(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdPedido          =      $request->nIdPedido;
        $cEstado            =      $request->cEstado;
        $nIdAuthUser        =      Auth::id();

        $nIdPedido  =   ($nIdPedido   ==   NULL) ? ($nIdPedido  =   0)   :   $nIdPedido;
        $cEstado    =   ($cEstado     ==   NULL) ? ($cEstado    =   0)   :   $cEstado;

        DB::select('call sp_Pedido_setCambiarEstadoPedido(?, ?, ?)',
                                                                    [
                                                                        $nIdPedido,
                                                                        $cEstado,
                                                                        $nIdAuthUser,
                                                                    ]);
    }
    public function setGenerarEmail(Request $request)
    {
        if(!$request->ajax()) return redirect('/');

        $nIdPedido  =   $request->nIdPedido;

        $logo       =   asset('img/AdminLTELogo.png');

        $rpta1       =   DB::select('call sp_Pedido_getPedido (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $rpta2       =   DB::select('call sp_Pedido_getDetallePedido (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);
        if ($rpta1[0]->cCorreo) {
            Mail::to($rpta1[0]->cCorreo)->send(new PedidoCrear($rpta1, $rpta2, $logo));
        }
    }
}
