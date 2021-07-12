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
    var buttons = new List<Padding>();
    double largura = 200, altura = 70, margem = 10, fonte = 20;
    buttons.add(Padding(
        padding: EdgeInsets.all(margem),
        child: ConstrainedBox(
            constraints:
                BoxConstraints.tightFor(width: largura, height: altura),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => telaGrafico(crianca, "Altura")),
                );
              },
              child: Text(
                'Altura',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fonte,
                ),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ))));

    buttons.add(Padding(
        padding: EdgeInsets.all(margem),
        child: ConstrainedBox(
            constraints:
                BoxConstraints.tightFor(width: largura, height: altura),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => telaGrafico(crianca, "Peso")),
                );
              },
              child: Text(
                'Peso',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fonte,
                ),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ))));
    if (!crianca.isSDD)
      buttons.add(Padding(
          padding: EdgeInsets.all(margem),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: largura, height: altura),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => telaGrafico(crianca, "IMC")),
                  );
                },
                child: Text(
                  'IMC',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fonte,
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.white),
              ))));
    buttons.add(Padding(
        padding: EdgeInsets.all(margem),
        child: ConstrainedBox(
            constraints:
                BoxConstraints.tightFor(width: largura, height: altura),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => telaGrafico(crianca, "HC")),
                );
              },
              child: Text(
                'Perimetro Cefalico',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: fonte,
                ),
              ),
              style: ElevatedButton.styleFrom(primary: Colors.white),
            ))));

    if (crianca.isPrematuro) {
      buttons.add(Padding(
          padding: EdgeInsets.all(margem),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: largura, height: altura),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => telaGrafico(crianca, "Altura",
                            isPrematuro: crianca.isPrematuro)),
                  );
                },
                child: Text(
                  'Altura\nPrematuro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fonte,
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.white),
              ))));
      buttons.add(Padding(
          padding: EdgeInsets.all(margem),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: largura, height: altura),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => telaGrafico(crianca, "Peso",
                            isPrematuro: crianca.isPrematuro)),
                  );
                },
                child: Text(
                  'Peso \nPrematuro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fonte,
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.white),
              ))));
      buttons.add(Padding(
          padding: EdgeInsets.all(margem),
          child: ConstrainedBox(
              constraints:
                  BoxConstraints.tightFor(width: largura, height: altura),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => telaGrafico(crianca, "HC",
                            isPrematuro: crianca.isPrematuro)),
                  );
                },
                child: Text(
                  'Perimetro Cefalico \nPrematuro',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: fonte,
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.white),
              ))));
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Graficos - " + crianca.childName),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /*Text(
                "GRAFICOS \n " + crianca.childName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),*/
                Column(
                  children: buttons,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
