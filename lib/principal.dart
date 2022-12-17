import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'models/gastos.dart';
import 'monthpage.dart';

class Principal extends StatefulWidget {
  const Principal({Key? key}) : super(key: key);

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> with TickerProviderStateMixin {
  //Instancia do banco Cloud Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;

  //Controller das Tabs
  late TabController _tabController;

  //Variaveis
  var mesAtual = DateTime.now().month.toString();
  List<Gastos> listGastosFixo = [];
  List<Gastos> listGastosVariaveis = [];
  List<Tab> tabs = <Tab>[
    Tab(text: _proxMeses(DateTime.now(), 0)),
    Tab(text: _proxMeses(DateTime.now(), 1)),
    Tab(text: _proxMeses(DateTime.now(), 2)),
  ];

  @override
  void initState() {
    //Atualização inicial
    atualizar();
    //Atualização em tempo real
    db.collection("gastos").snapshots().listen((query) {
      listGastosFixo = [];
      listGastosVariaveis = [];
      for (var doc in query.docs) {
        setState(() {
          Gastos gasto = Gastos(doc.get("nome"), doc.get("valor").toDouble(),
              doc.get("isFixo"), doc.get("mesInicio"), doc.get("qtdParcelas"));
          gasto.isFixo == true
              ? listGastosFixo.add(gasto)
              : listGastosVariaveis.add(gasto);
        });
      }
    });
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Financeiro"),
            bottom: TabBar(
              controller: _tabController,
              tabs: tabs,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              MonthPage(_proxMeses(DateTime.now(), 0), listGastosFixo,
                  listGastosVariaveis, db),
              MonthPage(_proxMeses(DateTime.now(), 1), listGastosFixo,
                  listGastosVariaveis, db),
              MonthPage(_proxMeses(DateTime.now(), 2), listGastosFixo,
                  listGastosVariaveis, db),
            ],
          ),
        ),
    );
  }

  void atualizar() async {
    QuerySnapshot query = await db.collection("gastos").get();

    for (var element in query.docs) {
      String name = element.get("teste");
      setState(() {
        listGastosFixo.add(element.get("teste"));
      });
    }
  }
}

String _proxMeses(mesAtual, int qtdMeses) {
  var hoje = DateTime.now();
  var mes = DateFormat.MMMM()
      .format(DateTime(hoje.year, hoje.month + qtdMeses, hoje.day));
  return mes;
}
