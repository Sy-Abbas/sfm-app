// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as devetools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class LoginViewDonator extends StatefulWidget {
  const LoginViewDonator({super.key});

  @override
  State<LoginViewDonator> createState() => _LoginViewDonatorState();
}

class _LoginViewDonatorState extends State<LoginViewDonator> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  bool isObscure = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.bottomRight,
        end: Alignment.topLeft,
        colors: [
          Colors.black,
          Color(0xFF00242c),
          Color(0xFF00242c),
          Colors.black,
        ],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Login View Donator"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/homepage/', (route) => false);
              },
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: "Enter your email here",
                  hintStyle: TextStyle(color: Colors.grey),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                ),
                controller: _email,
              ),
              const SizedBox(height: 10),
              TextField(
                obscureText: isObscure,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  hintText: "Enter your password here",
                  hintStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 15.0),
                  suffixIcon: IconButton(
                    color: Colors.green,
                    onPressed: () {
                      setState(
                        () {
                          isObscure = !isObscure;
                        },
                      );
                    },
                    icon: Icon(
                        isObscure ? Icons.visibility : Icons.visibility_off),
                  ),
                ),
                controller: _password,
              ),
              const SizedBox(height: 10),
              TextButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green)),
                onPressed: () async {
                  final email = _email.text;
                  final password = _password.text;
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email, password: password);
                    final user = FirebaseAuth.instance.currentUser;
                    final usertype = await getUserType(user?.uid ?? "None");
                    if (usertype == "Donators") {
                      if (user?.emailVerified ?? false) {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/homedonator/', (route) => false);
                      } else {
                        final shouldSend = await verifyEmailDialog(context);
                        if (shouldSend) {
                          await user?.sendEmailVerification();
                        }
                      }
                    } else {
                      devetools.log("Invalid User");
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      devetools.log("User not found");
                    } else if (e.code == 'wrong-password') {
                      devetools.log("Wrong Password");
                    }
                  }
                },
                child:
                    const Text("Login", style: TextStyle(color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? ",
                      style: TextStyle(color: Colors.white)),
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/registerdonator/', (route) => false);
                      }),
                      child: const Text("Register",
                          style: TextStyle(color: Colors.green))),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
