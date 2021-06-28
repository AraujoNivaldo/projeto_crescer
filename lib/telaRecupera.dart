import 'package:flutter/material.dart';
import 'package:tela1/telaLogin.dart';

class telaRecupera extends StatefulWidget {
  telaRecupera({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaRecupera createState() => _telaRecupera();
}

class _telaRecupera extends State<telaRecupera> {
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
                'RECUPERAÇÃO DE SENHA',
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
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Enviar email')),
                  RaisedButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => telaLogin()),
                        );
                      },
                      child: Text('Voltar')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
