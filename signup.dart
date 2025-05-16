import 'package:flutter/material.dart';
import 'package:my_notes/auth/home_page.dart';
import 'package:my_notes/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_notes/my_provider.dart';

class signup extends StatefulWidget {
  const signup({super.key});

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE5E3DD),
      body: ListView(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 161),
                  child: Container(
                    height: 64,
                    width: 294,
                    alignment: Alignment.center,
                    color: const Color.fromARGB(0, 20, 20, 223),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Mulish',
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 28, left: 28, right: 28),
            child: fixedtexts(hintText: 'Email', theText: email),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 28, right: 28),
            child: fixedtexts(hintText: 'Passowrd', theText: password),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24, left: 28, right: 28),
            child: InkWell(
              onTap: () async {
                try {
                  if (email.text.isEmpty || password.text.isEmpty) {
                    print('Email and Password fields must not be empty.');
                    return;
                  }

                  // Attempt to create a new user
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: email.text.trim(),
                    password: password.text.trim(),
                  );
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomePage()));
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    print('The password provided is too weak.');
                  } else if (e.code == 'email-already-in-use') {
                    print('The account already exists for that email.');
                  }
                } catch (e) {
                  print(e);
                }
              },
              child: Container(
                height: 63,
                width: 319,
                decoration: BoxDecoration(
                  color: const Color(0xFF241C1C),
                  borderRadius: BorderRadius.circular(31.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color.fromARGB(0, 116, 221, 46),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Color(0xFFF5F4F2),
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 28, right: 28),
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Login()));
              },
              child: Container(
                height: 63,
                width: 319,
                decoration: BoxDecoration(
                  color: const Color(0xFFC8C4B7),
                  borderRadius: BorderRadius.circular(31.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    alignment: Alignment.center,
                    color: const Color.fromARGB(0, 116, 221, 46),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        color: Color(0xFF241C1C),
                        fontFamily: 'Mulish',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
