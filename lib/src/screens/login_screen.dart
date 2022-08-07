import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wecode_firebase_flutter_b/src/screens/register_screen.dart';
import 'package:wecode_firebase_flutter_b/src/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

    final Auth _auth = Auth(); // provide access throuhg Auth class in auth_service.dart file 

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text('connection state is waiting'));
          } else if (snapshot.hasError) {
            return Text('snapshot.hasError the error is: ${snapshot.error}');
          } else if (snapshot.data == null) {
            return notLoggedIn(context);
          }
          return theUserIsLoggedIn(snapshot.data!.email!.toString());
        });
  }


  Widget notLoggedIn(context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
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
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all(3),
                        shadowColor:
                            MaterialStateProperty.all(Colors.blueAccent)),
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

                          await _auth.loginWithUserAndPassword(
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
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget theUserIsLoggedIn(String email) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Hello dear "$email"'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text('You are logged in successfully'),
                SizedBox(height: 15),
                Icon(Icons.check_circle, color: Colors.teal,)
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: () {
              FirebaseAuth.instance.signOut();
            }, child: const Text('Logout'))
          ],
        ),
      ),
    );
  }
}
