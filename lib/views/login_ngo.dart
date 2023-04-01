// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as devetools show log;
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sfm/views/login_donator.dart';
import '../main.dart';

final usesr = FirebaseAuth.instance.currentUser;

class LoginViewNGO extends StatefulWidget {
  const LoginViewNGO({super.key});

  @override
  State<LoginViewNGO> createState() => _LoginViewNGOState();
}

class _LoginViewNGOState extends State<LoginViewNGO> {
  late final TextEditingController _email;

  late final TextEditingController _password;
  bool isObscure = true;
  final _formKey = GlobalKey<FormState>();
  bool _clicked = false;
  late final TextEditingController _resetEmail;
  final _formKeyReset = GlobalKey<FormState>();

  bool _clickedReset = false;

  bool _passwordFaild = false;

  @override
  void initState() {
    _resetEmail = TextEditingController();

    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _resetEmail.dispose();

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
                            autovalidateMode: _clicked
                                ? AutovalidateMode.onUserInteraction
                                : AutovalidateMode.disabled,
                            key: _formKey,
                            child: Center(
                              child: SingleChildScrollView(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF05240E))),
                                        onPressed: () {},
                                        child: Text("Login NGO",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                fontFamily: "Roboto")),
                                      ),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.042,
                                      ),
                                      TextFormField(
                                        textInputAction: TextInputAction.next,
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        decoration: const InputDecoration(
                                          labelText: "Email",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon: Icon(Icons.email),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0)),
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 2.0),
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
                                        obscureText: isObscure,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          labelText: "Password",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon: const Icon(Icons.lock),
                                          border: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0)),
                                          ),
                                          focusedBorder:
                                              const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(14.0)),
                                            borderSide: BorderSide(
                                                color: Colors.green,
                                                width: 2.0),
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 20.0,
                                                  vertical: 15.0),
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
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.02,
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all<
                                                    Color>(Colors.green)),
                                        onPressed: () async {
                                          setState(() {
                                            _clicked = true;
                                          });
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          final email = _email.text;
                                          final password = _password.text;
                                          if (_formKey.currentState!
                                              .validate()) {
                                            showDialog(
                                                barrierDismissible: false,
                                                context: context,
                                                builder: (_) {
                                                  return Dialog(
                                                    // The background color
                                                    backgroundColor:
                                                        Colors.white,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 20),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(14.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: const [
                                                            // The loading indicator
                                                            CircularProgressIndicator(),
                                                            SizedBox(
                                                              width: 15,
                                                            ),

                                                            // Some text
                                                            Text('Loading...')
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                });

                                            try {
                                              final usertype =
                                                  await getUserTypeReset(email);
                                              if (usertype == "NGOs") {
                                                await FirebaseAuth.instance
                                                    .signInWithEmailAndPassword(
                                                        email: email,
                                                        password: password);
                                                final user = FirebaseAuth
                                                    .instance.currentUser;

                                                if (user?.emailVerified ??
                                                    false) {
                                                  String idDoc =
                                                      await findDocID(
                                                          user?.uid ?? "None",
                                                          "NGOs");
                                                  bool isDetail =
                                                      await detailsEntered(
                                                          user?.uid ?? "None",
                                                          "NGOs",
                                                          idDoc);
                                                  if (isDetail == true) {
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/homengo/',
                                                            (route) => false);
                                                  } else {
                                                    Navigator.of(context)
                                                        .pushNamedAndRemoveUntil(
                                                            '/detailsngo/',
                                                            (route) => false);
                                                  }
                                                } else {
                                                  Navigator.of(context).pop();

                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Email Not Verified")));
                                                  final shouldSend =
                                                      await verifyEmailDialog(
                                                          context);
                                                  if (shouldSend) {
                                                    await user
                                                        ?.sendEmailVerification();
                                                  }
                                                }
                                              } else {
                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Invalid User")));
                                              }
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'user-not-found') {
                                                Navigator.of(context).pop();

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "User not found")));
                                                _email.clear();
                                                _password.clear();
                                              } else if (e.code ==
                                                  'wrong-password') {
                                                setState(() {
                                                  _passwordFaild = true;
                                                });
                                                Navigator.of(context).pop();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(const SnackBar(
                                                        content: Text(
                                                            "Wrong Password")));
                                                _password.clear();
                                              }
                                            } finally {}
                                          }
                                        },
                                        child: const Text("Login",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.035,
                                          ),
                                          const Text("Don't have an account? "),
                                          TextButton(
                                              style: TextButton.styleFrom(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.zero,
                                                tapTargetSize:
                                                    MaterialTapTargetSize
                                                        .shrinkWrap,
                                              ),
                                              onPressed: (() {
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/registerngo/',
                                                        (route) => true);
                                              }),
                                              child: const Text("Register",
                                                  style: TextStyle(
                                                      color: Colors.green))),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/homepage2/',
                                                  (route) => false);
                                        },
                                        child: const Text("Change User",
                                            style:
                                                TextStyle(color: Colors.green)),
                                      ),
                                      _passwordFaild
                                          ? resetPassword()
                                          : const SizedBox(),
                                    ]),
                              ),
                            ),
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

  Widget resetPassword() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Reset Password"),
              content: Form(
                key: _formKeyReset,
                autovalidateMode: _clickedReset
                    ? AutovalidateMode.onUserInteraction
                    : AutovalidateMode.disabled,
                child: TextFormField(
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      borderSide: BorderSide(color: Colors.green, width: 2.0),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  ),
                  controller: _resetEmail,
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
              ),
              actions: [
                ElevatedButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _resetEmail.text = "";
                  },
                ),
                ElevatedButton(
                  child: const Text("Reset"),
                  onPressed: () async {
                    setState(() {
                      _clickedReset = true;
                    });
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKeyReset.currentState!.validate()) {
                      try {
                        final userType =
                            await getUserTypeReset(_resetEmail.text);
                        if (userType == "NGOs") {
                          await FirebaseAuth.instance
                              .sendPasswordResetEmail(email: _resetEmail.text);
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Reset Email Sent")));
                          _resetEmail.text = "";
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Invalid User")));
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("User not found")));
                        }
                      }
                    }
                  },
                ),
              ],
            );
          },
        );
      },
      child: SizedBox(
        height: 33,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text("Forgot Password?", style: TextStyle(color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
