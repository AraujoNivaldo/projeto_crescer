import 'package:flutter/material.dart';
import 'package:tela1/telaLogin.dart';
import 'package:tela1/telaPrincipal.dart';
import 'package:tela1/env.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class telaAddCrianca extends StatefulWidget {
  telaAddCrianca({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaAddCrianca createState() => _telaAddCrianca();
}

class _telaAddCrianca extends State<telaAddCrianca> {
  bool isChecked = false;
  bool isChecked2 = false;
  TextEditingController childName = new TextEditingController();
  TextEditingController childBirth = new TextEditingController();

  CollectionReference criancas =
      FirebaseFirestore.instance.collection('childs');

  Future<void> addChild() {
    return criancas
        .add({
          'userId': Env.loggedUser.id,
          'childName': childName.text,
          'childBirth': childBirth.text,
          'isPrematuro': isChecked,
          'isSDD': isChecked2,
          'gender': grupo
        })
        .then((value) => {
              Fluttertoast.showToast(
                  msg: childName.text + " registrada com Sucesso!",
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
                  msg: "Falha ao registrar criança",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.lightBlueAccent,
                  textColor: Colors.white),
            });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    childBirth.dispose();
    super.dispose();
  }

  String grupo = "F";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Env.loggedUser.name + " - Adicionar Criança"),
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
                          child: Text('Adicionar')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
