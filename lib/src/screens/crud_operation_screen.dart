// ignore_for_file: prefer_const_constructors, no_leading_underscores_for_local_identifiers

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
              Column(
                children: [
                  Text('read the entire collection once'),
                  Container(
                    height: 350,
                    child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: getDataOnceUsingFuture(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        } else if (snapshot.data == null) {
                          return Text('snapshottt no data');
                        }
                        // return Text(snapshot.data.toString());
                        // return Text(snapshot.data!.docs.toString()); // returns firestore instances
                        // return Text(snapshot.data!.docs.length.toString()); // returns number of documents inside the collection

                        // snapshot.data!.docs.map((doc) => print (doc.data()));
                        // return Text(snapshot.data!.docs.length.toString());
                        return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            return Container(
                              color: Colors.yellow.shade100,
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Text("${index+1}: ${snapshot.data!.docs[index]
                                  .data()["first_name"]}"),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),

              // rendering read data readSingleDocument()
              Text('read one specific document'),
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
                    Map<String, dynamic> name =
                        snapshot.data!.data() as Map<String, dynamic>;
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

  // read data from firestore, one element
  Future<DocumentSnapshot> readSingleDocument() async {
    DocumentSnapshot _doc =
        await _firebaseFirestore.collection("names").doc(valueId).get();
    print(_doc.data());
    return _doc;
  }

  // returning all the data inside a collection once 
  Future<QuerySnapshot<Map<String, dynamic>>> getDataOnceUsingFuture() async {
    return await _firebaseFirestore.collection('names').get();
  }
  
}
