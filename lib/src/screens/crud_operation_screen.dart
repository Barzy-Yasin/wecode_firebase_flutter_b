// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

// import 'dart:html';

// import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CrudOperationsScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  CrudOperationsScreen({Key? key}) : super(key: key);

  @override
  State<CrudOperationsScreen> createState() => _CrudOperationsScreenState();
}

class _CrudOperationsScreenState extends State<CrudOperationsScreen> {
  // FirbaseFirestore instance
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  // TextFormField controller variable
  final TextEditingController _nameController = TextEditingController();

  // validation key
  final _formKey = GlobalKey<FormState>();

  String valueId = "";

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
              // rendering read data readSingleDocument() 
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
                    //  return Text(snapshot.data!.data().toString());
                    Map<String, dynamic> name = snapshot.data!.data() as Map<String, dynamic>;
                    return Text(name.values.first);
                  },
                ),
              ),
              // input TextFormField inside form
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
              // add data button 
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() == true) {
                    debugPrint('form validated');
                    await addNameToDB(name: _nameController.value.text)
                        .then((value) {
                          debugPrint(value.path);
                          setState(() {
                            valueId = value.id;
                          });
                          debugPrint('current value.id=  ${value.id}');
                        });
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

  // write (upload) data to firestore
  Future<DocumentReference> addNameToDB({required String name}) async {
    DocumentReference _doc = await _firebaseFirestore.collection('names').add({
      "first_name": name,
    });
    return _doc;
  }

  // read data from firestore
  Future<DocumentSnapshot> readSingleDocument() async {
    DocumentSnapshot _doc =
        await _firebaseFirestore.collection("names").doc(valueId).get();
  print(_doc.data());
    return _doc;
  }
}
