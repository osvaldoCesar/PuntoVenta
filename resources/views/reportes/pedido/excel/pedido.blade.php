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
                <th>#Documento</th>
                <th>Cliente</th>
                <th>Total</th>
                <th>Vendedor</th>
            </tr>
        </thead>
        <tbody>
            @foreach($pedidos as $key => $value)
                <tr>
                    <td>{{ $key+ 1}}</td>
                    <td>{{ $value->pedido }}</td>
                    <td>{{ $value->documento }}</td>
                    <td>{{ $value->cliente }}</td>
                    <td>{{ number_format($value->total, 2) }}</td>
                    <td>{{ $value->vendedor }}</td>
                </tr>
            @endforeach
        </tbody>
    </table>
</body>
</html>
