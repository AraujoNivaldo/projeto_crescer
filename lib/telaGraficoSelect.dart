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
    return Scaffold(
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
                children: [
                  RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  telaGrafico(crianca, "Altura")),
                        );
                      },
                      child: Text('ALTURA')),
                  RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  telaGrafico(crianca, "Peso")),
                        );
                      },
                      child: Text('PESO')),
                  RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  telaGrafico(crianca, "IMC")),
                        );
                      },
                      child: Text('IMC')),
                  RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  telaGrafico(crianca, "Perimetro Cefalico")),
                        );
                      },
                      child: Text('PERIMETRO CEFALICO')),
                  RaisedButton(
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaPrincipal()),
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
