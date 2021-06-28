import 'package:flutter/material.dart';
import 'package:tela1/telaAddMedidas.dart';
import 'package:tela1/telaEditMedidas.dart';
import 'package:tela1/telaGraficoSelect.dart';
import 'package:tela1/telaLogin.dart';
import 'package:tela1/child.dart';

class telaAcompanhamento extends StatefulWidget {
  //telaAcompanhamento({Key key, this.title}) : super(key: key);
  telaAcompanhamento(Child crianca) {
    this.crianca = crianca;
  }
  Child crianca;

  @override
  _telaAcompanhamento createState() => _telaAcompanhamento(crianca);
}

class _telaAcompanhamento extends State<telaAcompanhamento> {
  Child crianca;
  _telaAcompanhamento(Child crianca) {
    this.crianca = crianca;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crianca.childName),
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'ACOMPANHAMENTO CRIANÇA X',
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
                              builder: (context) => telaAddMedidas(crianca)),
                        );
                      },
                      child: Text('Adicionar Medidas')),
                  RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaEditMedidas(crianca)),
                        );
                      },
                      child: Text('Editar Medidas')),
                  RaisedButton(
                      color: Colors.white,
                      textColor: Colors.black,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaGraficoSelect(crianca)),
                        );
                      },
                      child: Text('Graficos')),
                ],
              ),
            ],
          ),
          
        ),
        
      ),
      floatingActionButton: Stack(
      children: <Widget>[
        Padding(padding: EdgeInsets.only(left:31),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaGraficoSelect(crianca)),
                        );
                      },
            child: Icon(Icons.insert_chart),),
        ),),

        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaAddMedidas(crianca)),
                        );
                      },
          child: Icon(Icons.add),),
        ),
      ],
    )
      );
  }
}
