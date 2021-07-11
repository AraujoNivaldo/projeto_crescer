import 'package:flutter/material.dart';
import 'package:tela1/telaLogin.dart';
import 'package:tela1/env.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "user.dart";
import 'package:fluttertoast/fluttertoast.dart';

class telaEditCadastro extends StatefulWidget {
  telaEditCadastro({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaEditCadastro createState() => _telaEditCadastro();
}

class _telaEditCadastro extends State<telaEditCadastro> {
  TextEditingController emailController =
      new TextEditingController(text: Env.loggedUser.email);
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController =
      new TextEditingController(text: Env.loggedUser.name);

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  excluirUsuario() {
    CollectionReference childs =
        FirebaseFirestore.instance.collection('childs');
    CollectionReference measures =
        FirebaseFirestore.instance.collection('measures');
    childs
        .where('userId', isEqualTo: Env.loggedUser.id)
        .get()
        .then((value) => value.docs.forEach((element) {
              measures.where("childId", isEqualTo: element.id)
                ..get().then((value2) => value2.docs.forEach((element2) {
                      measures.doc(element2.id).delete();
                    }));
              childs.doc(element.id).delete();
            }));
    users.doc(Env.loggedUser.id).delete();
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Proceder"),
      color: Colors.green,
      onPressed: () {
        excluirUsuario();
        Navigator.of(context).popUntil((route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => telaLogin()));
        Fluttertoast.showToast(
            msg: "Usuario " + Env.loggedUser.name + " Excluido",
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

  Future<void> addUser() {
    User editedUser = new User(
        email: emailController.text,
        name: nameController.text,
        id: Env.loggedUser.id);
    Env.loggedUser = editedUser;
    if (passController.text != "") {
      return users
          .doc(Env.loggedUser.id)
          .update({
            'name': nameController.text,
            'email': emailController.text,
            'pass': passController.text
          })
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Alterações salvas!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white),
                Navigator.pop(context)
              })
          .catchError((error) => print("Failed to add user: $error"));
    } else {
      return users
          .doc(Env.loggedUser.id)
          .update({'name': nameController.text, 'email': emailController.text})
          .then((value) => {
                Fluttertoast.showToast(
                    msg: "Alterações salvas!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.lightBlueAccent,
                    textColor: Colors.white),
                Navigator.pop(context)
              })
          .catchError((error) => print("Failed to add user: $error"));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Editar Usuario: " + Env.loggedUser.name),
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
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Nome',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: nameController,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Nome',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                'Email',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                obscureText: false,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                'Senha',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                controller: passController,
                obscureText: true,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Senha',
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
                      child: Text('Voltar')),
                  RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: addUser,
                      child: Text('Editar'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
