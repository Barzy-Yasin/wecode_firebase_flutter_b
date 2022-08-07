
// ignore_for_file: avoid_print

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
      appBar: AppBar(
        title: const Text('stream builder '),
      ),
      // ignore: avoid_unnecessary_containers
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // reading entire collection using streamBuilder
              Expanded(
                child: Container(
                  // height: 200,
                  padding: const EdgeInsets.all(20),
                  child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    stream: _firebaseFirestore.collection('names').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("err ${snapshot.error}");
                      } else if (snapshot.data == null || !snapshot.hasData) {
                        return const Text('snapshot is empty(StreamBuilder)');
                      }

                      snapshot.data!.docs.first;

                      return ListView.separated(
                          itemCount: snapshot.data!.docs.length,
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(
                              thickness: 2.5,
                            );
                          },
                          itemBuilder: (BuildContext context, int index) {
                            final theRecord = snapshot.data!.docs[index].data();
                            return ListTile(
                              title: Text(
                                "${index + 1}: ${theRecord["first_name"]}",
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    _firebaseFirestore
                                        .collection('names')
                                        .where('first_name',
                                            isEqualTo: theRecord["first_name"])
                                        .get()
                                        .then((value) => value
                                            .docs.first.reference
                                            .delete());
                                            debugPrint('debug record deleted (${theRecord["first_name"]})');
                                            print('record deleted (${theRecord["first_name"]})');
                                            // debugger();
                                  },
                                  icon: const Icon(Icons.add)),
                            );
                          });
                    },
                  ),
                ),
              ),

              // getDataUsingFutureBuilder(), // to read data using future builder    (rendering)
              readOneDocumentWidget(), //  read data readSingleDocument()   (rendering)

              // input TextFormField inside form
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
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  ),
                ),
              ),
              const Divider(
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
                child: const Text('Add Data'),
              )
            ],
          ),
        ),
      ),
    );
  }

  // write (upload) data to firestore
  Future<DocumentReference> addNameToDB({required String name}) async {
    DocumentReference doc = await _firebaseFirestore.collection('names').add({
      "first_name": name,
    });
    return doc;
  }

  // read data from firestore, one element
  Future<DocumentSnapshot> readSingleDocument() async {
    DocumentSnapshot doc =
        await _firebaseFirestore.collection("names").doc(valueId).get();
    print(doc.data());
    return doc;
  }

  // returning all the data inside a collection once
  Future<QuerySnapshot<Map<String, dynamic>>> getDataOnceUsingFuture() async {
    return await _firebaseFirestore.collection('names').get();
  }

  // to read data using future builder    (rendering)
  Widget getDataUsingFutureBuilder() {
    return Column(
      children: [
        const Text('read the entire collection once'),
        // ignore: sized_box_for_whitespace
        Container(
          height: 350,
          child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: getDataOnceUsingFuture(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else if (snapshot.data == null) {
                return const Text('snapshottt no data');
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
                    margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text(
                        "${index + 1}: ${snapshot.data!.docs[index].data()["first_name"]}"),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  //  read data readSingleDocument()   (rendering)
  Widget readOneDocumentWidget() {
    return // rendering read data readSingleDocument()
        Column(
      children: [
        const Text('read one specific document'),
        // ignore: avoid_unnecessary_containers
        Container(
          child: FutureBuilder<DocumentSnapshot>(
            future: readSingleDocument(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.data == null || !snapshot.hasData) {
                return const Text('snapshot is empty');
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
      ],
    );
  }
}
