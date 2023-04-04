import 'dart:developer' as devetools show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sfm/views/details_donator.dart';
import 'package:sfm/views/details_ngo.dart';
import 'package:sfm/views/home_donator.dart';
import 'package:sfm/views/home_ngo.dart';
import 'package:sfm/views/home_page.dart';
import 'package:sfm/views/login_donator.dart';
import 'package:sfm/views/login_ngo.dart';
import 'package:sfm/views/privacy_policy.dart';
import 'package:sfm/views/profile_donator.dart';
import 'package:sfm/views/profile_ngo.dart';
import 'package:sfm/views/recent.chats.dart';
import 'package:sfm/views/register_donator.dart';
import 'package:sfm/views/register_ngo.dart';
import 'firebase_options.dart';

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Surplus Food Management",
      theme: ThemeData(primarySwatch: Colors.green),
      home: const Initialize(),
      routes: {
        '/main/': (context) => const Initialize(),
        '/homepage/': (context) => const Check(),
        '/homepage2/': (context) => const HomePage(),
        '/logindonator/': ((context) => const LoginViewDonator()),
        '/loginngo/': ((context) => const LoginViewNGO()),
        '/registerdonator/': ((context) => const RegisterViewDonator()),
        '/registerngo/': ((context) => const RegisterViewNGO()),
        '/homedonator/': ((context) => const HomeDonators()),
        '/homengo/': ((context) => const HomeNGO()),
        '/detailsngo/': ((context) => const DetailsNGO()),
        '/detailsdonator/': ((context) => const DetailsDonator()),
        '/profilengo/': ((context) => const GetDetailsNGO()),
        '/profiledonator/': (context) => const GetDetailsDonator(),
        '/recentchats/': (context) => RecentChats(),
        '/privacypolicy/': ((context) => const PrivacyPolicy())
      }));
}

class Initialize extends StatelessWidget {
  const Initialize({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsFlutterBinding.ensureInitialized();

    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
        FocusManager.instance.primaryFocus?.unfocus();
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return const Check();
          default:
            return const Scaffold();
        }
      },
    );
  }
}

Future<bool> verifyEmailDialog(BuildContext context) {
  return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Verify Email"),
          content: const Text("Send verification email?"),
          actions: [
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(false);
              }),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(true);
              }),
              child: const Text("Yes"),
            )
          ],
        );
      })).then((value) => value ?? false);
}

Future<String> getUserType(String uid) async {
  var donatorsUID = [];
  await FirebaseFirestore.instance
      .collection('Donators')
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      donatorsUID.add(element["uid"]);
    }
  });
  var ngoUID = [];
  await FirebaseFirestore.instance
      .collection('NGOs')
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      ngoUID.add(element["uid"]);
    }
  });

  if (donatorsUID.contains(uid)) {
    return "Donators";
  } else if (ngoUID.contains(uid)) {
    return "NGOs";
  } else {
    return "None";
  }
}

Future<String> findDocID(String uid, String userT) async {
  String toBe = "None";
  await FirebaseFirestore.instance
      .collection(userT)
      .get()
      .then((QuerySnapshot querySnapshot) {
    for (var element in querySnapshot.docs) {
      if (element["uid"] == uid) {
        toBe = element.id;
      }
    }
  });
  return toBe;
}

Future<bool> detailsEntered(String uid, String userT, String userIDs) async {
  // devetools.log(uid);
  final data =
      await FirebaseFirestore.instance.collection(userT).doc(userIDs).get();
  if (data['Country'] == "") {
    return false;
  } else {
    return true;
  }
}

Future<bool> confirmChangesDialog(BuildContext context, String add) {
  return showDialog<bool>(
      barrierDismissible: false,
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Confirm Changes"),
          content: Text("Are you sure you want to make these changes? $add"),
          actions: [
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(false);
              }),
              child: const Text("No"),
            ),
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(true);
              }),
              child: const Text("Yes"),
            )
          ],
        );
      })).then((value) => value ?? false);
}

class DropdownFormFieldCountry extends StatefulWidget {
  final Widget? icon;
  final String? labelText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final String? initialValue;
  final bool isEditing;
  final bool? nullState;
  bool? notSavedChanges;

  DropdownFormFieldCountry(
      {Key? key,
      this.notSavedChanges,
      this.icon,
      this.labelText,
      required this.items,
      this.onChanged,
      this.validator,
      this.initialValue,
      this.nullState,
      required this.isEditing})
      : super(key: key);

  @override
  _DropdownFormFieldCountryState createState() =>
      _DropdownFormFieldCountryState();
}

class _DropdownFormFieldCountryState extends State<DropdownFormFieldCountry> {
  String? _value;
  bool isEmptys = true;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    if (widget.initialValue != null) {
      isEmptys = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.notSavedChanges ?? false) {
      _value = widget.initialValue;
      widget.notSavedChanges = null;
    }
    return FormField<String>(
      initialValue: widget.initialValue,
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              isEmpty: isEmptys,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: widget.isEditing
                      ? (state.hasError
                          ? const BorderSide(color: Colors.red)
                          : const BorderSide(color: Colors.black))
                      : BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: widget.isEditing
                    ? state.hasError
                        ? const TextStyle(color: Colors.red)
                        : TextStyle(color: Colors.grey.shade600)
                    : TextStyle(color: Colors.grey.shade500),
                prefixIcon: widget.icon ?? const Icon(Icons.map),
                filled: true,
                fillColor: widget.isEditing
                    ? Colors.transparent
                    : Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: widget.isEditing ? _value : widget.initialValue,
                    isDense: true,
                    onChanged: widget.isEditing
                        ? (String? newValue) {
                            setState(() {
                              isEmptys = false;
                              _value = newValue;
                              widget.onChanged?.call(newValue);
                              state.didChange(newValue);
                            });
                          }
                        : null,
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

class DropdownFormFieldCity extends StatefulWidget {
  final String? labelText;
  final List<String> items;
  final Function(String?)? onChanged;
  final String? Function(String?)? validator;
  String? initialValue;
  final bool isEditing;
  bool nullState;
  bool? notSavedChanges;

  DropdownFormFieldCity(
      {Key? key,
      this.labelText,
      required this.items,
      this.notSavedChanges,
      this.onChanged,
      this.validator,
      this.initialValue,
      required this.nullState,
      required this.isEditing})
      : super(key: key);

  @override
  _DropdownFormFieldCityState createState() => _DropdownFormFieldCityState();
}

class _DropdownFormFieldCityState extends State<DropdownFormFieldCity> {
  String? _value;
  bool isEmptys = true;

  @override
  void initState() {
    super.initState();
    if (widget.nullState == true) {
      _value = null;
      widget.initialValue = null;
    } else {
      _value = widget.initialValue;
    }
    if (widget.initialValue != null) {
      isEmptys = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.nullState == true) {
      devetools.log("message");
      _value = null;
      widget.initialValue = null;
      isEmptys = true;
    }
    if (widget.notSavedChanges ?? false) {
      devetools.log("medsdsdsdsssage");
      _value = widget.initialValue;
      widget.notSavedChanges = null;
    }
    return FormField<String>(
      initialValue: widget.initialValue,
      validator: widget.validator,
      builder: (FormFieldState<String> state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            InputDecorator(
              isEmpty: isEmptys,
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: widget.isEditing
                      ? (state.hasError
                          ? const BorderSide(color: Colors.red)
                          : const BorderSide(color: Colors.black))
                      : BorderSide(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(14.0),
                ),
                labelText: widget.labelText,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                floatingLabelStyle: widget.isEditing
                    ? state.hasError
                        ? const TextStyle(color: Colors.red)
                        : TextStyle(color: Colors.grey.shade600)
                    : TextStyle(color: Colors.grey.shade500),
                prefixIcon: const Icon(Icons.location_city),
                filled: true,
                fillColor: widget.isEditing
                    ? Colors.transparent
                    : Colors.grey.shade200,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    isExpanded: true,
                    value: widget.nullState
                        ? null
                        : (widget.isEditing ? _value : widget.initialValue),
                    isDense: true,
                    onChanged: widget.isEditing
                        ? (String? newValue) {
                            setState(() {
                              isEmptys = false;
                              widget.nullState = false;
                              _value = newValue;
                              widget.onChanged?.call(newValue);
                              state.didChange(newValue);
                            });
                          }
                        : null,
                    items: widget.items.map((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList()),
              ),
            ),
            if (state.hasError == true)
              Padding(
                padding: const EdgeInsets.only(
                  left: 20,
                  top: 15,
                ),
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
