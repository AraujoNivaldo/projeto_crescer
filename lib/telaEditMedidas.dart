import 'package:flutter/material.dart';
import 'package:tela1/telaEditMedidasData.dart';
import 'package:tela1/telaLogin.dart';
import 'package:tela1/child.dart';

class telaEditMedidas extends StatefulWidget {
  //telaAcompanhamento({Key key, this.title}) : super(key: key);
  telaEditMedidas(Child crianca) {
    this.crianca = crianca;
  }

  Child crianca;

  @override
  _telaEditMedidas createState() => _telaEditMedidas(crianca);
}

class _telaEditMedidas extends State<telaEditMedidas> {
  List<telaEditMedidasData> listas = new List();
  Child crianca;
  _telaEditMedidas(Child crianca) {
    telaEditMedidasData crianca1 =
        new telaEditMedidasData(crianca, "01/01/2021");
    listas.add(crianca1);
    telaEditMedidasData crianca2 =
        new telaEditMedidasData(crianca, "02/01/2021");
    listas.add(crianca2);
    telaEditMedidasData crianca3 =
        new telaEditMedidasData(crianca, "03/01/2021");
    listas.add(crianca3);
    telaEditMedidasData crianca4 =
        new telaEditMedidasData(crianca, "04/01/2021");
    listas.add(crianca4);
    this.crianca = crianca;
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
                "EDITAR MEDIDAS \n " + crianca.childName,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < listas.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ElevatedButton(
                        child: Text('Data ' + (i + 1).toString()),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => listas[i]),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                            padding: EdgeInsets.symmetric(
                                horizontal: 50, vertical: 20),
                            textStyle: TextStyle(
                              fontSize: 30,
                            )),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
