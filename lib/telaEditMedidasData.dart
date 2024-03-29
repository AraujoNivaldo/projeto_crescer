import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tela1/child.dart';
import 'package:tela1/measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class telaEditMedidasData extends StatefulWidget {
  //telaAddMedidas({Key key, this.title}) : super(key: key);
  telaEditMedidasData(Child crianca, Measure medida) {
    this.crianca = crianca;
    this.medida = medida;
  }
  Child crianca;
  Measure medida;
  @override
  _telaEditMedidasData createState() => _telaEditMedidasData(crianca, medida);
}

class _telaEditMedidasData extends State<telaEditMedidasData> {
  CollectionReference medidas =
      FirebaseFirestore.instance.collection('measures');

  TextEditingController childMedidaDate;
  TextEditingController childAltura;
  TextEditingController childPeso;
  TextEditingController childPerimetro;

  Child crianca;
  Measure medida;
  _telaEditMedidasData(Child crianca, Measure medida) {
    this.medida = medida;
    this.crianca = crianca;
    childMedidaDate = new TextEditingController(text: medida.measureDate);
    childAltura = new TextEditingController(text: medida.measureHeight);
    childPeso = new TextEditingController(text: medida.measureWeight);
    childPerimetro = new TextEditingController(text: medida.measurePerimeter);
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

  excluirMedida() {
    CollectionReference measures =
        FirebaseFirestore.instance.collection('measures');
    measures.doc(medida.id).delete();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Proceder"),
      color: Colors.green,
      onPressed: () {
        excluirMedida();
        Navigator.of(context).pop();
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "Medida da Data: " + medida.measureDate + " Excluida",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.redAccent,
            textColor: Colors.white);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Cancelar"),
      color: Colors.grey,
      textColor: Colors.white,
      onPressed: () {
        Navigator.of(context).pop();
      },
    ); // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Deseja mesmo excluir esta conta?"),
      content: Text("Esta ação é irreversivel"),
      actions: [
        cancelButton,
        continueButton,
      ],
    ); // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
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
        .doc(medida.id)
        .set({
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
          title: Text(
              "Editar - " + crianca.childName + " - " + medida.measureDate),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                  onTap: () {
                    showAlertDialog(context);
                  },
                  child: Icon(Icons.delete)),
            ),
          ],
        ),
        body: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Data Medição:',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  TextField(
                    readOnly: true,
                    controller: childMedidaDate,
                    decoration: InputDecoration(
                        hintText: 'Escolha a Data',
                        border: OutlineInputBorder()),
                    onTap: () async {
                      List<String> oldDate = medida.measureDate.split('-');
                      DateTime oldDateTime = new DateTime(int.parse(oldDate[0]),
                          int.parse(oldDate[1]), int.parse(oldDate[2]));
                      var date = await showDatePicker(
                          context: context,
                          initialDate: oldDateTime,
                          firstDate: DateTime(2015),
                          lastDate: DateTime(2100));
                      if (date == null) {
                        date = oldDateTime;
                      }
                      childMedidaDate.text = date.toString().substring(0, 10);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Peso (KG):',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
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
                      border: OutlineInputBorder(),
                      hintText: 'Peso (KG)',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Altura (M):',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
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
                      border: OutlineInputBorder(),
                      hintText: 'Altura (M)',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text(
                      'Perimetro Cefalico:',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: childPerimetro,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Perimetro Cefalico',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
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
                          child: Text('Salvar'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
