import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tela1/child.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

class telaGrafico extends StatefulWidget {
  telaGrafico(Child crianca, String medida, {bool isPrematuro = false}) {
    this.crianca = crianca;
    this.medida = medida;
    this.isPrematuro = isPrematuro;
  }

  Child crianca;
  String medida;
  bool isPrematuro;

  @override
  _telaGrafico createState() => _telaGrafico(crianca, medida, isPrematuro);
}

class _telaGrafico extends State<telaGrafico> {
  Child crianca;
  String medida = '';
  bool isPrematuro = false;
  String titleGrafico = '';

  _telaGrafico(Child crianca, medida, bool isPrematuro) {
    this.crianca = crianca;
    this.medida = medida;
    this.isPrematuro = isPrematuro;
    switch (medida) {
      case "Altura":
        titleGrafico = "Altura";
        break;
      case "Peso":
        titleGrafico = "Peso";
        break;
      case "IMC":
        titleGrafico = "IMC";
        break;
      case "HC":
        titleGrafico = "Perimetro Cefálico";
        break;
    }
    if (isPrematuro) {
      titleGrafico += " - Prematuro";
    } else {
      if (crianca.isSDD) {
        titleGrafico += " - Sindrome de Down";
      }
    }
  }

  List<GraphData> _chartData;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Graficos - " + crianca.childName),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20),
        child: Center(
          child: FutureBuilder<List<GraphData>>(
              future: getGraph(crianca, medida, isPrematuro),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    child: SfCartesianChart(
                      title: ChartTitle(text: titleGrafico),
                      legend: Legend(
                        isVisible: true,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap,
                        height: "18%",
                        width: "100%",
                      ),
                      series: <ChartSeries>[
                        SplineSeries<GraphData, double>(
                            name: "Z-Score 3",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.z3,
                            color: Color.fromRGBO(0, 0, 255, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Z-Score 2",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.z2,
                            color: Color.fromRGBO(255, 0, 0, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Z-Score 1",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.z1,
                            color: Color.fromRGBO(255, 255, 0, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Z-Score 0",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.z0,
                            color: Color.fromRGBO(0, 255, 0, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Z-Score -1",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.zm1,
                            color: Color.fromRGBO(255, 255, 0, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Z-Score -2",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.zm2,
                            color: Color.fromRGBO(255, 0, 0, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Z-Score -3",
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.zm3,
                            color: Color.fromRGBO(0, 0, 255, 1)),
                        SplineSeries<GraphData, double>(
                            name: "Criança",
                            markerSettings: MarkerSettings(isVisible: true),
                            dataSource: snapshot.data,
                            xValueMapper: (GraphData teste, _) => teste.age,
                            yValueMapper: (GraphData teste, _) => teste.kid,
                            color: Color.fromRGBO(0, 0, 0, 1)),
                      ],
                      primaryXAxis: CategoryAxis(),
                    ),
                  );
                } else if (snapshot.hasError) {}

                return CircularProgressIndicator();
              }),
        ),
      ),
    );
  }

  Future<List<GraphData>> getGraph(
      Child crianca, String medida, bool isPrematuro) {
    /*final List<GraphData> chartData = [
      GraphData(27, 0.36, 0.44, 0.55, 0.67, 0.83, 1.02, 1.25, 0.60),
      GraphData(28, 0.46, 0.56, 0.68, 0.83, 1.01, 1.23, 1.50, 0.80),
      GraphData(29, 0.57, 0.69, 0.83, 1.00, 1.21, 1.46, 1.76, 1.20),
      GraphData(30, 0.69, 0.83, 0.99, 1.19, 1.42, 1.70, 2.04, null),
      GraphData(31, 0.83, 0.98, 1.17, 1.39, 1.65, 1.96, 2.33, 1.30),
      GraphData(32, 0.97, 1.14, 1.35, 1.60, 1.89, 2.23, 2.63, 1.65)
    ];
    */
    if (isPrematuro) {
      return buildGraphPrematuro(crianca, medida);
    } else if (crianca.isSDD) {
      return buildGraphSDD(crianca, medida);
    } else {
      return buildGraph(crianca, medida);
    }
  }
}

Future<List<GraphData>> buildGraph(Child crianca, String medida) async {
  List<GraphData> result = new List<GraphData>();
  CollectionReference listaMedidas =
      FirebaseFirestore.instance.collection('curves-who');
  CollectionReference criancaGet =
      FirebaseFirestore.instance.collection('measures');

  double age;
  double zm1;
  double zm2;
  double zm3;
  double z0;
  double z1;
  double z2;
  double z3;
  double kid = null;

  String whereMedida = "";
  String whereMedidaCrianca = "";

  switch (medida) {
    case 'Altura':
      whereMedida = "'CE'";
      whereMedidaCrianca = 'measureHeight';
      break;
    case 'Peso':
      whereMedida = "'PE'";
      whereMedidaCrianca = 'measureWeight';
      break;
    case 'IMC':
      whereMedida = "'II'";
      whereMedidaCrianca = 'measureIMC';
      break;
    case 'HC':
      whereMedida = "'HC'";
      whereMedidaCrianca = 'measurePerimeter';
      break;
  }
  await listaMedidas
      .where("param", isEqualTo: whereMedida)
      .where("gender", isEqualTo: "'" + crianca.gender + "'")
      .get()
      .then((value) => {
            value.docs.forEach((element) {
              age = double.parse(element.get('age'));
              zm1 = double.parse(element.get('zm1'));
              zm2 = double.parse(element.get('zm2'));
              zm3 = double.parse(element.get('zm3'));
              z0 = double.parse(element.get('z0'));
              z1 = double.parse(element.get('z1'));
              z2 = double.parse(element.get('z2'));
              z3 = double.parse(element.get('z3'));
              result
                  .add(new GraphData(age, zm3, zm2, zm1, z0, z1, z2, z3, null));
            })
          });
  result.sort((a, b) {
    return a.age.compareTo(b.age);
  });
  List<GraphData> result2 = new List<GraphData>();
  for (GraphData element in result) {
    await criancaGet
        .where('childId', isEqualTo: crianca.id)
        .where('measureMonthDiff', isEqualTo: element.age.round())
        .get()
        .then((value2) => {
              value2.docs.forEach((element2) {
                if (kid == null) {
                  kid =
                      double.parse(element2.get(whereMedidaCrianca).toString());
                }
                if (medida == "Altura") {
                  kid *= 100;
                }
              })
            });
    element.kid = kid;
    result2.add(element);
    kid = null;
  }
  ;
  return result2;
}

Future<List<GraphData>> buildGraphSDD(Child crianca, String medida) async {
  List<GraphData> result = new List<GraphData>();
  CollectionReference listaMedidas =
      FirebaseFirestore.instance.collection('curves-who-sd');
  CollectionReference criancaGet =
      FirebaseFirestore.instance.collection('measures');

  double age;
  double zm1;
  double zm2;
  double zm3;
  double z0;
  double z1;
  double z2;
  double z3;
  double kid = null;

  String whereMedida = "";
  String whereMedidaCrianca = "";

  switch (medida) {
    case 'Altura':
      whereMedida = "'CE'";
      whereMedidaCrianca = 'measureHeight';
      break;
    case 'Peso':
      whereMedida = "'PE'";
      whereMedidaCrianca = 'measureWeight';
      break;
    case 'IMC':
      whereMedida = "'II'";
      whereMedidaCrianca = 'measureIMC';
      break;
    case 'HC':
      whereMedida = "'HC'";
      whereMedidaCrianca = 'measurePerimeter';
      break;
  }

  await listaMedidas
      .where("param", isEqualTo: whereMedida)
      .where("gender", isEqualTo: "'" + crianca.gender + "'")
      .get()
      .then((value) => {
            value.docs.forEach((element) {
              age = double.parse(element.get('age'));
              zm1 = double.parse(element.get('p10'));
              zm2 = double.parse(element.get('p5'));
              zm3 = double.parse(element.get('p3'));
              z0 = double.parse(element.get('p15'));
              z1 = double.parse(element.get('p50'));
              z2 = double.parse(element.get('p85'));
              z3 = double.parse(element.get('p97'));
              result
                  .add(new GraphData(age, zm3, zm2, zm1, z0, z1, z2, z3, null));
            })
          });
  result.sort((a, b) {
    return a.age.compareTo(b.age);
  });
  List<GraphData> result2 = new List<GraphData>();
  for (GraphData element in result) {
    await criancaGet
        .where('childId', isEqualTo: crianca.id)
        .where('measureMonthDiff', isEqualTo: element.age.round())
        .get()
        .then((value2) => {
              value2.docs.forEach((element2) {
                if (kid == null) {
                  kid =
                      double.parse(element2.get(whereMedidaCrianca).toString());
                }
                if (medida == "Altura") {
                  kid *= 100;
                }
              })
            });
    element.kid = kid;
    result2.add(element);
    kid = null;
  }
  ;
  return result2;
}

Future<List<GraphData>> buildGraphPrematuro(
    Child crianca, String medida) async {
  List<GraphData> result = new List<GraphData>();
  CollectionReference listaMedidas =
      FirebaseFirestore.instance.collection('curves-premature');
  CollectionReference criancaGet =
      FirebaseFirestore.instance.collection('measures');

  double age;
  double zm1;
  double zm2;
  double zm3;
  double z0;
  double z1;
  double z2;
  double z3;
  double kid = null;

  String whereMedida = "";
  String whereMedidaCrianca = "";

  switch (medida) {
    case 'Altura':
      whereMedida = "'CE'";
      whereMedidaCrianca = 'measureHeight';
      break;
    case 'Peso':
      whereMedida = "'PE'";
      whereMedidaCrianca = 'measureWeight';
      break;
    case 'IMC':
      whereMedida = "'II'";
      whereMedidaCrianca = 'measureIMC';
      break;
    case 'HC':
      whereMedida = "'HC'";
      whereMedidaCrianca = 'measurePerimeter';
      break;
  }
  await listaMedidas
      .where("param", isEqualTo: whereMedida)
      .where("gender", isEqualTo: "'" + crianca.gender + "'")
      .get()
      .then((value) => {
            value.docs.forEach((element) {
              age = double.parse(element.get('age'));
              zm1 = double.parse(element.get('zm1'));
              zm2 = double.parse(element.get('zm2'));
              zm3 = double.parse(element.get('zm3'));
              z0 = double.parse(element.get('z0'));
              z1 = double.parse(element.get('z1'));
              z2 = double.parse(element.get('z2'));
              z3 = double.parse(element.get('z3'));
              criancaGet
                  .where('childId', isEqualTo: crianca.id)
                  .where('measureWeekDiff', isEqualTo: age)
                  .get()
                  .then((value2) => {
                        value2.docs.forEach((element2) {
                          kid = double.parse(
                              element2.get(whereMedidaCrianca).toString());
                        })
                      });
              result
                  .add(new GraphData(age, zm3, zm2, zm1, z0, z1, z2, z3, kid));
              kid = null;
            })
          });
  result.sort((a, b) {
    return a.age.compareTo(b.age);
  });
  List<GraphData> result2 = new List<GraphData>();
  for (GraphData element in result) {
    await criancaGet
        .where('childId', isEqualTo: crianca.id)
        .where('measureWeekDiff', isEqualTo: element.age.round())
        .get()
        .then((value2) => {
              value2.docs.forEach((element2) {
                if (kid == null) {
                  kid =
                      double.parse(element2.get(whereMedidaCrianca).toString());
                }
                if (medida == "Altura") {
                  kid *= 100;
                }
              })
            });
    element.kid = kid;
    result2.add(element);
    kid = null;
  }
  ;
  return result2;
}

/// Sample linear data type.
class GraphData {
  GraphData(this.age, this.zm3, this.zm2, this.zm1, this.z0, this.z1, this.z2,
      this.z3, this.kid);
  final double age;
  final double zm1;
  final double zm2;
  final double zm3;
  final double z0;
  final double z1;
  final double z2;
  final double z3;
  double kid;
}
