import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecode_firebase_flutter_b/src/screens/register_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: const Text('Login'),
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

                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => RegisterScreen(),
                    ));
                  },
                  style: ButtonStyle(elevation: MaterialStateProperty.all(3), shadowColor: MaterialStateProperty.all(Colors.blueAccent)),
                  child: const Text(
                    'not registered yet? register here!',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
                // ignore: avoid_unnecessary_containers
                Container(
                  child: ElevatedButton(
                      onPressed: () async {
                        debugPrint('username: ${_userNameController.text}');
                        debugPrint('password: ${_passwordController.text}');

                        await loginWithUserAndPassword(
                          email: _userNameController.text,
                          password: _passwordController.text,
                        ).then(
                          (value) => debugPrint(
                              'login succesfully: ${value.user!.email}'),
                        );
                      },
                      child: const Text(
                        "Login",
                      )),
                )
              ],
            )),
          )
        ],
      ),
    );
  }

  Future<UserCredential> loginWithUserAndPassword(
      {required String email, required String password}) {
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
  }
}
