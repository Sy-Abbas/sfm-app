// ignore_for_file: use_build_context_synchronously

import 'dart:developer' as develtools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../main.dart';

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
  final focus = FocusNode();
  bool _clicked = false;
  bool _agree = false;
  FToast? fToast;
  String _countryCode = "971";

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
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

  showToast(String message) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.grey.shade900,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
    fToast!.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
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
              height: MediaQuery.of(context).size.height * 0.035,
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/apple.png"),
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                  Container(
                    width: 48,
                    height: 48,
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
                      height: MediaQuery.of(context).size.height * 0.75,
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
                                        child: Text("NGO Sign Up",
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
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          labelText: "Full Name",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon: Icon(Icons.person),
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
                                        controller: _fullname,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your fullname";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      IntlPhoneField(
                                        disableLengthCheck: true,
                                        validator: (p0) {
                                          if (p0!.number.isEmpty) {
                                            return "Please enter your contact number";
                                          } else if (p0.number.length < 8 ||
                                              p0.number.length > 9) {
                                            return 'Please enter valid contact number';
                                          }

                                          return null;
                                        },
                                        onCountryChanged: (value) {
                                          setState(() {
                                            _countryCode = value.dialCode;
                                          });
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        initialCountryCode: "AE",
                                        flagsButtonPadding:
                                            const EdgeInsets.only(left: 12),
                                        dropdownIconPosition:
                                            IconPosition.trailing,
                                        textInputAction: TextInputAction.next,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          counterText: "",
                                          labelText: "Contact Number",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon: Icon(Icons.phone),
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
                                        controller: _number,
                                      ),
                                      const SizedBox(height: 10),
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
                                      const SizedBox(height: 10),
                                      TextFormField(
                                        onFieldSubmitted: (v) {
                                          FocusScope.of(context)
                                              .requestFocus(focus);
                                        },
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
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      TextFormField(
                                        focusNode: focus,
                                        obscureText: isObscureC,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        decoration: InputDecoration(
                                          labelText: "Confirm Password",
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
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your password";
                                          } else if (value.length < 8) {
                                            return "Length of password's characters must be 8 or greater";
                                          } else if (value != _password.text) {
                                            return "Password don't match";
                                          }
                                          return null;
                                        },
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Theme(
                                            data: ThemeData(
                                                unselectedWidgetColor:
                                                    _clicked && !_agree
                                                        ? Colors.red.shade400
                                                        : Colors.green),
                                            child: Checkbox(
                                                value: _agree,
                                                onChanged: (value) {
                                                  setState(() {
                                                    _agree = value!;
                                                  });
                                                },
                                                activeColor: Colors.green),
                                          ),
                                          Text(
                                            'I agree to the ',
                                            style: TextStyle(
                                                color: _clicked && !_agree
                                                    ? Colors.red.shade600
                                                    : Colors.black),
                                          ),
                                          GestureDetector(
                                            onTap: _showTermsAndConditions,
                                            child: Text(
                                              'Terms & Conditions',
                                              style: TextStyle(
                                                color: _clicked && !_agree
                                                    ? Colors.red.shade600
                                                    : Colors.green,
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                          ),
                                        ],
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
                                            if (_agree) {
                                              showDialog(
                                                  barrierDismissible: false,
                                                  context: context,
                                                  builder: (_) {
                                                    return Dialog(
                                                      // The background color
                                                      backgroundColor:
                                                          Colors.white,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 20),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(14.0),
                                                          child: Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
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
                                              final number =
                                                  "+${_countryCode.trim()}-${_number.text.trim()}";
                                              final numberRegistered =
                                                  await containNumber(number);
                                              if (numberRegistered) {
                                                Navigator.of(context).pop();
                                                _number.text = "";
                                                showToast(
                                                    "Number already in use");
                                              } else {
                                                try {
                                                  await FirebaseAuth.instance
                                                      .createUserWithEmailAndPassword(
                                                          email: email,
                                                          password: password);
                                                  final user = FirebaseAuth
                                                      .instance.currentUser;
                                                  final userUID = user?.uid;

                                                  // Making Types of user
                                                  CollectionReference fsUsers =
                                                      FirebaseFirestore.instance
                                                          .collection('NGOs');
                                                  await fsUsers.add({
                                                    'uid': userUID,
                                                    'Full Name':
                                                        _fullname.text.trim(),
                                                    'Contact Number':
                                                        "+$_countryCode-${_number.text.trim()}",
                                                    'Email': email,
                                                    'Address Line': "",
                                                    'City': "",
                                                    'Country': "",
                                                    'NGO Contact Number': "",
                                                    'NGO Name': "",
                                                    'Approved': "false",
                                                    'Profile Picture': ""
                                                  });
                                                  // ignore: unused_local_variable
                                                  final shouldSend =
                                                      await verifyEmailDialog(
                                                          context);
                                                  await user
                                                      ?.sendEmailVerification();
                                                  Navigator.of(context)
                                                      .pushNamedAndRemoveUntil(
                                                    '/loginngo/',
                                                    (route) => false,
                                                  );
                                                } on FirebaseAuthException catch (e) {
                                                  if (e.code ==
                                                      'email-already-in-use') {
                                                    showToast(
                                                        "Email already in use");
                                                  } else if (e.code ==
                                                      'invalid-email') {
                                                    showToast("Invalid user");
                                                  }
                                                  Navigator.of(context).pop();
                                                } finally {}
                                              }
                                            } else {
                                              showToast(
                                                  "You can't register unless you agree to the terms and conditions.");
                                            }
                                          }
                                        },
                                        child: const Text("Register",
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
                                                0.072,
                                          ),
                                          const Text(
                                              "Already have an account?"),
                                          const SizedBox(
                                            width: 5,
                                          ),
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
                                                        '/loginngo/',
                                                        (route) => true);
                                              }),
                                              child: const Text("Login",
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
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage("assets/images/burger.png"),
                      fit: BoxFit.fitWidth,
                    )),
                  ),
                  Container(
                    width: 48,
                    height: 48,
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

  void _showTermsAndConditions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Terms & Conditions',
            style: TextStyle(fontFamily: "RobotoBold"),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'By downloading or using the app, these terms will automatically apply to you – you should make sure therefore that you read them carefully before using the app. You’re not allowed to copy or modify the app, any part of the app, or our trademarks in any way. You’re not allowed to attempt to extract the source code of the app, and you also shouldn’t try to translate the app into other languages or make derivative versions. The app itself, and all the trademarks, copyright, database rights, and other intellectual property rights related to it, still belong to Syed Abbas Hussain.\n\nSyed Abbas Hussain is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for.\n\nThe Surplus Food Management app stores and processes personal data that you have provided to us, to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Surplus Food Management app won’t work properly or at all.',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16.0,
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
