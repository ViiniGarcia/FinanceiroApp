import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:financeiro/models/gastos.dart';
import 'package:financeiro/monthpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:uuid/uuid.dart';
import 'helpers/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "financeiro",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //Instancia do banco Cloud Firestore
  FirebaseFirestore db = FirebaseFirestore.instance;

  //Modo de cor
  static final _defaultLightColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue);
  static final _defaultDarkColorScheme = ColorScheme.fromSwatch(
      primarySwatch: Colors.blue, brightness: Brightness.dark);

  //Variaveis
  var mesAtual = DateTime.now().month.toString();
  List<Gastos> listGastosFixo = [];
  List<Gastos> listGastosParcelados = [];
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
      listGastosParcelados = [];
      for (var doc in query.docs) {
        setState(() {
          Gastos gasto =  Gastos(
              doc.get("nome"),
              doc.get("valor").toDouble(),
              doc.get("isFixo"),
              doc.get("mesInicio"),
              doc.get("qtdParcelas")
          );
          gasto.isFixo == true ? listGastosFixo.add(gasto) : listGastosParcelados.add(gasto);
        });
      }});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(builder: (lightColorScheme, darkColorScheme){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Financeiro',
        theme: ThemeData(
          colorScheme: lightColorScheme ?? _defaultLightColorScheme,
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        darkTheme: ThemeData(
          colorScheme: darkColorScheme ?? _defaultDarkColorScheme,
          useMaterial3: true,
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('es', ''),
          Locale('pt', 'BR')
        ],
        themeMode: ThemeMode.system,
        home: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: const Text("Financeiro"),
                bottom: TabBar(tabs: tabs),
              ),
              body: TabBarView(
                children: [
                  MonthPage(
                      _proxMeses(DateTime.now(), 0),
                      listGastosFixo,
                      listGastosParcelados
                  ),
                  MonthPage(
                      _proxMeses(DateTime.now(), 1),
                      listGastosFixo,
                      listGastosParcelados
                  ),
                  MonthPage(
                      _proxMeses(DateTime.now(), 2),
                      listGastosFixo,
                      listGastosParcelados
                  ),
                ],
              ),
            )
        ),
      );
    });
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

  void salvaBanco() {
    //Gera ID
    String id = const Uuid().v1();
    db.collection("gastos").doc(id).set({
      "nome":"Apartamento",
      "valor":"Apartamento",
      "isFixo":"Apartamento",
      "mesInicio":"Apartamento",
      "qtdParcelas":"Apartamento",
    });
  }

}

String _proxMeses(mesAtual, int qtdMeses) {
  var hoje = DateTime.now();
  var mes = DateFormat.MMMM()
      .format(DateTime(hoje.year, hoje.month + qtdMeses, hoje.day));
  return mes;
}
