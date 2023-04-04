// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../assets/country_cities.dart';
import '../main.dart';

List<String> statesList = [];

class DetailsDonator extends StatefulWidget {
  const DetailsDonator({super.key});

  @override
  State<DetailsDonator> createState() => _DetailsDonatorState();
}

class _DetailsDonatorState extends State<DetailsDonator> {
  late final TextEditingController _ngoName;
  late final TextEditingController _ngoNumber;
  late final TextEditingController _address;
  final _formKey = GlobalKey<FormState>();
  String countryValue = "";
  String cityValue = "";
  bool _clicked = false;
  bool nullState = false;

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

  FToast? fToast;

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
                                        child: Text("Store Details",
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
                                          labelText: "Store Name",
                                          floatingLabelBehavior:
                                              FloatingLabelBehavior.auto,
                                          prefixIcon: Icon(Icons.restaurant),
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
                                            return "Please enter your store's name";
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 14),
                                      TextFormField(
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(
                                          labelText: "Store Contact Number",
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
                                        validator: (value) {
                                          String patttern =
                                              r'(^(?:[+0]9)?[0-9]{10,12}$)';
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
                                        labelText: "City",
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
                                            return "Please enter your store's address line";
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
                                                user?.uid ?? "None",
                                                "Donators");

                                            try {
                                              await FirebaseFirestore.instance
                                                  .collection('Donators')
                                                  .doc(userID)
                                                  .update({
                                                'Store Name':
                                                    _ngoName.text.trim(),
                                                'Store Contact Number':
                                                    _ngoNumber.text.trim(),
                                                'Country': countryValue.trim(),
                                                'City': cityValue.trim(),
                                                'Address Line':
                                                    _address.text.trim(),
                                              });
                                              Navigator.of(context)
                                                  .pushNamedAndRemoveUntil(
                                                      '/homedonator/',
                                                      (route) => false);
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'not-found') {
                                                Navigator.of(context).pop();
                                                showToast("User not foud");
                                              }
                                            } finally {}
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

// ignore: must_be_immutable
class DropdownCity extends StatefulWidget {
  final String? labelText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  bool nullState;

  DropdownCity({
    Key? key,
    this.labelText,
    required this.items,
    this.onChanged,
    this.validator,
    required this.nullState,
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DropdownCityState createState() => _DropdownCityState();
}

class _DropdownCityState extends State<DropdownCity> {
  String? _value;
  bool isEmptys = true;

  @override
  void initState() {
    super.initState();
    // if (widget.nullState == true) {
    //   _value = null;
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nullState == true) {
      _value = null;
    }

    return FormField<String>(
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              isEmpty: isEmptys,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: (state.hasError
                      ? const BorderSide(color: Colors.red)
                      : const BorderSide(color: Colors.black)),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: state.hasError
                    ? const TextStyle(color: Colors.red)
                    : TextStyle(color: Colors.grey.shade600),
                prefixIcon: const Icon(Icons.location_city),
                filled: true,
                fillColor: Colors.transparent,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: (_value),
                    isDense: true,
                    onChanged: (String? newValue) {
                      setState(() {
                        isEmptys = false;
                        widget.nullState = false;
                        _value = newValue;
                        widget.onChanged?.call(newValue);
                        state.didChange(newValue);
                      });
                    },
                    items: widget.items.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList()),
              ),
            ),
            if (state.hasError == true)
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 15, bottom: 2),
                child: Text(
                  state.errorText!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).errorColor,
                    height: 0.5,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
