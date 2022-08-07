import 'package:flutter/material.dart';
import 'package:wecode_firebase_flutter_b/src/services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({Key? key}) : super(key: key);

  final Auth _auth = Auth(); // provide access throuhg Auth class in auth_service.dart file 

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
                        _auth.registerWithEmailAndPassword(
                          _userNameController.text,
                          _passwordController.text,
                        ).then((value) => debugPrint(
                            "user email with debug Print: ${value.user!.uid}"));
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
}
