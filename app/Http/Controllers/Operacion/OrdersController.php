<?php

namespace App\Http\Controllers\Operacion;

use PDF;
use App\Mail\PedidoCrear;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;
use Carbon\Carbon;
use Mike42\Escpos;
use Mike42\Escpos\Printer;
use Mike42\Escpos\PrintConnectors\WindowsPrintConnector;
use Mike42\Escpos\PrintConnectors\FilePrintConnector;
use Mike42\Escpos\PrintBuffers\ImagePrintBuffer;
use Mike42\Escpos\CapabilityProfiles\DefaultCapabilityProfile;
use Mike42\Escpos\CapabilityProfiles\SimpleCapabilityProfile;
use Illuminate\Support\Str;

class OrdersController extends Controller
{
    public function getListarPedidos(Request $request){
        if(!$request->ajax()) return redirect('/');

        $dNombre        =      $request->dNombre;
        $pNombre     =      $request->pNombre;
        $cPedido        =      $request->cPedido;
        $cEstado        =      $request->cEstado;
        $dFechaCita      =   $request->dFechaCita;

        $dNombre        =    ($dNombre      ==  NULL)  ?  ($dNombre     =   '')  :  $dNombre;
        $pNombre     =    ($pNombre   ==  NULL)  ?  ($pNombre  =   '')  :  $pNombre;
        $cPedido        =    ($cPedido      ==  NULL)  ?  ($cPedido     =   '')  :  $cPedido;
        $cEstado        =    ($cEstado      ==  NULL)  ?  ($cEstado     =   '')  :  $cEstado;
        $dFechaCita      =      ($dFechaCita   ==  NULL) ? ($dFechaCita   =  '')    : $dFechaCita;

        $rpta        =      DB::select('call sp_Pedido_getListarPedidos(?, ?, ?, ?, ?)',
                                                                    [
                                                                        $dNombre,
                                                                        $pNombre,
                                                                        $cPedido,
                                                                        $cEstado,
                                                                        $dFechaCita
                                                                    ]);
        return $rpta;
    }
    public function setRegistrarPedido(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdTecnico     =    $request->nIdTecnico;
        $nIdPaciente    =    $request->nIdPaciente;
        $cComentario    =    $request->cComentario;
        $fTotalPedido   =    $request->fTotalPedido;
        $listPedido     =    $request->listPedido;
        $dFechaCita     =   $request->dFechaCita;
        $nIdAuthUser    =    Auth::id();

        $cComentario     =      ($cComentario  ==  NULL) ? ($cComentario  =  '')    : $cComentario;
        $dFechaCita      =      ($dFechaCita   ==  NULL) ? ($dFechaCita   =  '')    : $dFechaCita;

        try {
            // Irá todo el código que deseamos realizar y se ejecuta el commit
            DB::beginTransaction();

            $rpta        =      DB::select('call sp_Pedido_setRegistrarPedido(?, ?, ?, ?, ?, ?)',
                                                                        [
                                                                            $nIdPaciente,
                                                                            $nIdTecnico,
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
                    DB::select('call sp_Pedido_setRegistrarDetallePedido(?, ?, ?, ?, ?)',
                                                                [
                                                                    $nIdPedido,
                                                                    $value['nIdProducto'],
                                                                    $value['nStock'],
                                                                    $value['fPrecio'],
                                                                    $value['fDescuento'],
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

    // Listar totales
    public function getListarTotales(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdPedido       =      $request->nIdPedido;

        $nIdPedido       =    ($nIdPedido   ==  NULL)  ?  ($nIdPedido   =   0)   :  $nIdPedido;

        $rpta        =      DB::select('call sp_Pedido_getListarTotales(?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);
        return $rpta;
    }

    public function setRegistrarAbono(Request $request){
        if(!$request->ajax()) return redirect('/');

        $nIdPedido      =    $request->nIdPedido;
        $fAbono         =    $request->fAbono;
        $cComentario    =    $request->cComentario;

        $nIdAuthUser    =    Auth::id();

        $cComentario    =      ($cComentario  ==  NULL) ? ($cComentario  =  '')    : $cComentario;

        $rpta           =      DB::select('call sp_Pedido_setRegistrarAbono(?, ?, ?, ?)',
                                                                    [
                                                                        $nIdPedido,
                                                                        $fAbono,
                                                                        $cComentario,
                                                                        $nIdAuthUser
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

        $rpta3       =   DB::select('call sp_Pedido_getListarAbonoPedidos (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $rpta4       =   DB::select('call sp_Pedido_getListarTotales (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);
        $pdf = PDF::loadView('reportes.pedido.pdf.ver', [
            'rpta1' =>  $rpta1,
            'rpta2' =>  $rpta2,
            'rpta3' =>  $rpta3,
            'rpta4' =>  $rpta4,
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

    public function setGenerarTicket(Request $request)
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

        $rpta3       =   DB::select('call sp_Pedido_getListarAbonoPedidos (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $rpta4       =   DB::select('call sp_Pedido_getListarTotales (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $date = Carbon::now();

        $pdf = PDF::loadView('reportes.pedido.pdf.ticket', [
            'rpta1' =>  $rpta1,
            'rpta2' =>  $rpta2,
            'rpta3' =>  $rpta3,
            'rpta4' =>  $rpta4,
            'date' =>  $date->format('d-m-Y - h:i:s A'),
            'logo'  =>  $logo
        ]);
        return $pdf->download('invoice.pdf');
    }

    public function setGenerarTicket2(Request $request){
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

        $rpta3       =   DB::select('call sp_Pedido_getListarAbonoPedidos (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);

        $rpta4       =   DB::select('call sp_Pedido_getListarTotales (?)',
                                                                    [
                                                                        $nIdPedido
                                                                    ]);


        $nombreImpresora = "POS-58";
        $connector = new WindowsPrintConnector($nombreImpresora);
        $impresora = new Printer($connector);
        $logo       =   public_path('img/AdminLTELogo.png');
        $impresora->setJustification(Printer::JUSTIFY_LEFT);

        // 32 espacios
        $impresora->text("AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA");
        $impresora->text("Prod  ");
        $impresora->text("Cant ");
        $impresora->text("P.Uni ");
        $impresora->text("SubT ");
        $impresora->text("Desc ");
        $impresora->text("Total");
        foreach ($rpta2 as $key => $value) {
            $impresora->text((strlen(($value->cProducto)) >= 6) ? Str::contains($value->cProducto, 'Cor') : ($value->cProducto));
            $impresora->text((strlen(($value->nCantidad)) <= 2) ? '  '. ($value->nCantidad).'  ' : '  '. ($value->nCantidad).' ');
            $impresora->text((strlen(($value->fPrecio)) <= 4) ? ' '. ($value->fPrecio).' ' : ($value->fPrecio));
            $impresora->text((strlen(($value->fSubTotal)) <= 4) ? ' '. ($value->fSubTotal).' ' : ($value->fSubTotal));
            $impresora->text((strlen(($value->fDescuento)) <= 4) ? ' '. ($value->fDescuento).' ' : ($value->fDescuento));
            $impresora->text($value->fTotal);
        }
        $impresora->setTextSize(1, 1);
        $impresora->feed(3);
        $impresora->close();
        return $rpta1;
    }
}
