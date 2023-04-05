// ignore_for_file: use_build_context_synchronously
import "dart:io";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sfm/assets/country_cities.dart';
import '../assets/profile_pic.dart';
import '../assets/storage_service.dart';
import '../main.dart';
import 'dart:developer' as devetools show log;

import 'login_donator.dart';

String countryCode = "";
String firstCountryCode = "";
String cFullName = "";
String cNumber = "";
String cEmail = "";
String cPassword = "********";
String cCPassword = "********";
String cStoreName = "";
String cStoreNumber = "";
String cStoreAddress = "";
String cCountry = "";
String cCity = "";
String countryValue = "";
String cityValue = "";
List<String> statesList = [];
final imageHelper = ImageHelper();
final Storage storage = Storage();
String filePath = "";
String fileName = "";
ImageProvider<Object>? networkFile = const NetworkImage("");

class GetDetailsDonator extends StatefulWidget {
  const GetDetailsDonator({super.key});

  @override
  State<GetDetailsDonator> createState() => _GetDetailsDonatorState();
}

class _GetDetailsDonatorState extends State<GetDetailsDonator> {
  late Future<String> _getDetails;
  @override
  void initState() {
    _getDetails = getDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _getDetails,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Stack(
              children: [
                const ProfileDonator(
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                  "",
                ), // replace with your own widget
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                      child: Dialog(
                    // The background color
                    backgroundColor: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
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
                  )),
                ),
              ],
            );
          case ConnectionState.done:
            return ProfileDonator(
              cFullName,
              cNumber,
              cEmail,
              cPassword,
              cCPassword,
              cStoreName,
              cStoreAddress,
              cStoreNumber,
            ); // replace with your own widget
          default:
            return const Scaffold();
        }
      },
    );
  }
}

class ProfileDonator extends StatefulWidget {
  final String aFulltName;
  final String aNumber;
  final String aEmail;
  final String aPassword;
  final String aCPassword;
  final String aStoreName;
  final String aStoreNumber;
  final String aStoreAddress;

  const ProfileDonator(
      this.aFulltName,
      this.aNumber,
      this.aEmail,
      this.aPassword,
      this.aCPassword,
      this.aStoreName,
      this.aStoreAddress,
      this.aStoreNumber,
      {super.key});

  @override
  State<ProfileDonator> createState() => _ProfileDonatorState();
}

class _ProfileDonatorState extends State<ProfileDonator> {
  late final TextEditingController _storeName;
  late final TextEditingController _storeNumber;
  late final TextEditingController _address;
  late final TextEditingController _fullname;
  late final TextEditingController _number;
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _cpassword;
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  final focus = FocusNode();
  bool isObscure = true;
  bool isObscureC = true;
  bool clicked = false;
  bool isEditing = false;
  bool isEditingEP = false;
  bool isEditing2 = false;
  bool nullState = false;
  bool clicked2 = false;
  bool? notSavedChanges;
  bool _showFirstForm = true;
  String _countryCode = "971";
  String _firstCountryCode = "971";

  FToast? fToast;
  late final TextEditingController _resetEmail;
  final _formKeyReset = GlobalKey<FormState>();
  bool _clickedReset = false;

  File? _image;
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    _fullname = TextEditingController(text: widget.aFulltName);
    _number = TextEditingController(text: widget.aNumber);
    _email = TextEditingController(text: widget.aEmail);
    _password = TextEditingController(text: widget.aPassword);
    _cpassword = TextEditingController(text: widget.aCPassword);
    _storeName = TextEditingController(text: widget.aStoreName);
    _storeNumber = TextEditingController(text: widget.aStoreNumber);
    _address = TextEditingController(text: widget.aStoreAddress);
    _resetEmail = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _resetEmail.dispose();
    _storeName.dispose();
    _storeNumber.dispose();
    _address.dispose();
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
                        backgroundColor: Colors.transparent,
                        resizeToAvoidBottomInset: false,
                        body: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // SizedBox(
                                  //   height:
                                  //       MediaQuery.of(context).size.height * 0.072,
                                  // ),
                                  InkWell(
                                    onTap: () async {
                                      showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            bottomSheet(context),
                                      );
                                    },
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: CircleAvatar(
                                          backgroundColor: Colors.grey[300],
                                          radius: 42,
                                          foregroundImage: filePath == ""
                                              ? (_image != null
                                                  ? FileImage(_image!)
                                                  : const AssetImage(
                                                          "assets/images/user2.png")
                                                      as ImageProvider<Object>?)
                                              : networkFile,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 14,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor: _showFirstForm
                                                ? MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF05240E))
                                                : MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF138034))),
                                        onPressed: () {
                                          setState(() {
                                            _showFirstForm = true;
                                            isEditing2 = false;
                                            _storeName.text = cStoreName;
                                            _storeNumber.text = cStoreNumber;
                                            _address.text = cStoreAddress;
                                            statesList = getStates(cCountry);
                                            nullState = false;
                                          });
                                        },
                                        child: Text("User Details",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontFamily: "Roboto")),
                                      ),
                                      const SizedBox(
                                        width: 24,
                                      ),
                                      TextButton(
                                        style: ButtonStyle(
                                            backgroundColor: _showFirstForm
                                                ? MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF138034))
                                                : MaterialStateProperty.all<
                                                        Color>(
                                                    const Color(0xFF05240E))),
                                        onPressed: () {
                                          setState(() {
                                            _showFirstForm = false;
                                            isEditing = false;
                                            isEditingEP = false;
                                            _fullname.text = cFullName;
                                            _number.text = cNumber;
                                            _email.text = cEmail;
                                          });
                                        },
                                        child: Text("Store Details",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                fontFamily: "Roboto")),
                                      ),
                                    ],
                                  ),
                                  _showFirstForm
                                      ? _buildUserForm()
                                      : _buildDonatorForm(),
                                ],
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

  Widget _buildUserForm() {
    return Form(
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.025,
        ),
        TextFormField(
          style: isEditing
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          enabled: isEditing,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey.shade200,
            labelText: "Full Name",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: const Icon(Icons.person),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
          controller: _fullname,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your fullname";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        IntlPhoneField(
          disableLengthCheck: true,
          validator: (p0) {
            devetools.log(p0!.number);
            if (p0.number.isEmpty) {
              return "Please enter your contact number";
            } else if (p0.number.length < 8 || p0.number.length > 9) {
              return 'Please enter valid contact number';
            }

            return null;
          },
          onCountryChanged: (value) {
            setState(() {
              _firstCountryCode = value.dialCode;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialCountryCode: getCountryCode(firstCountryCode),
          flagsButtonPadding: const EdgeInsets.only(left: 12),
          dropdownIconPosition: IconPosition.trailing,
          style: isEditing
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          enabled: isEditing,
          // textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
            filled: true,
            fillColor: isEditing ? Colors.white : Colors.grey.shade200,
            labelText: "Contact Number",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: const Icon(Icons.phone),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
          controller: _number,
        ),
        const SizedBox(height: 12),
        TextFormField(
          style: isEditingEP
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          controller: _email,
          enabled: isEditingEP,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            filled: true,
            fillColor: isEditingEP ? Colors.white : Colors.grey.shade200,
            labelText: "Email",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: const Icon(Icons.email),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
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
        const SizedBox(height: 12),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        Column(
          children: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green)),
              onPressed: () async {
                if (isEditing == false) {
                  setState(() {
                    isEditing = true;
                  });
                } else {
                  setState(() {
                    clicked = true;
                  });
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (formKey.currentState!.validate()) {
                    final shouldSave = await confirmChangesDialog(context, "");
                    showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (_) {
                          return Dialog(
                            // The background color
                            backgroundColor: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
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
                    if (shouldSave) {
                      final number =
                          "+${_firstCountryCode.trim()}-${_number.text.trim()}";
                      final numberRegistered = await containNumber(number);
                      if (numberRegistered && _number.text != cNumber) {
                        Navigator.of(context).pop();
                        _number.text = "";
                        showToast("Number already in use");
                      } else {
                        final user = FirebaseAuth.instance.currentUser;
                        final userid = user!.uid;
                        final userDocID = await findDocID(userid, "Donators");
                        try {
                          if (_fullname.text != cFullName) {
                            List<String> orders = [];
                            DatabaseReference ref = FirebaseDatabase.instance
                                .ref("Orders/$cCountry/$cCity/$userid/");
                            DatabaseEvent event = await ref.once();
                            if (event.snapshot.value != null) {
                              final data = event.snapshot.value as Map;
                              data.forEach((key, value) {
                                orders.add(key);
                              });
                            }
                            for (String x in orders) {
                              DatabaseReference refs = FirebaseDatabase.instance
                                  .ref("Orders/$cCountry/$cCity/$userid/$x");
                              await refs
                                  .update({"Full Name": _fullname.text.trim()});
                            }
                          }
                          await FirebaseFirestore.instance
                              .collection('Donators')
                              .doc(userDocID)
                              .update({
                            'Full Name': _fullname.text.trim(),
                            'Contact Number':
                                "+${_firstCountryCode.trim()}-${_number.text.trim()}",
                          });
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'not-found') {
                            showToast("User not found");
                          }
                        } finally {
                          // ignore: unused_local_variable
                          String a = await getDetails();
                          setState(() {
                            isEditing = false;
                          });
                          Navigator.of(context).pop();
                        }
                      }
                    } else {
                      await getDetails();
                      setState(() {
                        isEditing = false;
                        isEditing = false;
                        isEditingEP = false;
                        _fullname.text = cFullName;
                        _number.text = cNumber;
                        _email.text = cEmail;
                      });
                      Navigator.of(context).pop();
                    }
                  }
                }
              },
              child: Text(isEditing ? "Save Changes" : "Edit",
                  style: const TextStyle(color: Colors.white)),
            ),
            InkWell(
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0)),
                              borderSide:
                                  BorderSide(color: Colors.green, width: 2.0),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
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
                                devetools.log(userType);
                                if (userType == "Donators") {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(
                                          email: _resetEmail.text);
                                  Navigator.of(context).pop();
                                  showToast("Reset email sent");
                                  _resetEmail.text = "";
                                } else {
                                  showToast("Invalid user");
                                }
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'user-not-found') {
                                  showToast("User not found");
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
              child: const SizedBox(
                height: 30,
                child: Center(
                  child: Text(
                    "Change Password?",
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              ),
            )
          ],
        ),
      ]),
    );
  }

  Widget _buildDonatorForm() {
    return Form(
      key: formKey2,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.025,
        ),
        TextFormField(
          style: isEditing2
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          enabled: isEditing2,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.store),
            labelText: "Store Name",
            filled: true,
            fillColor: isEditing2 ? Colors.white : Colors.grey.shade200,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
          controller: _storeName,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your store's name";
            }
            return null;
          },
        ),
        const SizedBox(height: 12),
        IntlPhoneField(
          disableLengthCheck: true,
          validator: (p0) {
            devetools.log(p0!.number);
            if (p0.number.isEmpty) {
              return "Please enter your contact number";
            } else if (p0.number.length < 8 || p0.number.length > 9) {
              return 'Please enter valid contact number';
            }

            return null;
          },
          onCountryChanged: (value) {
            setState(() {
              _countryCode = value.dialCode;
            });
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          initialCountryCode: getCountryCode(countryCode),
          flagsButtonPadding: const EdgeInsets.only(left: 12),
          dropdownIconPosition: IconPosition.trailing,
          style: isEditing2
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          enabled: isEditing2,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            counterText: "",
            prefixIcon: const Icon(Icons.phone),
            labelText: "Phone Number",
            filled: true,
            fillColor: isEditing2 ? Colors.white : Colors.grey.shade200,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          ),
          controller: _storeNumber,
        ),
        const SizedBox(height: 12),
        DropdownFormFieldCountry(
          notSavedChanges: notSavedChanges,
          initialValue: cCountry,
          isEditing: isEditing2,
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

            setState(() {
              nullState = true;
              statesList = getStates(countryValue);
            });
          },
        ),
        const SizedBox(height: 12),
        DropdownFormFieldCity(
          notSavedChanges: notSavedChanges,
          nullState: nullState,
          initialValue: nullState ? null : cCity,
          isEditing: isEditing2,
          labelText: "City",
          items: statesList,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please select a city";
            }
            return null;
          },
          onChanged: (value) {
            cityValue = value!;
          },
        ),
        const SizedBox(height: 12),
        TextFormField(
          style: isEditing2
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          keyboardType: TextInputType.streetAddress,
          controller: _address,
          enabled: isEditing2,
          decoration: InputDecoration(
            labelText: "Address Line",
            floatingLabelBehavior: FloatingLabelBehavior.auto,
            prefixIcon: const Icon(Icons.maps_home_work),
            filled: true,
            fillColor: isEditing2 ? Colors.white : Colors.grey.shade200,
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(14.0)),
              borderSide: BorderSide(color: Colors.green, width: 2.0),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "Please enter your store's address line";
            }
            return null;
          },
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
          onPressed: () async {
            notSavedChanges = null;
            if (isEditing2 == false) {
              setState(() {
                isEditing2 = true;
              });
            } else {
              setState(() {
                clicked2 = true;
              });
              FocusManager.instance.primaryFocus?.unfocus();
              if (formKey2.currentState!.validate()) {
                final shouldSave = await confirmChangesDialog(context,
                    "(Note: Changing city will remove all your current food listings)");
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) {
                      return Dialog(
                        // The background color
                        backgroundColor: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
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
                if (shouldSave) {
                  final user = FirebaseAuth.instance.currentUser;
                  final userid = user!.uid;
                  notSavedChanges = false;
                  final userDocID = await findDocID(user.uid, "Donators");
                  final number =
                      "+${_countryCode.trim()}-${_storeNumber.text.trim()}";
                  final numberRegistered = await containNumber(number);
                  if (numberRegistered && _storeNumber.text != cStoreNumber) {
                    Navigator.of(context).pop();
                    _storeNumber.text = "";
                    showToast("Number already in use");
                  } else {
                    try {
                      if (countryValue == '') {
                        countryValue = cCountry;
                      }
                      if (cityValue == '') {
                        cityValue = cCity;
                      }
                      if (cityValue != cCity) {
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Orders/$cCountry/$cCity/$userid/");
                        await ref.remove();
                      }
                      if (_storeNumber.text != cStoreNumber) {
                        List<String> orders = [];
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Orders/$cCountry/$cCity/$userid/");
                        DatabaseEvent event = await ref.once();
                        if (event.snapshot.value != null) {
                          final data = event.snapshot.value as Map;
                          data.forEach((key, value) {
                            orders.add(key);
                          });
                        }
                        for (String x in orders) {
                          DatabaseReference refs = FirebaseDatabase.instance
                              .ref("Orders/$cCountry/$cCity/$userid/$x");
                          await refs.update(
                              {"Store Number": _storeNumber.text.trim()});
                        }
                      }
                      if (_storeName.text != cStoreName) {
                        List<String> orders = [];
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Orders/$cCountry/$cCity/$userid/");
                        DatabaseEvent event = await ref.once();
                        if (event.snapshot.value != null) {
                          final data = event.snapshot.value as Map;
                          data.forEach((key, value) {
                            orders.add(key);
                          });
                        }
                        for (String x in orders) {
                          DatabaseReference refs = FirebaseDatabase.instance
                              .ref("Orders/$cCountry/$cCity/$userid/$x");
                          await refs
                              .update({"Store Name": _storeName.text.trim()});
                        }
                      }
                      if (_address.text != cStoreAddress) {
                        List<String> orders = [];
                        DatabaseReference ref = FirebaseDatabase.instance
                            .ref("Orders/$cCountry/$cCity/$userid/");
                        DatabaseEvent event = await ref.once();
                        if (event.snapshot.value != null) {
                          final data = event.snapshot.value as Map;
                          data.forEach((key, value) {
                            orders.add(key);
                          });
                        }
                        for (String x in orders) {
                          DatabaseReference refs = FirebaseDatabase.instance
                              .ref("Orders/$cCountry/$cCity/$userid/$x");
                          await refs.update({"Area": _address.text.trim()});
                        }
                      }
                      await FirebaseFirestore.instance
                          .collection('Donators')
                          .doc(userDocID)
                          .update({
                        'Store Name': _storeName.text.trim(),
                        'Store Contact Number':
                            "+${_countryCode.trim()}-${_storeNumber.text.trim()}",
                        'Country': countryValue.trim(),
                        'City': cityValue.trim(),
                        'Address Line': _address.text.trim(),
                      });
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'not-found') {
                        showToast("User not found");
                      }
                    } finally {
                      setState(() {
                        isEditing2 = false;
                      });
                      await getDetails();
                      nullState = false;
                      Navigator.of(context).pop();
                    }
                  }
                } else {
                  notSavedChanges = true;
                  await getDetails();

                  setState(() {
                    isEditing2 = false;
                    _storeName.text = cStoreName;
                    _storeNumber.text = cStoreNumber;
                    _address.text = cStoreAddress;
                    statesList = getStates(cCountry);
                    nullState = false;
                  });

                  Navigator.of(context).pop();
                }
              }
            }
          },
          child: Text(isEditing2 ? "Save Changes" : "Edit",
              style: const TextStyle(color: Colors.white)),
        ),
      ]),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: <Widget>[
        const Text(
          "Choose Profile Photo",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            TextButton.icon(
                onPressed: (() async {
                  final user = FirebaseAuth.instance.currentUser;
                  final String userID = user!.uid;

                  final files =
                      await imageHelper.pickImage(source: ImageSource.camera);
                  if (files.isNotEmpty) {
                    final croppedFile = await imageHelper.crop(
                        file: files.first, cropStyle: CropStyle.circle);
                    if (croppedFile != null) {
                      devetools.log(croppedFile.path);
                      setState(() {
                        _image = File(croppedFile.path);
                        filePath = "";
                      });
                    }
                    storage.uploadFile(
                        croppedFile!.path, "$userID/userProfile.jpg");
                  }
                  Navigator.pop(context);
                }),
                icon: const Icon(Icons.camera),
                label: const Text("Camera")),
            TextButton.icon(
                onPressed: (() async {
                  final user = FirebaseAuth.instance.currentUser;
                  final String userID = user!.uid;

                  final files = await imageHelper.pickImage();
                  if (files.isNotEmpty) {
                    final croppedFile = await imageHelper.crop(
                        file: files.first, cropStyle: CropStyle.circle);
                    if (croppedFile != null) {
                      devetools.log(croppedFile.path);
                      setState(() {
                        _image = File(croppedFile.path);
                        filePath = "";
                      });
                    }
                    storage.uploadFile(
                        croppedFile!.path, "$userID/userProfile.jpg");
                  }
                  Navigator.pop(context);
                }),
                icon: const Icon(Icons.image),
                label: const Text("Gallery")),
          ],
        )
      ]),
    );
  }
}

Future<String> getDetails() async {
  final user = FirebaseAuth.instance.currentUser;
  final String userID = user!.uid;

  String docID = await findDocID(user.uid, "Donators");
  final data =
      await FirebaseFirestore.instance.collection("Donators").doc(docID).get();
  cFullName = data["Full Name"];
  cNumber = (data["Contact Number"] as String).split("-")[1];
  firstCountryCode = (data["Contact Number"] as String).split("-")[0];
  cEmail = data["Email"];
  cStoreName = data["Store Name"];
  cStoreNumber = (data["Store Contact Number"] as String).split("-")[1];
  countryCode = (data["Store Contact Number"] as String).split("-")[0];
  cStoreAddress = data["Address Line"];
  cCountry = data["Country"];
  cCity = data["City"];
  statesList = getStates(cCountry);
  countryValue = cCountry;
  cityValue = cCity;
  try {
    filePath = await storage.downloadURL("$userID/userProfile.jpg");
    networkFile = NetworkImage(filePath);
  } catch (error) {
    devetools.log(error.toString());
  }
  return "";
}

bool stateListed(String country) {
  List<String> states = getStates(country);
  if (states.isEmpty) {
    return false;
  } else {
    return true;
  }
}
