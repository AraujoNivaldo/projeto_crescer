import 'package:flutter/material.dart';
import 'package:tela1/telaGrafico.dart';
import 'package:tela1/telaPrincipal.dart';
import 'package:tela1/child.dart';

class telaGraficoSelect extends StatefulWidget {
  telaGraficoSelect(Child crianca) {
    this.crianca = crianca;
  }

  Child crianca;

  @override
  _telaGraficoSelect createState() => _telaGraficoSelect(crianca);
}

class _telaGraficoSelect extends State<telaGraficoSelect> {
  Child crianca;
  _telaGraficoSelect(Child crianca) {
    this.crianca = crianca;
  }

  @override
  Widget build(BuildContext context) {
    var buttons = new List<RaisedButton>();
    buttons.add(RaisedButton(
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => telaGrafico(crianca, "Altura")),
          );
        },
        child: Text('Altura')));
    buttons.add(RaisedButton(
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => telaGrafico(crianca, "Peso")),
          );
        },
        child: Text('Peso')));
    if (!crianca.isSDD)
      buttons.add(RaisedButton(
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => telaGrafico(crianca, "IMC")),
            );
          },
          child: Text('IMC')));
    buttons.add(RaisedButton(
        color: Colors.white,
        textColor: Colors.black,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => telaGrafico(crianca, "HC")),
          );
        },
        child: Text('Perimetro Cefalico')));

    if (crianca.isPrematuro) {
      buttons.add(RaisedButton(
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => telaGrafico(crianca, "Altura",
                      isPrematuro: crianca.isPrematuro)),
            );
          },
          child: Text('Altura - Prematuro')));
      buttons.add(RaisedButton(
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => telaGrafico(crianca, "Peso",
                      isPrematuro: crianca.isPrematuro)),
            );
          },
          child: Text('Peso - Prematuro')));
      buttons.add(RaisedButton(
          color: Colors.white,
          textColor: Colors.black,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => telaGrafico(crianca, "HC",
                      isPrematuro: crianca.isPrematuro)),
            );
          },
          child: Text('Perimetro Cefalico - Prematuro')));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Graficos - " + crianca.childName),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "GRAFICOS \n " + crianca.childName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Column(
                children: buttons,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
