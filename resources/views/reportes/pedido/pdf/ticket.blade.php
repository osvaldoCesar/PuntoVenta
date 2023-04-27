<!DOCTYPE html>
<html lang="en">

<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>{{$rpta1[0]->nNumeroPedido}}</title>
    <style>
        @page {
            margin: 1.3rem;
            margin-top: 1.9rem;
            padding: 1rem;
        }

        body {
            margin: 0px;
        }

        * {
            font-family: verdana, arial, sans-serif;
        }

        .cabecera {
            background-color: #FEFEFE;
            color: #000000;
            padding: 2rem;
            padding-top: .2rem;
            padding-bottom: 0px;
        }

        .cabecera .logo {
            margin: 5px;
        }

        .cabecera table {
            padding: 1px;
            margin-bottom: .2rem;
        }

        table {
            font-size: x-small
        }

        tfoot tr td {
            font-weight: bold;
            font-size: x-small;
        }
    </style>
</head>

<body>
    <div class="cabecera">
        <table width="50%" cellspacing="1" align="center">
            <tr>
                <td>
                    <table width="100%" cellspacing="1" align="center">
                        <tr>
                            <td colspan="2" align="center">
                                <img src="{{$logo}}" alt="Logo de Welldent" class="logo" width="100" height="100">
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" width="100%" cellspacing="1" align="center">
                                Ticket de Welldent
                            </td>
                        </tr>
                        <tr>
                            <td align="center">#Pedido: {{$rpta1[0]->nNumeroPedido}}</td>
                            <td align="center">{{$date}}</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>

        @if (count($rpta2) > 0)
        <table width="50%" cellspacing="0" border="1" align="center">
            <thead style="background-color: lightgray;">
                <tr align="center" align="middle">
                    <th colspan="7">Detalle del Pedido</th>
                </tr>
                <tr>
                    <th>#</th>
                    <th>Producto</th>
                    <th>Cantidad</th>
                    <th>Precio</th>
                    <th>SubTotal</th>
                    <th>Descuento</th>
                    <th>Total</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($rpta2 as $key => $value)
                <tr>
                    <td align="center"><span>{{$key + 1}}</span></td>
                    <td align="center"><span>{{$value->cProducto}}</span></td>
                    <td align="center"><span>{{$value->nCantidad}}</span></td>
                    <td align="center"><span>${{number_format($value->fPrecio, 2)}}</span></td>
                    <td align="center"><span>${{number_format($value->fSubTotal, 2)}}</span></td>
                    <td align="center"><span>${{number_format($value->fDescuento, 2)}}</span></td>
                    <td align="center"><span>${{number_format($value->fTotal, 2)}}</span></td>
                </tr>
                @endforeach
            </tbody>
        </table>
        @endif

        @if (count($rpta3) > 0)
        <table width="50%" cellspacing="0" border="1" align="center">
            <thead style="background-color: lightgray;">
                <tr align="center" align="middle">
                    <th colspan="5">Detalle los Abonos</th>
                </tr>
                <tr>
                    <th>#</th>
                    <th>Cantidad abonada</th>
                    <th>Fecha de Abono</th>
                    <th>Comentario</th>
                    <th>Usuario</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($rpta3 as $key => $value)
                <tr>
                    <td align="center"><span>{{$key + 1}}</span></td>
                    <td align="center"><span>${{number_format($value->abonos, 2)}}</span></td>
                    <td align="center"><span>{{$value->fecha}}</span></td>
                    <td align="center"><span>{{$value->comentario}}</span></td>
                    <td align="center"><span>{{$value->vendedor}}</span></td>
                </tr>
                @endforeach
            </tbody>
        </table>
        <table width="30%" cellspacing="0" align="center">
            <tr>
                <td align="right"><strong>Abono:</strong></td>
                <td align="right">${{number_format($rpta4[0]->totalAbonos, 2)}}</td>
            </tr>
            <tr>
                <td align="right"><strong>Total:</strong></td>
                <td align="right">${{number_format($rpta4[0]->totalPedido, 2)}}</td>
            </tr>
            <tr>
                <td align="right"><strong>Restante:</strong></td>
                <td align="right">${{number_format($rpta4[0]->restante, 2)}}</td>
            </tr>
        </table>
        @else
        <table width="50%" cellspacing="0" align="center">
            <tr>
                <td colspan="2" align="center" style="margin-bottom: 15px !important;">
                    <strong>Sin abonos registrados</strong>
                </td>
            </tr>
            <tr>
                <td align="right"><strong>Total:</strong></td>
                <td align="right">${{number_format($rpta4[0]->totalPedido, 2)}}</td>
            </tr>
        </table>
        @endif
    </div>
</body>

</html>
