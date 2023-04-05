// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:developer' as devetools show log;
import '../assets/country_cities.dart';
import '../main.dart';
import 'details_donator.dart';

List<String> statesList = [];

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
  String cityValue = "";
  bool _clicked = false;
  bool nullState = false;
  FToast? fToast;
  String _countryCode = "971";
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
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
                                        child: Text("NGO Details",
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
                                        keyboardType: TextInputType.text,
                                        textInputAction: TextInputAction.next,
                                        decoration: const InputDecoration(
                                          labelText: "NGO Name",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon: Icon(Icons.store),
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
                                        controller: _ngoName,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your ngo's name";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 14),
                                      IntlPhoneField(
                                        disableLengthCheck: true,
                                        validator: (p0) {
                                          devetools.log(p0!.number);
                                          if (p0.number.isEmpty) {
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
                                        controller: _ngoNumber,
                                      ),
                                      const SizedBox(height: 14),
                                      DropdownFormFieldCountry(
                                        notSavedChanges: null,
                                        initialValue: null,
                                        isEditing: true,
                                        labelText: "Country",
                                        items: countries,
                                        validator: (value) {
                                          if (value == null) {
                                            return "Please select a country";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          countryValue = value!;
                                          devetools.log("sdsadasd");
                                          setState(() {
                                            nullState = true;
                                            statesList =
                                                getStates(countryValue);
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 14),
                                      DropdownCity(
                                        nullState: nullState,
                                        labelText: "Region",
                                        items: statesList,
                                        validator: (value) {
                                          if (value == null) {
                                            return "Please select a city";
                                          }
                                          return null;
                                        },
                                        onChanged: (value) {
                                          cityValue = value!;
                                          nullState = false;
                                        },
                                      ),
                                      const SizedBox(height: 14),
                                      TextFormField(
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          labelText: "Address Line",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon:
                                              Icon(Icons.maps_home_work),
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
                                        controller: _address,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return "Please enter your ngo's address line";
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

                                            String userID = "";
                                            final user = FirebaseAuth
                                                .instance.currentUser;
                                            userID = await findDocID(
                                                user?.uid ?? "None", "NGOs");
                                            final number =
                                                "+${_countryCode.trim()}-${_ngoNumber.text.trim()}";
                                            final numberRegistered =
                                                await containNumber(number);
                                            if (numberRegistered) {
                                              Navigator.of(context).pop();
                                              _ngoNumber.text = "";
                                              showToast(
                                                  "Number already in use");
                                            } else {
                                              try {
                                                await FirebaseFirestore.instance
                                                    .collection('NGOs')
                                                    .doc(userID)
                                                    .update({
                                                  'NGO Name':
                                                      _ngoName.text.trim(),
                                                  'NGO Contact Number':
                                                      "+${_countryCode.trim()}-${_ngoNumber.text.trim()}",
                                                  'Country':
                                                      countryValue.trim(),
                                                  'City': cityValue.trim(),
                                                  'Address Line':
                                                      _address.text.trim(),
                                                });
                                                Navigator.of(context)
                                                    .pushNamedAndRemoveUntil(
                                                        '/homengo/',
                                                        (route) => false);
                                              } on FirebaseAuthException catch (e) {
                                                if (e.code == 'not-found') {
                                                  Navigator.of(context).pop();
                                                  showToast("User not found");
                                                }
                                              } finally {}
                                            }
                                          }
                                        },
                                        child: const Text("Submit",
                                            style:
                                                TextStyle(color: Colors.white)),
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
}
