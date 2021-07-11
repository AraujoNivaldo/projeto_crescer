import 'package:flutter/material.dart';
import 'package:tela1/env.dart';
import 'package:tela1/child.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tela1/telaPrincipal.dart';

class telaEditCrianca extends StatefulWidget {
  telaEditCrianca(Child crianca) {
    this.crianca = crianca;
  }

  Child crianca;

  @override
  _telaEditCrianca createState() => _telaEditCrianca(crianca);
}

class _telaEditCrianca extends State<telaEditCrianca> {
  Child crianca;
  bool isChecked = false;
  bool isChecked2 = false;
  TextEditingController childName = new TextEditingController();
  TextEditingController childBirth = new TextEditingController();
  String grupo = "F";

  CollectionReference criancas =
      FirebaseFirestore.instance.collection('childs');
  _telaEditCrianca(Child crianca) {
    this.crianca = crianca;
    isChecked = crianca.isPrematuro;
    isChecked2 = crianca.isSDD;
    childName = new TextEditingController(text: crianca.childName);
    childBirth = new TextEditingController(text: crianca.childBirth);
    grupo = crianca.gender;
  }

  Future<void> addChild() {
    return criancas
        .doc(crianca.id)
        .update({
          'childName': childName.text,
          'childBirth': childBirth.text,
          'isPrematuro': isChecked,
          'isSDD': isChecked2,
          'gender': grupo
        })
        .then((value) => {
              Fluttertoast.showToast(
                  msg: childName.text + " Editada com sucesso",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.lightBlueAccent,
                  textColor: Colors.white),
              Navigator.of(context).popUntil((route) => route.isFirst),
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => telaPrincipal()))
            })
        .catchError((error) => {
              print("Failed to add user: $error"),
              Fluttertoast.showToast(
                  msg: "Falha ao registrar criança",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.lightBlueAccent,
                  textColor: Colors.white),
            });
  }

  excluirCrianca() {
    CollectionReference childs =
        FirebaseFirestore.instance.collection('childs');
    CollectionReference measures =
        FirebaseFirestore.instance.collection('measures');
    measures
        .where("childId", isEqualTo: crianca.id)
        .get()
        .then((value2) => value2.docs.forEach((element2) {
              measures.doc(element2.id).delete();
            }));
    childs.doc(crianca.id).delete();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Proceder"),
      color: Colors.green,
      onPressed: () {
        excluirCrianca();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => telaPrincipal()));
        Fluttertoast.showToast(
            msg: "Crianca " + crianca.childName + " Excluido(a)",
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

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    childBirth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Editar Crianca - " + crianca.childName),
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
                  Text(
                    '\nNome\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    obscureText: false,
                    controller: childName,
                    textAlign: TextAlign.left,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Nome',
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Text(
                    '\nData de Nascimento\n',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  TextField(
                    readOnly: true,
                    controller: childBirth,
                    decoration: InputDecoration(
                        hintText: 'Escolha a Data',
                        border: OutlineInputBorder()),
                    onTap: () async {
                      var date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100));
                      if (date == null) {
                        date = DateTime.now();
                      }
                      childBirth.text = date.toString().substring(0, 10);
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Feminino'),
                    value: 'F',
                    groupValue: grupo,
                    onChanged: (String value) {
                      setState(() {
                        grupo = value;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: const Text('Masculino'),
                    value: 'M',
                    groupValue: grupo,
                    onChanged: (String value) {
                      setState(() {
                        grupo = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Prematuro"),
                    value: isChecked,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked = value;
                      });
                    },
                  ),
                  CheckboxListTile(
                    title: const Text("Sindrome de Down"),
                    value: isChecked2,
                    onChanged: (bool value) {
                      setState(() {
                        isChecked2 = value;
                      });
                    },
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
                          onPressed: addChild,
                          child: Text('Editar')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
