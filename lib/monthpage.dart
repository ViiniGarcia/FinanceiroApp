import 'package:financeiro/models/gastos.dart';
import 'package:flutter/material.dart';

class MonthPage extends StatefulWidget {
  MonthPage(this.tabName, this.listFixos, this.listParcelados, {Key? key})
      : super(key: key);

  String tabName;
  List<Gastos> listFixos;
  List<Gastos> listParcelados;

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFixo = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: _gastoTotal()),
            ],
          ),
          _listaGastos(widget.tabName),
        ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addGasto();
          },
          child: const Icon(Icons.add)),
    );
  }

  _gastoTotal() {
    return Container(
      child: Card(
        child: Padding(
          padding: EdgeInsetsDirectional.all(20),
          child: Column(
            children: [
              Text(widget.tabName),
              Text("Total"),
              Text("R\$${calcGastoTotal().toStringAsFixed(2)}"),
            ],
          ),
        ),
      ),
    );
  }

  _listaGastos(String tabName) {
    return Expanded(
      child: ListView.builder(
        itemCount: widget.listFixos.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            child: ListTile(
              title: Text(widget.listFixos[index].nome),
              //subtitle: Text("Quantidade de parcelas ${listGastos[index].qtdParcelas}"),
              trailing: Text(
                  "R\$${widget.listFixos[index].valor.toStringAsFixed(2)}"),
              iconColor: Colors.teal,
              leading: const Icon(Icons.attach_money_outlined),
            ),
          );
        },
      ),
    );
  }

  double calcGastoTotal() {
    double total = 0;
    for (var element in widget.listFixos) {
      total = element.valor + total;
    }
    return total;
  }

  _addGasto() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("teste"),
            contentPadding: const EdgeInsetsDirectional.all(20),
            children: [
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Form(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Nome',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo não preenchido';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Valor',
                      ),
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo não preenchido';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Text("teste"),
                        Switch(
                            value: _isFixo,
                            onChanged: (value) {
                              setState(() {
                                _isFixo = value;
                              });
                            }),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            //TODO colocar codigo
                          }
                        },
                        child: const Text('Salvar'),
                      ),
                    ),
                  ],
                ));
              }),
            ],
          );
        });
  }
}
