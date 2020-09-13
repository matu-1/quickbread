final host = 'http://192.168.0.10/EDG-PanaderiaFinal/public/api';

class Api {
  static final productoListar = host + '/web/producto';
  static final pedidoListar = host + '/web/pedido';
  static final pedidoByCliente = host + '/movil/pedido_cliente/:id';
  static final clienteCreate = host + '/mob/register';
  static final login = host + '/mob/login';
}

final api = {
  'producto': {
    'listar': host + '/web/producto',
  },
  'pedido': {
    'listar': host + '/web/pedido',
  }
};
