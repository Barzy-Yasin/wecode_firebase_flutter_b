// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CrudOperationsScreen extends StatelessWidget {
  CrudOperationsScreen({Key? key}) : super(key: key);

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final TextEditingController _nameController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: FutureBuilder<DocumentSnapshot>(
                  future: readSingleDocument(),
                  builder: (context, snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                       return CircularProgressIndicator();
                     } else if (snapshot.data == null || !snapshot.hasData) {
                       return Text('snapshot is empty');
                     } else if (snapshot.hasError) {
                       return Text(snapshot.error.toString());
                     }
                     return Text(snapshot.data!.data().toString());
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    controller: _nameController,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ),
              Divider(
                height: 25,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() == true) {
                    debugPrint('form validated');
                    await addNameToDB(name: _nameController.value.text)
                        .then((value) => debugPrint(value.path));
                  } else {
                    debugPrint('form not validated');
                  }
                },
                child: Text('Add Data'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<DocumentReference> addNameToDB({required String name}) async {
    DocumentReference _doc = await _firebaseFirestore.collection('names').add({
      "first_name": name,
    });
    return _doc;
  }

  Future<DocumentSnapshot> readSingleDocument() async {
    DocumentSnapshot _doc =
        await _firebaseFirestore.collection("names").doc("FQogtklFa0Rz0QC3M9qX").get();
  print(_doc.data());
    return _doc;
  }

}
