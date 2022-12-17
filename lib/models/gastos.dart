import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

///Classe para Gastos
class Gastos {
  String nome;
  double valor;
  bool isFixo;
  Timestamp mesInicio;
  int qtdParcelas;

  Gastos(this.nome, this.valor, this.isFixo, this.mesInicio, this.qtdParcelas);

  quantasParcelasFaltam() {
    String tempo;
    var inicio = mesInicio.toDate();
    var atual = DateTime.now();

    tempo = (atual.difference(inicio).inDays / 30).toStringAsFixed(0);

    var hoje1 = DateTime.now();
    var mes = DateFormat.yM().format(mesInicio.toDate());
    var hoje = DateFormat.yM().format(DateTime.now());
    return tempo;
  }
}
