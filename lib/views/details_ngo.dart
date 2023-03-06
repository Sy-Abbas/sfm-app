import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devetools show log;

import '../main.dart';

class DetailsNGO extends StatefulWidget {
  const DetailsNGO({super.key});

  @override
  State<DetailsNGO> createState() => _DetailsNGOState();
}

class _DetailsNGOState extends State<DetailsNGO> {
  late final TextEditingController _ngoName;
  late final TextEditingController _ngoNumber;
  late final TextEditingController _address;
  final _formKey = GlobalKey<FormState>();
  String countryValue = "";
  String stateValue = "";
  bool _isLoading = false;

  @override
  void initState() {
    _ngoName = TextEditingController();
    _ngoNumber = TextEditingController();
    _address = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _ngoName.dispose();
    _ngoNumber.dispose();
    _address.dispose();

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
                                    child: const Text("Details NGO",
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
                                    textInputAction: TextInputAction.next,
                                    decoration: const InputDecoration(
                                      hintText: "NGO Name",
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
                                    controller: _ngoName,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your ngo's name";
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: "NGO Contact Number",
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
                                    controller: _ngoNumber,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      String patttern =
                                          r'(^(?:[+0]9)?[0-9]{10,12}$)';
                                      RegExp regExp = RegExp(patttern);
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your ngo's contact number";
                                      } else if (!regExp.hasMatch(value)) {
                                        return 'Please enter valid contact number';
                                      }

                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 10),
                                  FormField(
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please select country and city";
                                      }
                                      return null;
                                    },
                                    builder: (formFieldState) {
                                      late InputBorder shape;
                                      if (formFieldState.hasError) {
                                        shape = OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.red),
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                        );
                                      } else {
                                        shape = OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(14.0),
                                        );
                                      }
                                      return Column(
                                        children: [
                                          CSCPicker(
                                            flagState: CountryFlag.DISABLE,
                                            onCountryChanged: (value) {
                                              setState(() {
                                                countryValue = value;
                                              });
                                            },
                                            onCityChanged: (value) {},
                                            onStateChanged: (value) {
                                              if (value != null) {
                                                formFieldState.didChange(value);
                                                setState(() {
                                                  stateValue = value;
                                                });
                                              }
                                            },
                                            stateDropdownLabel: "City",
                                            showCities: false,
                                            defaultCountry:
                                                CscCountry.United_Arab_Emirates,
                                            dropdownDecoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14.0)),
                                              border: Border.fromBorderSide(
                                                  shape.borderSide),
                                            ),
                                            disabledDropdownDecoration:
                                                BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14.0)),
                                              border: Border.fromBorderSide(
                                                  shape.borderSide),
                                            ),
                                            selectedItemStyle: const TextStyle(
                                                color: Colors.black),
                                            stateSearchPlaceholder:
                                                "Search City",
                                          ),
                                          if (formFieldState.hasError)
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Padding(
                                                padding: EdgeInsets.only(
                                                  left: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.0495,
                                                  top: 5,
                                                  bottom: 10,
                                                ),
                                                child: Text(
                                                  formFieldState.errorText!,
                                                  style: TextStyle(
                                                    fontStyle: FontStyle.normal,
                                                    fontSize: 13,
                                                    color: Colors.red[700],
                                                    height: 0.5,
                                                  ),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                            ),
                                        ],
                                      );
                                    },
                                  ),
                                  TextFormField(
                                    keyboardType: TextInputType.text,
                                    decoration: const InputDecoration(
                                      hintText: "Address Line",
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
                                    controller: _address,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter your ngo's address line";
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
                                      if (_formKey.currentState!.validate()) {
                                        setState(() {
                                          _isLoading = true;
                                        });
                                        String userID = "";
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        userID = await findDocID(
                                            user?.uid ?? "None", "NGOs");

                                        try {
                                          await FirebaseFirestore.instance
                                              .collection('NGOs')
                                              .doc(userID)
                                              .update({
                                            'NGO Name': _ngoName.text,
                                            'NGO Contact Number':
                                                _ngoNumber.text,
                                            'Country': countryValue,
                                            'City': stateValue,
                                            'Address Line': _address.text,
                                          });
                                          // ignore: use_build_context_synchronously
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                                  '/homengo/',
                                                  (route) => false);
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'not-found') {
                                            // ignore: use_build_context_synchronously
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "User not found")));
                                          }
                                        } finally {
                                          setState(() {
                                            _isLoading = false;
                                          });
                                        }
                                      }
                                    },
                                    child: _isLoading
                                        ? const CircularProgressIndicator()
                                        : const Text("Submit",
                                            style:
                                                TextStyle(color: Colors.white)),
                                  ),
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
