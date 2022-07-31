// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CrudOperationsScreen extends StatelessWidget {
  CrudOperationsScreen({Key? key}) : super(key: key);

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('hello'),
              ElevatedButton(
                onPressed: () {
                  addNameToDB();
                },
                child: Text('Add Data'),
              )
            ],
          ),
        ),
      ),
    );
  }

  addNameToDB() {
    _firebaseFirestore.collection('names').add({
      "first_name": "Baralilo_2",
    });
  }
}
