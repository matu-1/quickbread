import 'package:quickbread/src/constants/pedido_estado.dart';

abstract class IEstado {
  bool isMostrar(String estado);
}

class EstadoEntrega implements IEstado {
  @override
  bool isMostrar(String estado) {
    return estado == PedidoEstado.entregado;
  }
}

class EstadoAnulado implements IEstado {
  @override
  bool isMostrar(String estado) {
    return estado == PedidoEstado.anulado;
  }
}

class EstadoEspera implements IEstado {
  @override
  bool isMostrar(String estado) {
    return estado == PedidoEstado.enEspera;
  }
}