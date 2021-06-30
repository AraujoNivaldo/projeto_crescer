import 'package:flutter/material.dart';
import 'package:tela1/child.dart';
import 'package:tela1/telaAcompanhamento.dart';
import 'package:tela1/telaAddCrianca.dart';
import 'package:tela1/env.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class telaPrincipal extends StatefulWidget {
  telaPrincipal({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _telaPrincipal createState() => _telaPrincipal();
}

class _telaPrincipal extends State<telaPrincipal> {
  _telaPrincipal() {
  }
  ListTile _tile(String title, String subtitle, IconData icon, Child crianca) => ListTile(
        title: Text(title,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text(subtitle),
        leading: Icon(
          icon,
          size: 50,
          color:(crianca.gender.compareTo("M") == 0)? Colors.blue[500] : Colors.pink[500],
        ),
        onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => telaAcompanhamento(
                              crianca)),
                    );
                  }
      );
  ListView childListView(context, List<Child> data){
    return ListView.builder(
      scrollDirection: Axis.vertical,
    shrinkWrap: true,
      itemCount: data.length,
      itemBuilder: (context, index){
       return _tile(data[index].childName, data[index].childBirth, Icons.person, data[index]);
      });
  }

  Future<List<Child>> loadChild() async {
    
    await Env.loggedUser.loadChilds();
    return Env.loggedUser.listaCriancas;
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference listaCriancas = FirebaseFirestore.instance.collection('childs');
    return Scaffold(
      appBar: AppBar(
        title: Text("Olá " + Env.loggedUser.name),
      ),
      
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<QuerySnapshot<Object>>(
              future: listaCriancas.where('userId', isEqualTo: Env.loggedUser.id).get(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  List<Child> newList = [];
                  String childId;
                  String userId;
                  String childName;
                  String childBirth;
                  bool isPrematuro;
                  bool isSDD;
                  String gender;
                  snapshot.data.docs.forEach((element) { 
                    childId = element.id;
                    userId = element.get('userId');
                    childName = element.get('childName');
                    childBirth = element.get('childBirth');
                    isPrematuro = element.get('isPrematuro');
                    isSDD = element.get('isSDD');
                    gender = element.get('gender');

                    Child crianca = new Child(
                        id: childId,
                        userId: userId,
                        childName: childName,
                        childBirth: childBirth,
                        isPrematuro: isPrematuro,
                        isSDD: isSDD,
                        gender: gender);
                    newList.add(crianca);
                          });
                          newList.sort((a, b) {
  return a.childName.toString().toLowerCase().compareTo(b.childName.toString().toLowerCase());
}); 
                return childListView(context, newList);                
                }else if(snapshot.hasError){

                }

                return CircularProgressIndicator();
              }
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
              height: AppBar().preferredSize.height,
              child: DrawerHeader(
                  child: Text(Env.loggedUser.name,
                      style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(color: Colors.blueAccent),
                  margin: EdgeInsets.all(0.0),
                  padding: EdgeInsets.all(20.0)),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => telaAddCrianca()),
          ).then((value) { setState(() {});});
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
