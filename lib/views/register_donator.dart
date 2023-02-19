// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as develtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';

// import '../firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

class RegisterViewDonator extends StatefulWidget {
  const RegisterViewDonator({super.key});

  @override
  State<RegisterViewDonator> createState() => _RegisterViewDonatorState();
}

class _RegisterViewDonatorState extends State<RegisterViewDonator> {
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
          title: const Text("Register Donator"),
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
                  border: const OutlineInputBorder(
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
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email, password: password);
                    final user = FirebaseAuth.instance.currentUser;
                    final userUID = user?.uid;
                    develtools.log(userUID.toString());

                    // Making Types of user
                    CollectionReference fsUsers =
                        FirebaseFirestore.instance.collection('Donators');
                    await fsUsers.add({'uid': userUID});
                    final shouldSend = await verifyEmailDialog(context);
                    if (shouldSend) {
                      await user?.sendEmailVerification();
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        '/logindonator/',
                        (route) => false,
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      develtools.log("Weak Password");
                    } else if (e.code == 'email-already-in-use') {
                      develtools.log("Email Already in Use");
                    } else if (e.code == 'invalid-email') {
                      develtools.log("Invalid Email");
                    }
                  }
                },
                child: const Text("Register",
                    style: TextStyle(color: Colors.white)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  TextButton(
                      onPressed: (() {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/logindonator/', (route) => false);
                      }),
                      child: const Text("Login",
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
