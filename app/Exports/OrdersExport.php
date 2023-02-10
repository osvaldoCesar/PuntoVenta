<?php

namespace App\Exports;

use Illuminate\Contracts\View\View;
use Maatwebsite\Excel\Concerns\FromView;
use Maatwebsite\Excel\Concerns\Exportable;
use Maatwebsite\Excel\Concerns\ShouldAutoSize;
use PhpOffice\PhpSpreadsheet\Style\NumberFormat;
use Maatwebsite\Excel\Concerns\WithColumnFormatting;

class OrdersExport implements FromView, ShouldAutoSize, WithColumnFormatting
{
    use Exportable;

    private $listPedidos = [];

    public function getPedidos($listPedidos)
    {
        $this->listPedidos = $listPedidos;

        return $this;
    }

    public function view(): View
    {
        return view('reportes.pedido.excel.pedido', [
            'pedidos' => $this->listPedidos
        ]);
    }

    public function columnFormats(): array
    {
        return [
            'A' => NumberFormat::FORMAT_NUMBER,
            'B' => NumberFormat::FORMAT_GENERAL,
            'C' => NumberFormat::FORMAT_GENERAL,
            'D' => NumberFormat::FORMAT_GENERAL,
            'E' => NumberFormat::FORMAT_NUMBER_00,
            'F' => NumberFormat::FORMAT_GENERAL,
        ];
    }
}
