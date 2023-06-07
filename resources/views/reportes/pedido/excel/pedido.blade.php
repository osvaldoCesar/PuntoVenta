<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Document</title>
</head>
<body>
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Pedido</th>
                <th>Doctor</th>
                <th>Técnico</th>
                <th>Paciente</th>
                <th>Total</th>
                <th>Vendedor</th>
                <th>Estatus</th>
            </tr>
        </thead>
        <tbody>
            @foreach($pedidos as $key => $value)
                <tr>
                    <td>{{ $key+ 1}}</td>
                    <td>{{ $value->pedido }}</td>
                    <td>{{ $value->doctor }}</td>
                    <td>{{ $value->tecnico }}</td>
                    <td>{{ $value->paciente }}</td>
                    <td>{{ number_format($value->total, 2) }}</td>
                    <td>{{ $value->vendedor }}</td>
                    <td>{{ $value->state == 'A' ? 'Activo' : ($value->state == 'I' ? 'Rechazado' : 'Liquidado') }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
