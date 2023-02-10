<?php

namespace App\Mail;

use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Contracts\Queue\ShouldQueue;

class PedidoCrear extends Mailable
{
    use Queueable, SerializesModels;

    protected $rpta1, $rpta2, $logo;
    /**
     * Create a new message instance.
     *
     * @return void
     */
    public function __construct($rpta1, $rpta2, $logo)
    {
        $this->rpta1 = $rpta1;
        $this->rpta2 = $rpta2;
        $this->logo = $logo;
    }

    /**
     * Build the message.
     *
     * @return $this
     */
    public function build()
    {
        return $this->from($this->rpta1[0]->cVendedorCorreo)
                ->subject("Empresa de Prueba - Pedido #". $this->rpta1[0]->nNumeroPedido)
                ->view('reportes.pedido.pdf.ver')
                ->with([
                    'rpta1' =>  $this->rpta1,
                    'rpta2' =>  $this->rpta2,
                    'logo'  =>  $this->logo
                ])
                ->attach($this->logo);
    }
}
