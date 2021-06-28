import 'package:flutter/material.dart';
import 'package:tela1/telaEditMedidas.dart';
import 'package:tela1/telaLogin.dart';
import 'package:tela1/child.dart';

class telaEditMedidasData extends StatefulWidget {
  //telaEditMedidasData({Key key, this.title}) : super(key: key);
  telaEditMedidasData(Child crianca, String data) {
    this.crianca = crianca;
    this.data = data;
  }
  Child crianca;
  String data;

  @override
  _telaEditMedidasData createState() => _telaEditMedidasData(crianca, data);
}

class _telaEditMedidasData extends State<telaEditMedidasData> {
  Child crianca;
  String data;
  _telaEditMedidasData(Child crianca, String data) {
    this.crianca = crianca;
    this.data = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Medidas - " + crianca.childName),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "EDITAR MEDIDAS " + crianca.childName + " \n $data",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40),
              ),
              Text(
                'Data Medição',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Data Medição',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                'Peso (KG)',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Peso (KG)',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                'Altura (CM)',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Altura (CM)',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
              Text(
                'Perimetro Cefalico',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              TextField(
                keyboardType: TextInputType.emailAddress,
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
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaEditMedidas(crianca)),
                        );
                      },
                      child: Text('Cancelar')),
                  RaisedButton(
                      color: Colors.green,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {});
                      },
                      child: Text('Atualizar'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
