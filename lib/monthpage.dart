import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:financeiro/models/gastos.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MonthPage extends StatefulWidget {
  MonthPage(this.tabName, this.listFixos, this.listVariaveis, this.db,
      {Key? key})
      : super(key: key);

  var db;
  final String tabName;
  final List<Gastos> listFixos;
  final List<Gastos> listVariaveis;

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isFixo = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(14),
      child: Column(
        children: [
          //Row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //Gastos Totais
              Expanded(
                  child: _cardGastoTotal("Gastos Totais", calcGastoTotal())),
              //Espaço
              const SizedBox(
                width: 16,
              ),
              //Botão Add
              ElevatedButton(
                onPressed: () {
                  _addGasto();
                },
                style: const ButtonStyle(
                  padding: MaterialStatePropertyAll(
                      EdgeInsetsDirectional.fromSTEB(0, 20, 0, 20)),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          //Espaço
          const SizedBox(
            height: 14,
          ),
          //Row 2
          Row(children: [
            //Gastos Variáveis
            Expanded(
                child: _cardGasto(
                    "Gastos Variáveis", calcGasto(widget.listVariaveis))),
            //Espaço
            const SizedBox(
              width: 14,
            ),
            //Gastos Fixos
            Expanded(
                child: _cardGasto("Gastos Fixos", calcGasto(widget.listFixos))),
          ]),
          //Espaço
          const SizedBox(
            height: 14,
          ),
          //Row 3
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //ListaVariaveis
                Expanded(
                  child: _listaGastos(widget.tabName, widget.listVariaveis),
                ),
                //Espaço
                const SizedBox(
                  width: 14,
                ),
                //ListaFixos
                Expanded(
                  child: _listaGastos(widget.tabName, widget.listFixos),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _cardGasto(String texto, double gasto) {
    return Card(
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              texto,
            ),
            Text(
              "R\$${gasto.toStringAsFixed(2)}",
            ),
          ],
        ),
      ),
    );
  }

  _cardGastoTotal(String texto, double gasto) {
    return Card(
      color: ThemeData().errorColor,
      child: Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              texto,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            Text(
              "R\$${gasto.toStringAsFixed(2)}",
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _listaGastos(String tabName, List<Gastos> gastos) {
    return ListView.builder(
      itemCount: gastos.length,
      shrinkWrap: true,
      controller: ScrollController(),
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.surface,
            title: Text(gastos[index].nome),
            subtitle: const Text("Quantidade de parcelas"),
            trailing: Text("R\$${gastos[index].valor.toStringAsFixed(2)}"),
            iconColor: Colors.teal,
            leading: const Icon(Icons.attach_money_outlined),
          ),
        );
      },
    );
  }

  double calcGastoTotal() {
    double total = 0;
    for (var element in widget.listFixos) {
      total = element.valor + total;
    }
    for (var element in widget.listVariaveis) {
      total = element.valor + total;
    }
    return total;
  }

  double calcGasto(List<Gastos> gastos) {
    double total = 0;
    for (var element in gastos) {
      total = element.valor + total;
    }
    return total;
  }

  _addGasto() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text("test"),
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
                          salvaBanco();
                          // if (_formKey.currentState!.validate()) {
                          //   //TODO colocar codigo
                          // }
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

  void salvaBanco() {
    //Gera ID
    String id = const Uuid().v1();

    widget.db.collection("gastos").doc(id).set({
      "nome": "Teste",
      "valor": 1200,
      "isFixo": true,
      "mesInicio": Timestamp.now(),
      "qtdParcelas": 0,
    });
  }
}
