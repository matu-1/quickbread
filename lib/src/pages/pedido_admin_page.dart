import 'package:flutter/material.dart';
import 'package:quickbread/src/blocs/pedido_bloc.dart';
import 'package:quickbread/src/constants/path.dart';
import 'package:quickbread/src/constants/pedido_estado.dart';
import 'package:quickbread/src/constants/ui.dart';
import 'package:quickbread/src/models/pedido_model.dart';
import 'package:quickbread/src/pages/pedido_detalle_admin_page.dart';
import 'package:quickbread/src/widgets/chip_custom.dart';
import 'package:quickbread/src/widgets/error_custom.dart';

class PedidoAdminPage extends StatefulWidget {
  static final routeName = 'pedidoNuevo';

  @override
  _PedidoAdminPageState createState() => _PedidoAdminPageState();
}

class _PedidoAdminPageState extends State<PedidoAdminPage>
    with SingleTickerProviderStateMixin {
  final _pedidoBloc = new PedidoBloc();
  TabController _tabController;
  final _tabs = [
    Tab(text: 'NUEVO'),
    Tab(text: 'ENTREGADO'),
    Tab(text: 'ANULADO'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: _tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pedidos'),
        actions: [
          IconButton(
              tooltip: 'Recargar',
              icon: Icon(Icons.refresh),
              onPressed: () => filterPedidos(_tabController.index))
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _PedidoList(index: 0),
          _PedidoList(
            index: 1,
          ),
          _PedidoList(
            index: 2,
          )
        ],
      ),
    );
  }

  void filterPedidos(index) {
    switch (index) {
      case 0:
        _pedidoBloc.getAll(PedidoEstado.enProceso);
        break;
      case 1:
        _pedidoBloc.getAll(PedidoEstado.entregado);
        break;
      case 2:
        _pedidoBloc.getAll(PedidoEstado.anulado);
        break;
      default:
        _pedidoBloc.getAll(PedidoEstado.enProceso);
    }
  }
}

class _PedidoList extends StatelessWidget {
  final _pedidoBloc = new PedidoBloc();
  final int index;
  _PedidoList({@required this.index});

  @override
  Widget build(BuildContext context) {
    filterPedidos(index);
    return Container(key: PageStorageKey('pedido$index'), child: _pedidoList());
  }

  Widget _pedidoList() {
    // List<PedidoModel> pedidos = pedidosFromJsonList(pedidosData);
    return StreamBuilder(
      stream: _pedidoBloc.pedidoStream,
      builder:
          (BuildContext context, AsyncSnapshot<List<PedidoModel>> snapshot) {
        if (snapshot.hasData) {
          final pedidos = snapshot.data;

          if (pedidos.length == 0)
            return ErrorCustom(message: 'No hay registros');

          return ListView.builder(
            itemCount: pedidos.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      PedidoNuevoDetallePage.routeName,
                      arguments: pedidos[index]),
                  onLongPress: () => showAnularDialog(context),
                  child: _pedidoBox(pedidos[index], context));
            },
          );
        } else if (snapshot.hasError) {
          return ErrorCustom(message: '${snapshot.error}');
        }

        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _pedidoBox(PedidoModel pedido, BuildContext context) {
    final styleTitulo = TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: Colors.black);
    final styleTexto =
        TextStyle(height: 1.4, fontSize: 14, fontWeight: FontWeight.normal);
    final stylePrecio =
        TextStyle(height: 1.4, fontSize: 16, fontWeight: FontWeight.normal);

    return Container(
        padding: EdgeInsets.all(paddingUI),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey[300], width: 0.5))),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: FadeInImage(
                placeholder: AssetImage(pathLoading),
                image: NetworkImage(pedido.detalles[0].sucursalProducto.producto
                    .getPathImage()),
                height: 70,
                width: 70,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pedido.cliente.getFullName(),
                    style: styleTitulo,
                  ),
                  Text(
                    pedido.getFechaHora(),
                    style: styleTexto,
                  ),
                  Text(
                    pedido.getTotal(),
                    style: stylePrecio,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  ChipCustom(
                      value: pedido.estado,
                      color: Theme.of(context).accentColor),
                  Container(
                    alignment: Alignment.topRight,
                    child: Text(
                      pedido.getCreatedAt(),
                      style: TextStyle(
                        height: 1.3,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  void showAnularDialog(BuildContext context) {
    final styleBtnText = TextStyle(color: Theme.of(context).primaryColor);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Anular pedido'),
            content: Text('Esta seguro de anularlo?'),
            actions: [
              FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'CERRAR',
                    style: styleBtnText,
                  )),
              FlatButton(
                  onPressed: () {},
                  child: Text('GUARDAR', style: styleBtnText)),
            ],
          );
        });
  }

  void filterPedidos(index) {
    switch (index) {
      case 0:
        _pedidoBloc.getAll(PedidoEstado.enProceso);
        break;
      case 1:
        _pedidoBloc.getAll(PedidoEstado.entregado);
        break;
      case 2:
        _pedidoBloc.getAll(PedidoEstado.anulado);
        break;
      default:
        _pedidoBloc.getAll(PedidoEstado.enProceso);
    }
  }
}
