final host = 'http://192.168.0.10:8080/EDG-PanaderiaFinal/public/api';

class Api {
  static final productoListar = host + '/web/producto';
  static final pedidoListar = host + '/movil/pedido';
  static final pedidoByCliente = host + '/movil/pedido_cliente/:id';
  static final pedidoBySucursal = host + '/movil/pedido_sucursal/:id';
  static final pedidoSetEntregado = host + '/movil/pedido_entregado/:id';
  static final clienteCreate = host + '/movil/register';
  static final login = host + '/movil/login';
  static final productoSucursalListar = host + '/movil/sucursal_producto/:id';
  static final sucursalListar = host + '/movil/sucursal';
}
