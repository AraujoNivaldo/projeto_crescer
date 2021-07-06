import 'package:flutter/material.dart';
import 'package:tela1/telaCadastro.dart';
import 'package:tela1/telaPrincipal.dart';
import "package:tela1/user.dart";
import 'package:tela1/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//teste papae2
//surpresa, eu VOTEI DNV

class telaLogin extends StatefulWidget {
  telaLogin({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaLogin createState() => _telaLogin();
}

class _telaLogin extends State<telaLogin> {
  Future<User> futureUser;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future loginAttempt() async {
    /*final result = await users
        .where('email', isEqualTo: emailController.text)
        .get()
        .then((value) => value.docs.forEach((element) {
              return Fluttertoast.showToast(
                  msg: "Eita2 " + element.get('email'),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.yellow);
            }));
            */
    String userEmail;
    String userName;
    String userId;
    final result = await users
        .where('email', isEqualTo: emailController.text)
        .where('pass', isEqualTo: passController.text)
        .get()
        .then((value) => {
              if (value.size == 1)
                {
                  userEmail = value.docs[0].get('email'),
                  userName = value.docs[0].get('name'),
                  userId = value.docs[0].id,
                  Env.loggedUser =
                      new User(id: userId, email: userEmail, name: userName),
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => telaPrincipal()),
                  )
                }
              else
                {
                  Fluttertoast.showToast(
                      msg: "Email/Senha incorreto(s)!",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.lightBlueAccent,
                      textColor: Colors.white)
                }
            });
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
                'LOGIN',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              Text(
                'Email',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: false,
                controller: emailController,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                obscureText: true,
                controller: passController,
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
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: loginAttempt,
                      child: Text('Acessar')),
                  RaisedButton(
                      color: Colors.purple,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaCadastro()),
                        );
                      },
                      child: Text('Cadastrar-se')),
                ],
              ),
              RaisedButton(
                  color: Colors.blueAccent,
                  textColor: Colors.white,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => telaPrincipal()),
                    );
                  },
                  child: Text('Esqueci Minha Senha'))
            ],
          ),
        ),
      ),
    );
  }
}
