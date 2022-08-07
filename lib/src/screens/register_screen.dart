import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          const Text('welcome'),
          Container(
            margin: const EdgeInsets.all(15),
            padding: const EdgeInsets.all(15),
            child: Form(
                child: Column(
              children: [
                const SizedBox(height: 10),
                const Text('user name/email'),
                TextFormField(
                  controller: _userNameController,
                ),
                const SizedBox(height: 25),
                const Text('password'),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 25),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: ElevatedButton(
                      onPressed: () {
                        registerWithEmailAndPassword(
                          _userNameController.text,
                          _passwordController.text,
                        ).then((value) => debugPrint("user email with debug Print: ${value.user!.uid}"));
                      },
                      child: const Text(
                        "Register",
                      )),
                )
              ],
            )),
          )
        ],
      ),
    );
  }

  Future<UserCredential> registerWithEmailAndPassword(
      String emailFromTheBody, String passwordFromTheBody) async {
    // ignore: no_leading_underscores_for_local_identifiers
    UserCredential _userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
            email: emailFromTheBody, password: passwordFromTheBody);

    debugPrint("debug Print from method; ${_userCredential.user!.email}");
    return _userCredential;

    //  handle the errors : 
    //try {
    //   final credential =
    //       await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //     email: emailAddress,
    //     password: password,
    //   );
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'weak-password') {
    //     print('The password provided is too weak.');
    //   } else if (e.code == 'email-already-in-use') {
    //     print('The account already exists for that email.');
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
}
