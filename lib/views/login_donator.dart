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
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

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
          color: Color(0xFFDBE8D8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/apple.png"),
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/pizzaSlice.png"),
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(42),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.72,
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: Colors.white,
                      child: Scaffold(
                        resizeToAvoidBottomInset: false,
                        body: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFF05240E))),
                                    onPressed: () {},
                                    child: const Text("Login Donator",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontFamily: "Roboto")),
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.072,
                                  ),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: const InputDecoration(
                                      hintText: "Email Address",
                                      hintStyle: TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0)),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0, vertical: 15.0),
                                    ),
                                    controller: _email,
                                    validator: (value) {
                                      String pattern =
                                          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                                      RegExp regex = RegExp(pattern);
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your email address";
                                      } else if (!regex.hasMatch(value)) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 14),
                                  TextFormField(
                                    textInputAction: TextInputAction.next,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    obscureText: isObscure,
                                    enableSuggestions: false,
                                    autocorrect: false,
                                    decoration: InputDecoration(
                                      hintText: "Password",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0)),
                                      ),
                                      focusedBorder: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(14.0)),
                                        borderSide: BorderSide(
                                            color: Colors.green, width: 2.0),
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
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
                                        icon: Icon(!isObscure
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                      ),
                                    ),
                                    controller: _password,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your password";
                                      } else if (value.length < 8) {
                                        return "Length of password's characters must be 8 or greater";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        0.05,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.green)),
                                    onPressed: () async {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      final email = _email.text;
                                      final password = _password.text;
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading =
                                              true; // set isLoading state variable to true
                                        });
                                        try {
                                          await FirebaseAuth.instance
                                              .signInWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          final usertype = await getUserType(
                                              user?.uid ?? "None");
                                          if (usertype == "Donators") {
                                            if (user?.emailVerified ?? false) {
                                              String idDoc = await findDocID(
                                                  user?.uid ?? "None",
                                                  "Donators");
                                              bool isDetail =
                                                  await detailsEntered(
                                                      user?.uid ?? "None",
                                                      "Donators",
                                                      idDoc);
                                              if (isDetail == true) {
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/homedonator/',
                                                        (route) => false);
                                              } else {
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/detailsdonator/',
                                                        (route) => false);
                                              }
                                            } else {
                                              final shouldSend =
                                                  await verifyEmailDialog(
                                                      context);
                                              if (shouldSend) {
                                                await user
                                                    ?.sendEmailVerification();
                                              }
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("Invalid User")));
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "User not found")));
                                            _email.clear();
                                            _password.clear();
                                          } else if (e.code ==
                                              'wrong-password') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Wrong Password")));

                                            _password.clear();
                                          }
                                        } finally {
                                          setState(() {
                                            _isLoading =
                                                false; // set isLoading state variable back to false
                                          });
                                        }
                                      }
                                    },
                                    child: _isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text("Login",
                                            style:
                                                TextStyle(color: Colors.white)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                      ),
                                      const Text("Don't have an account? "),
                                      TextButton(
                                          style: TextButton.styleFrom(
                                            alignment: Alignment.centerLeft,
                                            padding: EdgeInsets.zero,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                          ),
                                          onPressed: (() {
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                                    '/registerdonator/',
                                                    (route) => true);
                                          }),
                                          child: const Text("Register",
                                              style: TextStyle(
                                                  color: Colors.green))),
                                    ],
                                  ),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.zero,
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      onPressed: (() {
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil(
                                                '/homepage/', (route) => false);
                                      }),
                                      child: const Text("Change User",
                                          style:
                                              TextStyle(color: Colors.green))),
                                ]),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/burger.png"),
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/apple.png"),
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
