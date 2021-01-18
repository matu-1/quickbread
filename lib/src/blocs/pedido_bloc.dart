import 'dart:async';

import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/providers/pedido_provider.dart';

class PedidoBloc {
  static final _instance = new PedidoBloc._internal();
  final _pedidoStreamController =
      new StreamController<List<PedidoModel>>.broadcast();
  final _pedidoProvider = new PedidoProvider();

  PedidoBloc._internal();
  factory PedidoBloc() => _instance;

  void disponse() {
    _pedidoStreamController.close();
  }

  Stream<List<PedidoModel>> get pedidoStream => _pedidoStreamController.stream;

  set pedidoSink(List<PedidoModel> pedidos) {
    _pedidoStreamController.sink.add(pedidos);
  }

  getAll(String estado) async {
    try {
      pedidoSink = await _pedidoProvider.getAll(estado);
    } catch (e) {
      _pedidoStreamController.addError(e.message);
    }
  }

  getByCliente() async {
    print('se llamo');
    try {
      pedidoSink = await _pedidoProvider.getByCliente();
    } catch (e) {
      _pedidoStreamController.addError(e.message);
    }
  }
}
