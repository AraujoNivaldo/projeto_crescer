import 'package:flutter/material.dart';
import 'package:tela1/telaLogin.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class telaCadastro extends StatefulWidget {
  telaCadastro({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaCadastro createState() => _telaCadastro();
}

class _telaCadastro extends State<telaCadastro> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser() {
    return users
        .add({
          'name': nameController.text,
          'email': emailController.text,
          'pass': passController.text
        })
        .then((value) => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => telaLogin()),
            ))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'CADASTRO',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
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
              Text(
                'Confirmar Senha',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
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
                      child: Text('Cancelar')),
                  RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: addUser,
                      child: Text('Cadastrar'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
