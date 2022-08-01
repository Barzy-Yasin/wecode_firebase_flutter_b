// ignore_for_file: prefer_const_constructors

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
      appBar: AppBar(),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
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
              Divider(),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() == true) {
                    debugPrint('form validated');
                    addNameToDB(name: _nameController.value.text);
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

  addNameToDB({required String name}) {
    _firebaseFirestore.collection('names').add(
      {
        "first_name": name,
      },
    );
  }
}
