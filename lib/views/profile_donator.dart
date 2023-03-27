// ignore_for_file: use_build_context_synchronously
import "dart:io";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfm/assets/country_cities.dart';
import '../assets/profile_pic.dart';
import '../assets/storage_service.dart';
import '../main.dart';
import 'dart:developer' as devetools show log;

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

XFile? _imageFile;
final ImagePicker _picker = ImagePicker();

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

  File? _image;
  @override
  void initState() {
    _fullname = TextEditingController(text: widget.aFulltName);
    _number = TextEditingController(text: widget.aNumber);
    _email = TextEditingController(text: widget.aEmail);
    _password = TextEditingController(text: widget.aPassword);
    _cpassword = TextEditingController(text: widget.aCPassword);
    _storeName = TextEditingController(text: widget.aStoreName);
    _storeNumber = TextEditingController(text: widget.aStoreNumber);
    _address = TextEditingController(text: widget.aStoreAddress);

    super.initState();
  }

  @override
  void dispose() {
    _storeName.dispose();
    _storeNumber.dispose();
    _address.dispose();
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
                        backgroundColor: Colors.transparent,
                        resizeToAvoidBottomInset: false,
                        body: Padding(
                          padding: const EdgeInsets.all(14.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.072,
                              ),
                              // imageProfile(context),
                              InkWell(
                                onTap: () async {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) => bottomSheet(context),
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
                                              : null)
                                          : networkFile,
                                      child: const Text(
                                        "SA",
                                        style: TextStyle(fontSize: 30),
                                      ),
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
                                            ? MaterialStateProperty.all<Color>(
                                                const Color(0xFF05240E))
                                            : MaterialStateProperty.all<Color>(
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
                                    child: const Text("User Details",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontFamily: "Roboto")),
                                  ),
                                  const SizedBox(
                                    width: 24,
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        backgroundColor: _showFirstForm
                                            ? MaterialStateProperty.all<Color>(
                                                const Color(0xFF138034))
                                            : MaterialStateProperty.all<Color>(
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
                                    child: const Text("Store Details",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
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

  Widget _buildUserForm() {
    return Form(
      key: formKey,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.042,
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
        const SizedBox(height: 14),
        TextFormField(
          style: isEditing
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          enabled: isEditing,
          // textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
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
          validator: (value) {
            String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
            RegExp regExp = RegExp(patttern);
            if (value == null || value.isEmpty) {
              return "Please enter your contact number";
            } else if (!regExp.hasMatch(value)) {
              return 'Please enter valid contact number';
            }

            return null;
          },
        ),
        const SizedBox(height: 14),
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
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: TextFormField(
                style: isEditingEP
                    ? const TextStyle(color: Colors.black)
                    : const TextStyle(color: Colors.grey),
                enabled: isEditingEP,
                onFieldSubmitted: (v) {
                  FocusScope.of(context).requestFocus(focus);
                },
                obscureText: isObscure,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isEditingEP ? Colors.white : Colors.grey.shade200,
                  labelText: "Password",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: const Icon(Icons.lock),
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
                    color: isEditingEP ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(
                        () {
                          isObscure = !isObscure;
                        },
                      );
                    },
                    icon: Icon(
                        !isObscure ? Icons.visibility : Icons.visibility_off),
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
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: TextFormField(
                style: isEditingEP
                    ? const TextStyle(color: Colors.black)
                    : const TextStyle(color: Colors.grey),
                enabled: isEditingEP,
                focusNode: focus,
                obscureText: isObscureC,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isEditingEP ? Colors.white : Colors.grey.shade200,
                  labelText: "Confirm Password",
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  prefixIcon: const Icon(Icons.lock),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(14.0)),
                    borderSide: BorderSide(color: Colors.green, width: 2.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 15.0),
                  suffixIcon: IconButton(
                    color: isEditingEP ? Colors.green : Colors.grey,
                    onPressed: () {
                      setState(
                        () {
                          isObscureC = !isObscureC;
                        },
                      );
                    },
                    icon: Icon(
                        !isObscureC ? Icons.visibility : Icons.visibility_off),
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
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.05,
        ),
        TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green)),
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
                  final user = FirebaseAuth.instance.currentUser;
                  final userDocID =
                      await findDocID(user?.uid ?? "None", "Donators");
                  try {
                    await FirebaseFirestore.instance
                        .collection('Donators')
                        .doc(userDocID)
                        .update({
                      'Full Name': _fullname.text,
                      'Contact Number': _number.text,
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not found")));
                    }
                  } finally {
                    // ignore: unused_local_variable
                    String a = await getDetails();
                    setState(() {
                      isEditing = false;
                    });
                    Navigator.of(context).pop();
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
      ]),
    );
  }

  Widget _buildDonatorForm() {
    return Form(
      key: formKey2,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.042,
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
        const SizedBox(height: 14),
        TextFormField(
          style: isEditing2
              ? const TextStyle(color: Colors.black)
              : const TextStyle(color: Colors.grey),
          enabled: isEditing2,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
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
          validator: (value) {
            String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
            RegExp regExp = RegExp(patttern);
            if (value == null || value.isEmpty) {
              return "Please enter your store's contact number";
            } else if (!regExp.hasMatch(value)) {
              return 'Please enter valid contact number';
            }

            return null;
          },
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Flexible(
              child: DropdownFormFieldCountry(
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
            ),
            const SizedBox(width: 14),
            Flexible(
              child: DropdownFormFieldCity(
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
            ),
          ],
        ),
        const SizedBox(height: 14),
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
          height: MediaQuery.of(context).size.height * 0.05,
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
                    "(Note: Changing city will remove all your current requests)");
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
                  notSavedChanges = false;
                  final user = FirebaseAuth.instance.currentUser;
                  final userDocID =
                      await findDocID(user?.uid ?? "None", "Donators");
                  try {
                    if (countryValue == '') {
                      countryValue = cCountry;
                    }
                    if (cityValue == '') {
                      cityValue = cCity;
                    }
                    await FirebaseFirestore.instance
                        .collection('Donators')
                        .doc(userDocID)
                        .update({
                      'Store Name': _storeName.text,
                      'Store Contact Number': _storeNumber.text,
                      'Country': countryValue,
                      'City': cityValue,
                      'Address Line': _address.text,
                    });
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'not-found') {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not found")));
                    }
                  } finally {
                    await getDetails();
                    nullState = false;
                    Navigator.of(context).pop();
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
                setState(() {
                  isEditing2 = false;
                });
              }
            }
          },
          child: Text(isEditing2 ? "Save Changes" : "Edit",
              style: const TextStyle(color: Colors.white)),
        ),
      ]),
    );
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => bottomSheet(context),
              );
            },
            child: CircleAvatar(
              radius: 42,
              backgroundImage: _imageFile == null
                  ? const AssetImage("assets/images/user2.png")
                  : FileImage(File(_imageFile!.path)) as ImageProvider<Object>?,
            ),
          ),
        ],
      ),
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

  void takePhoto(ImageSource source) async {
    final pickedfile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedfile;
    });
    Navigator.pop(context);
  }
}

Future<String> getDetails() async {
  final user = FirebaseAuth.instance.currentUser;
  final String userID = user!.uid;

  String docID = await findDocID(user.uid, "Donators");
  final data =
      await FirebaseFirestore.instance.collection("Donators").doc(docID).get();
  cFullName = data["Full Name"];
  cNumber = data["Contact Number"];
  cEmail = data["Email"];
  cStoreName = data["Store Name"];
  cStoreNumber = data["Store Contact Number"];
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
