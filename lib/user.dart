import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tela1/child.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class User {
  final String id;
  final String name;
  final String email;
  List<Child> listaCriancas = [];

  User({this.id, this.name, this.email});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['usuario_email'],
        name: json['usuario_nome'],
        id: json['usuario_id']);
  }

  Future loadChilds() async {
    List<Child> newList = [];
    CollectionReference criancas =
        FirebaseFirestore.instance.collection('childs');
    String childId;
    String userId;
    String childName;
    String childBirth;
    bool isPrematuro;
    bool isSDD;
    criancas.where('userId', isEqualTo: this.id).get().then((value2) => {
          value2.docs.forEach((element) {
            childId = element.id;

            userId = element.get('userId');
            childName = element.get('childName');
            childBirth = element.get('childBirth');
            isPrematuro = element.get('isPrematuro');
            isSDD = element.get('isSDD');

            Child crianca = new Child(
                id: childId,
                userId: userId,
                childName: childName,
                childBirth: childBirth,
                isPrematuro: isPrematuro,
                isSDD: isSDD);
            newList.add(crianca);
          })
        });
    listaCriancas = newList;
  }

  factory User.fromFirestore(QuerySnapshot<Object> user) {
    String email = user.docs[0].get('email');
    String name = user.docs[0].get('name');
    String idUser = user.docs[0].get('id');
    return User(id: idUser, name: name, email: email);
  }

  Map<String, dynamic> toJson() => {
        'usuario_nome': name,
        'usuario_email': email,
      };
}
