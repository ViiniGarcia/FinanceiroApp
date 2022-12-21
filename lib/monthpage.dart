import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:financeiro/models/gastos.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class MonthPage extends StatefulWidget {
  MonthPage(this.tabDate, this.tabName, this.listFixos, this.listVariaveis, this.db,
      {Key? key})
      : super(key: key);

  var db;
  final DateTime tabDate;
  final String tabName;
  final List<Gastos> listFixos;
  final List<Gastos> listVariaveis;

  @override
  State<MonthPage> createState() => _MonthPageState();
}

class _MonthPageState extends State<MonthPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _nome = TextEditingController();
  final _valor = TextEditingController();
  bool _isFixo = false;
  bool _isParcelado = false;
  final _qtdParcelas = TextEditingController();

  late Gastos gasto;

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
    //gastos.removeWhere((gasto) => gasto.mesInicio == )
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
            title: const Text("Adicionar Gasto"),
            contentPadding: const EdgeInsetsDirectional.all(20),
            children: [
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return Form(
                  key: _formKey,
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Nome',
                      ),
                      controller: _nome,
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
                      controller: _valor,
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo não preenchido';
                        }
                        return null;
                      },
                    ),
                    Row(
                      children: [
                        Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: _isFixo,
                            onChanged: (value) {
                              setState(() {
                                _isFixo = value;
                              });
                            }),
                        const Text("Fixo"),
                      ],
                    ),
                    Row(
                      children: [
                        Switch(
                            activeColor: Theme.of(context).colorScheme.primary,
                            value: _isParcelado,
                            onChanged: (value) {
                              setState(() {
                                _isParcelado = value;
                              });
                            }),
                        const Text("Com Parcelamento"),
                      ],
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Quantidade de Parcelas',
                      ),
                      controller: _qtdParcelas,
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null && _isParcelado == true) {
                          return 'Campo não preenchido';
                        }
                        return null;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            DateTime hoje = DateTime.now();

                            gasto = Gastos(
                                _nome.text,
                                double.parse(_valor.text),
                                _isFixo,
                                Timestamp.fromDate(widget.tabDate),
                                _isParcelado,
                                _qtdParcelas.text.isNotEmpty ? int?.parse(_qtdParcelas.text) : 0
                            );

                            salvaGasto(gasto);
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

  _calendario() {
    return DateTimePicker(
      type: DateTimePickerType.date,
      dateMask: 'dd/MM/yyyy',
      initialValue: DateTime.now().toString(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      icon: const Icon(Icons.event),
    );
  }

  void salvaGasto(Gastos gasto) {
    //Gera ID
    String id = const Uuid().v1();
    widget.db.collection("gastos").doc(id).set({
      "nome": gasto.nome,
      "valor": gasto.valor,
      "isFixo": gasto.isFixo,
      "mesInicio": gasto.mesInicio,
      "isParcelado": gasto.isParcelado,
      "qtdParcelas": gasto.qtdParcelas,
    });
  }
}
