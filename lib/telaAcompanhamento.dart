import 'package:flutter/material.dart';
import 'package:tela1/telaAddMedidas.dart';
import 'package:tela1/telaEditMedidasData.dart';
import 'package:tela1/telaGraficoSelect.dart';
import 'package:tela1/child.dart';
import 'package:tela1/measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  ListTile _tile(
          String title, String subtitle, IconData icon, Measure medida) =>
      ListTile(
          title: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              )),
          subtitle: Text(subtitle),
          leading: Icon(
            icon,
            size: 50,
            color: Colors.blue[500],
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => telaEditMedidasData(crianca, medida)),
            ).then((value) {
              setState(() {});
            });
          });

  ListView measureListView(context, List<Measure> data) {
    return ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(
              data[index].measureDate,
              "A: " +
                  data[index].measureHeight +
                  "  P: " +
                  data[index].measureWeight,
              Icons.edit,
              data[index]);
        });
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference listaMedidas =
        FirebaseFirestore.instance.collection('measures');
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(crianca.childName + " - Medidas"),
        ),
        body: Container(
          padding: EdgeInsets.all(20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    FutureBuilder<QuerySnapshot<Object>>(
                        future: listaMedidas
                            .where('childId', isEqualTo: crianca.id)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Measure> newList = [];
                            String id;
                            String childId;
                            String measureDate;
                            String measureHeight;
                            String measureWeight;
                            String measurePerimeter;
                            double measureIMC;
                            int measureWeekDiff;
                            int measureMonthDiff;
                            snapshot.data.docs.forEach((element) {
                              id = element.id;
                              childId = element.get('childId');
                              measureDate = element.get('measureDate');
                              measureHeight = element.get('measureHeight');
                              measureWeight = element.get('measureWeight');
                              measurePerimeter =
                                  element.get('measurePerimeter');
                              measureIMC = element.get('measureIMC');
                              measureWeekDiff = element.get('measureWeekDiff');
                              measureMonthDiff =
                                  element.get('measureMonthDiff');

                              Measure medidaNova = new Measure(
                                  id: id,
                                  childId: childId,
                                  measureDate: measureDate,
                                  measureHeight: measureHeight,
                                  measureIMC: measureIMC,
                                  measureMonthDiff: measureMonthDiff,
                                  measurePerimeter: measurePerimeter,
                                  measureWeekDiff: measureWeekDiff,
                                  measureWeight: measureWeight);
                              newList.add(medidaNova);
                            });
                            newList.sort((a, b) {
                              return a.measureDate
                                  .toString()
                                  .toLowerCase()
                                  .compareTo(
                                      b.measureDate.toString().toLowerCase());
                            });
                            return measureListView(context, newList);
                          } else if (snapshot.hasError) {}

                          return CircularProgressIndicator();
                        })
                  ],
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
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
                  child: Icon(Icons.insert_chart),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => telaAddMedidas(crianca)),
                  ).then((value) {
                    setState(() {});
                  });
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}
