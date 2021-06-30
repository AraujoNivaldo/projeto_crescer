import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:math';
import 'package:tela1/telaCadastro.dart';
import 'package:tela1/telaPrincipal.dart';
import 'package:tela1/telaRecupera.dart';
import 'package:tela1/child.dart';

class telaGrafico extends StatefulWidget {
  telaGrafico(Child crianca, String medida) {
    this.crianca = crianca;
    this.medida = medida;
  }

  Child crianca;
  String medida;

  @override
  _telaGrafico createState() => _telaGrafico(crianca, medida);
}

class _telaGrafico extends State<telaGrafico> {
  Child crianca;
  String medida = '';

  _telaGrafico(Child crianca, medida) {
    this.crianca = crianca;
    this.medida = medida;
  }

  List<GraphData> _chartData;
  @override
  void initState() {
    _chartData = getGraph();
    super.initState();
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
              SfCartesianChart(
                series: <ChartSeries>[
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.zm1,
                      color: Color.fromRGBO(255, 255, 0, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.z0,
                      color: Color.fromRGBO(0, 255, 0, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.z1,
                      color: Color.fromRGBO(255, 255, 0, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.kid,
                      color: Color.fromRGBO(0, 0, 0, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.z2,
                      color: Color.fromRGBO(255, 0, 0, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.zm2,
                      color: Color.fromRGBO(255, 0, 0, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.z3,
                      color: Color.fromRGBO(0, 0, 255, 1)),
                  SplineSeries<GraphData, double>(
                      dataSource: _chartData,
                      xValueMapper: (GraphData teste, _) => teste.age,
                      yValueMapper: (GraphData teste, _) => teste.zm3,
                      color: Color.fromRGBO(0, 0, 255, 1)),
                ],
                primaryXAxis: CategoryAxis(),
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
                              builder: (context) => telaPrincipal()),
                        );
                      },
                      child: Text('Voltar')),
                  RaisedButton(
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => telaPrincipal()),
                        );
                      },
                      child: Text('Exportar'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<GraphData> getGraph() {
    final List<GraphData> chartData = [
      GraphData(27, 0.36, 0.44, 0.55, 0.67, 0.83, 1.02, 1.25, 0.60),
      GraphData(28, 0.46, 0.56, 0.68, 0.83, 1.01, 1.23, 1.50, 0.80),
      GraphData(29, 0.57, 0.69, 0.83, 1.00, 1.21, 1.46, 1.76, 1.20),
      GraphData(30, 0.69, 0.83, 0.99, 1.19, 1.42, 1.70, 2.04, null),
      GraphData(31, 0.83, 0.98, 1.17, 1.39, 1.65, 1.96, 2.33, 1.30),
      GraphData(32, 0.97, 1.14, 1.35, 1.60, 1.89, 2.23, 2.63, 1.65)
    ];
    return chartData;
  }
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
  final double kid;
}
