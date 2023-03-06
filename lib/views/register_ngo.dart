// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as develtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../main.dart';

// import '../firebase_options.dart';
// import 'package:firebase_core/firebase_core.dart';

class RegisterViewNGO extends StatefulWidget {
  const RegisterViewNGO({super.key});

  @override
  State<RegisterViewNGO> createState() => _RegisterViewNGOState();
}

class _RegisterViewNGOState extends State<RegisterViewNGO> {
  late final TextEditingController _fullname;
  late final TextEditingController _number;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _cpassword;
  final _formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool isObscureC = true;
  get devetools => null;

  @override
  void initState() {
    _fullname = TextEditingController();
    _number = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    _cpassword = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _fullname.dispose();
    _number.dispose();
    _email.dispose();
    _password.dispose();
    _cpassword.dispose();
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
                                    child: const Text("Register NGO",
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
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: "Full Name",
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
                                    controller: _fullname,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your fullname";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "Contact Number",
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
                                    controller: _number,
                                    validator: (value) {
                                      String patttern =
                                          r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regExp = RegExp(patttern);
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your contact number";
                                      } else if (!regExp.hasMatch(value)) {
                                        return 'Please enter valid contact number';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
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
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Flexible(
                                        child: TextFormField(
                                          obscureText: isObscure,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: "Password",
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
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
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your password";
                                            } else if (value.length < 8) {
                                              return "Length of password's characters must be 8 or greater";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Flexible(
                                        child: TextFormField(
                                          obscureText: isObscureC,
                                          enableSuggestions: false,
                                          autocorrect: false,
                                          decoration: InputDecoration(
                                            hintText: "Confirm Password",
                                            hintStyle: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
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
                                                    horizontal: 15.0,
                                                    vertical: 15.0),
                                            suffixIcon: IconButton(
                                              color: Colors.green,
                                              onPressed: () {
                                                setState(
                                                  () {
                                                    isObscureC = !isObscureC;
                                                  },
                                                );
                                              },
                                              icon: Icon(!isObscureC
                                                  ? Icons.visibility
                                                  : Icons.visibility_off),
                                            ),
                                          ),
                                          controller: _cpassword,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter your password";
                                            } else if (value.length < 8) {
                                              return "Length of password's characters must be 8 or greater";
                                            } else if (value !=
                                                _password.text) {
                                              return "Password don't match";
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
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
                                      final email = _email.text;
                                      final password = _password.text;
                                      if (_formKey.currentState!.validate()) {
                                        try {
                                          await FirebaseAuth.instance
                                              .createUserWithEmailAndPassword(
                                                  email: email,
                                                  password: password);
                                          final user =
                                              FirebaseAuth.instance.currentUser;
                                          final userUID = user?.uid;
                                          develtools.log(userUID.toString());

                                          // Making Types of user
                                          CollectionReference fsUsers =
                                              FirebaseFirestore.instance
                                                  .collection('NGOs');
                                          await fsUsers.add({
                                            'uid': userUID,
                                            'Full Name': _fullname.text,
                                            'Contact Number': _number.text,
                                            'Email': email,
                                          });
                                          final shouldSend =
                                              await verifyEmailDialog(context);
                                          if (shouldSend) {
                                            await user?.sendEmailVerification();
                                            Navigator.of(context)
                                                .pushNamedAndRemoveUntil(
                                              '/loginngo/',
                                              (route) => false,
                                            );
                                          }
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code ==
                                              'email-already-in-use') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "Email already in use")));
                                          } else if (e.code ==
                                              'invalid-email') {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content:
                                                        Text("Invalid Email")));
                                          }
                                        }
                                      }
                                      _fullname.clear();
                                      _number.clear();
                                      _email.clear();
                                      _password.clear();
                                      _cpassword.clear();
                                    },
                                    child: const Text("Register",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.072,
                                      ),
                                      const Text("Already have an account?"),
                                      const SizedBox(
                                        width: 5,
                                      ),
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
                                                    '/loginngo/',
                                                    (route) => true);
                                          }),
                                          child: const Text("Login",
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
                                              TextStyle(color: Colors.green)))
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
