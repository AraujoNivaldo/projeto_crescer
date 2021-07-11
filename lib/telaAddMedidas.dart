import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tela1/child.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class telaAddMedidas extends StatefulWidget {
  //telaAddMedidas({Key key, this.title}) : super(key: key);
  telaAddMedidas(Child crianca) {
    this.crianca = crianca;
  }
  Child crianca;
  @override
  _telaAddMedidas createState() => _telaAddMedidas(crianca);
}

class _telaAddMedidas extends State<telaAddMedidas> {
  CollectionReference medidas =
      FirebaseFirestore.instance.collection('measures');

  TextEditingController childMedidaDate = new TextEditingController();
  TextEditingController childAltura = new TextEditingController();
  TextEditingController childPeso = new TextEditingController();
  TextEditingController childPerimetro = new TextEditingController();

  Child crianca;
  _telaAddMedidas(Child crianca) {
    this.crianca = crianca;
  }

  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  int weekBetween(DateTime from, DateTime to) {
    final retorno = daysBetween(from, to) / 7;
    return retorno.round();
  }

  int monthBetween(DateTime from, DateTime to) {
    final retorno = daysBetween(from, to) / 30;
    return retorno.round();
  }

  Future<void> addMeasure() {
    double imc = double.parse(childPeso.text) /
        (double.parse(childAltura.text) * double.parse(childAltura.text));
    imc = double.parse((imc).toStringAsFixed(2));
    List<String> dataNascimento = crianca.childBirth.split('-');
    DateTime birthday = new DateTime(int.parse(dataNascimento[0]),
        int.parse(dataNascimento[1]), int.parse(dataNascimento[2]));
    List<String> dataMedida = childMedidaDate.text.split('-');
    DateTime date2 = new DateTime(int.parse(dataMedida[0]),
        int.parse(dataMedida[1]), int.parse(dataMedida[2]));

    return medidas
        .add({
          'childId': crianca.id,
          'measureDate': childMedidaDate.text,
          'measureHeight': childAltura.text,
          'measureWeight': childPeso.text,
          'measurePerimeter': childPerimetro.text,
          'measureIMC': imc,
          'measureWeekDiff': weekBetween(birthday, date2),
          'measureMonthDiff': monthBetween(birthday, date2)
        })
        .then((value) => {
              Fluttertoast.showToast(
                  msg: "Medidas registradas com Sucesso!",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.lightBlueAccent,
                  textColor: Colors.white),
              Navigator.pop(context)
            })
        .catchError((error) => {
              print("Failed to add user: $error"),
              Fluttertoast.showToast(
                  msg: "Falha ao registrar medidas",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.lightBlueAccent,
                  textColor: Colors.white),
            });
  }

  @override
  dispose() {
    childMedidaDate.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Adicionar Medidas - " + crianca.childName),
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Data Medição',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  TextField(
                    readOnly: true,
                    controller: childMedidaDate,
                    decoration: InputDecoration(hintText: 'Escolha a Data'),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2100));
                      if (date == null) {
                        date = DateTime.now();
                      }
                      childMedidaDate.text = date.toString().substring(0, 10);
                    },
                  ),
                  Text(
                    'Peso (KG)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d?\d?\.?\d{0,2}"))
                    ],
                    controller: childPeso,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Peso (KG)',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    'Altura (M)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: childAltura,
                    textAlign: TextAlign.left,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"^\d?\.?\d{0,2}"))
                    ],
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Altura (M)',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    'Perimetro Cefalico',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: childPerimetro,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Perimetro Cefalico',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      RaisedButton(
                          color: Colors.red,
                          textColor: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('Cancelar')),
                      RaisedButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          onPressed: addMeasure,
                          child: Text('Adicionar'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
