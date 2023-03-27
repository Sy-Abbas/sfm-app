// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devetools show log;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sfm/assets/storage_service.dart';

import '../main.dart';

final Storage storage = Storage();
String userCountry = "";
String userCity = "";

enum MenuAction { logout, profile }

enum MenuRequest { add }

class HomeDonators extends StatefulWidget {
  const HomeDonators({super.key});

  @override
  State<HomeDonators> createState() => _HomeDonatorsState();
}

class _HomeDonatorsState extends State<HomeDonators> {
  final _foodItem = TextEditingController();
  final _cuisine = TextEditingController();
  final _numberOfPeople = TextEditingController();
  final _area = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _clicked = false;
  bool showYourCity = true;
  bool reset = false;
  String selectedCity = userCity;
  List<List<String>> cData = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _foodItem.dispose();
    _cuisine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: getDataStream(),
        builder: (context, snapshot) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  title: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                          image: AssetImage("assets/logo.png"),
                          fit: BoxFit.fitWidth,
                        )),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text(
                        "Surplus Food Management",
                        style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Roboto",
                            color: Color(0xff05240E)),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                  actions: [
                    PopupMenuButton<MenuAction>(
                        icon: const Icon(
                          Icons.menu,
                          color: Color(0xFF05240E),
                        ),
                        // color: const Color(0xFFDBE8D8),
                        onSelected: (value) async {
                          switch (value) {
                            case MenuAction.logout:
                              final shouldLogout =
                                  await showLogOutDialog(context);
                              if (shouldLogout) {
                                await FirebaseAuth.instance.signOut();
                                await FirebaseAuth.instance
                                    .signOut(); // clear cached data
                                await Navigator.of(context)
                                    .pushNamedAndRemoveUntil(
                                  '/logindonator/',
                                  (route) => false,
                                );
                              }
                              break;
                            case MenuAction.profile:
                              await Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                '/profiledonator/',
                                (route) => true,
                              );
                              break;
                          }
                        },
                        itemBuilder: ((context) {
                          return const [
                            PopupMenuItem<MenuAction>(
                              value: MenuAction.profile,
                              child: Text(
                                "Profile",
                                style: TextStyle(color: Color(0xFF05240E)),
                              ),
                            ),
                            PopupMenuItem<MenuAction>(
                              value: MenuAction.logout,
                              child: Text(
                                "Log Out",
                                style: TextStyle(color: Color(0xFF05240E)),
                              ),
                            )
                          ];
                        }))
                  ],
                ),
                body: Padding(
                  padding: const EdgeInsets.only(top: 25, left: 14),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              "SFM - Donator Homepage",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontFamily: "Roboto",
                                  color: Color(0xff05240E)),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        // const TestPicture(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.040,
                                width: MediaQuery.of(context).size.width * 0.72,
                                color: const Color(0xFFDBE8D8),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "Search",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Roboto",
                                        color: Color(0xff05240E)),
                                  ),
                                ),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.040,
                                width: MediaQuery.of(context).size.width * 0.1,
                                color: Colors.green,
                                child: IconButton(
                                  onPressed: (() {}),
                                  icon: const Icon(Icons.search),
                                  color: const Color(0xFFDBE8D8),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        ),

                        StreamBuilder<Map<String, List<List<String>>>>(
                            stream: _getRequestDetails(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data as Map;

                                List<String> cities = [];
                                data.forEach(
                                  (key, value) {
                                    cities.add(key);
                                  },
                                );
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 25,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap: true,
                                        itemCount: cities.length,
                                        itemBuilder: (context, index) {
                                          return index == 0
                                              ? _cities(
                                                  cities[0],
                                                  showYourCity
                                                      ? "RobotoBold"
                                                      : "Roboto",
                                                  showYourCity
                                                      ? const Color(0xff05240E)
                                                      : Colors.green,
                                                  selectedCity == cities[index],
                                                  () async {
                                                  setState(() {
                                                    reset = true;
                                                    selectedCity =
                                                        cities[index];
                                                    showYourCity = false;
                                                  });
                                                  await sendShowData(
                                                      data[userCity]);
                                                })
                                              : _cities(
                                                  cities[index],
                                                  "Roboto",
                                                  Colors.green,
                                                  selectedCity == cities[index],
                                                  () async {
                                                  setState(() {
                                                    reset = true;
                                                    selectedCity =
                                                        cities[index];
                                                    showYourCity = false;
                                                  });
                                                  await sendShowData(
                                                      data[cities[index]]);
                                                });
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.025,
                                    ),
                                    showYourCity
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                right: 14.0),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  ListView.builder(
                                                      physics:
                                                          const NeverScrollableScrollPhysics(),
                                                      shrinkWrap: true,
                                                      itemCount:
                                                          data[userCity].length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        return index == 0
                                                            ? const SizedBox()
                                                            : (_requestIltem(
                                                                context,
                                                                data[userCity]
                                                                    [index][2],
                                                                data[userCity]
                                                                    [index][3],
                                                                data[userCity]
                                                                    [index][1],
                                                              ));
                                                      })
                                                ],
                                              ),
                                            ),
                                          )
                                        : const SizedBox()
                                  ],
                                );
                              } else {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                            }),

                        showYourCity
                            ? const SizedBox()
                            : reset
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : SingleChildScrollView(
                                    child: StreamBuilder<List<List<String>>>(
                                        stream: _getShowData(),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            List<List<String>> data =
                                                snapshot.data!;
                                            devetools.log(data.toString());
                                            return Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 14.0),
                                                  child: Column(
                                                    children: [
                                                      ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              data.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return index == 0
                                                                ? const SizedBox()
                                                                : (_requestIltem(
                                                                    context,
                                                                    data[index]
                                                                        [2],
                                                                    data[index]
                                                                        [3],
                                                                    data[index]
                                                                        [1],
                                                                  ));
                                                          })
                                                    ],
                                                  ),
                                                )
                                              ],
                                            );
                                          } else {
                                            return const SizedBox();
                                          }
                                        }),
                                  ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  void _showDialog() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Details'),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.72,
            child: Form(
              key: _formKey,
              autovalidateMode: _clicked
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _foodItem,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Food Item",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the food item";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _cuisine,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Cuisine",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the cuisine";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _numberOfPeople,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Number of people",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the number of people";
                      }
                      final pattern = RegExp(r'^(\d+|\d+-\d+)$');
                      if (!pattern.hasMatch(value)) {
                        return "Invalid! Enter a number or range (e.g. 2 or 2-4)";
                      }
                      final parts = value.split('-');
                      if (parts.length > 1) {
                        final start = int.tryParse(parts[0]);
                        final end = int.tryParse(parts[1]);
                        if (start == null || end == null || start >= end) {
                          return "Invalid! Enter a valid range (e.g. 2-4)";
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _area,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      labelText: "Area",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(14.0)),
                        borderSide: BorderSide(color: Colors.green, width: 2.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 15.0),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter the area";
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                _foodItem.text = "";
                _cuisine.text = "";
                _numberOfPeople.text = "";
                _area.text = "";
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _clicked = true;
                });
                FocusManager.instance.primaryFocus?.unfocus();
                final foodItem = _foodItem.text;
                final cuisine = _cuisine.text;
                final numberPeople = _numberOfPeople.text;
                final area = _area.text;
                if (_formKey.currentState!.validate()) {
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
                  try {
                    User? user = FirebaseAuth.instance.currentUser;

                    FirebaseDatabase database = FirebaseDatabase.instance;

                    Map<String, String> requestData = {
                      'Food Item': foodItem,
                      'Cuisine': cuisine,
                      'Number of people': numberPeople,
                      'Area': area,
                    };
                    final String date = getFormattedDate();
                    database
                        .ref()
                        .child("Requests")
                        .child(userCountry)
                        .child(userCity)
                        .child(user!.uid)
                        .child(date)
                        .set(requestData);
                    _foodItem.text = "";
                    _cuisine.text = "";
                    _numberOfPeople.text = "";
                    _area.text = "";
                    Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      Navigator.of(context).pop();

                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User not found")));
                    }
                  } finally {
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Widget _cities(
    String city,
    String fontFamily,
    Color color,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: onTap,
              child: Text(
                city,
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: isSelected ? "RobotoBold" : fontFamily,
                  color: isSelected ? const Color(0xff05240E) : color,
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.040,
            ),
          ],
        ),
      ],
    );
  }

  Future<String> sendShowData(List<List<String>>? data) async {
    if (data != null) {
      FirebaseDatabase database = FirebaseDatabase.instance;
      await database.ref().child("Show").remove();

      data.removeAt(0);
      for (List<String> a in data) {
        await database.ref().child("Show").push().set(a);
      }
      setState(() {
        reset = false;
      });
    }

    return "";
  }

  Future<String> sendShowDataOnce(List<List<String>>? data) async {
    if (data != null) {
      FirebaseDatabase database = FirebaseDatabase.instance;
      await database.ref().child("Show").remove();

      data.removeAt(0);
      for (List<String> a in data) {
        await database.ref().child("Show").push().set(a);
      }
    }

    return "";
  }

  Stream<Map<String, List<List<String>>>> _getRequestDetails() {
    Map<String, List<List<String>>> myMap = {};

    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Requests/$userCountry");

    StreamController<Map<String, List<List<String>>>> controller =
        StreamController.broadcast();

    ref.once().then((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;

        data.forEach((key, value) {
          List<List<String>> cityData = [[]];
          final cityKey = key;
          final users = value as Map;

          users.forEach((key, value) {
            List<String> reqData = [];
            final userID = key;
            final userOrder = value as Map;

            userOrder.forEach((key, value) {
              final orderTime = key;

              final requestData = value as Map;
              String area = requestData["Area"];
              String cuisine = requestData["Cuisine"];
              String foodItem = requestData["Food Item"];
              String numberOfPeople = requestData["Number of people"];
              String lineOne = "$foodItem - $cuisine";
              String lineTwo = "$numberOfPeople people, $area";
              reqData = [userID, orderTime, lineOne, lineTwo];
              if (reqData.isNotEmpty) {
                cityData.add(reqData);
              }
            });
          });

          myMap[cityKey] = cityData;
        });

        List<List<String>> userCityValues = myMap.remove(userCity) ?? [[]];
        myMap = {userCity: userCityValues, ...myMap};

        controller.add(myMap);
      }
    });
    ref.onChildChanged.listen((event) {
      final data = event.snapshot.value as Map;
      final key = event.snapshot.key as String;
      myMap.remove(key);
      List<List<String>> cityData = [[]];
      data.forEach((key, value) {
        List<String> reqData = [];
        final userID = key;
        final userOrder = value as Map;

        userOrder.forEach((key, value) {
          final orderTime = key;

          final requestData = value as Map;
          String area = requestData["Area"];
          String cuisine = requestData["Cuisine"];
          String foodItem = requestData["Food Item"];
          String numberOfPeople = requestData["Number of people"];
          String lineOne = "$foodItem - $cuisine";
          String lineTwo = "$numberOfPeople people, $area";
          reqData = [userID, orderTime, lineOne, lineTwo];
          if (reqData.isNotEmpty) {
            cityData.add(reqData);
          }
        });
      });
      myMap[key] = cityData;
      List<List<String>> userCityValues = myMap.remove(userCity) ?? [[]];
      myMap = {userCity: userCityValues, ...myMap};

      controller.add(myMap);
    });
    ref.onChildRemoved.listen((event) {
      final key = event.snapshot.key as String;
      myMap.remove(key);
      List<List<String>> userCityValues = myMap.remove(userCity) ?? [[]];
      myMap = {userCity: userCityValues, ...myMap};
      controller.add(myMap);
    });

    return controller.stream;
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Log Out"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(false);
              }),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(true);
              }),
              child: const Text("Log Out"),
            )
          ],
        );
      })).then((value) => value ?? false);
}

Future<bool> showCancelConfirmation(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Remove Request"),
          content: const Text("Are you sure you want to remove this request?"),
          actions: [
            TextButton(
              onPressed: (() {
                Navigator.of(context).pop(false);
              }),
              child: const Text("Cancel"),
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

Widget _foodListingItem(BuildContext context, String lineOne, String lineTwo) {
  return Row(
    children: [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.56,
        height: MediaQuery.of(context).size.height * 0.4,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.56,
              height: MediaQuery.of(context).size.height * 0.32,
              color: const Color(0xFFDBE8D8),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6 - 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        lineOne,
                        style: const TextStyle(
                            fontSize: 14.5,
                            fontFamily: "Roboto",
                            color: Colors.green),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Text(
                        lineTwo,
                        style: const TextStyle(
                            fontSize: 12,
                            fontFamily: "Roboto",
                            color: Color(0xff05240E)),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  ButtonTheme(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: (() {}),
                        child: const Text(
                          "Chat",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                  ),
                ],
              )
            ],
          )
        ]),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.05,
      ),
    ],
  );
}

Widget _requestIltem(
    BuildContext context, String textOne, String textTwo, String dateTime) {
  return Column(
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 72,
          color: const Color(0xFFDBE8D8),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      textOne,
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: "Roboto",
                        color: Color(0xff05240E),
                      ),
                    ),
                    Text(
                      textTwo,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Roboto",
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: (() {}),
                        child: const Text(
                          "Chat",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
      const SizedBox(
        height: 10,
      )
    ],
  );
}

String getFormattedDate() {
  final now = DateTime.now();
  final formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
  return formatter.format(now);
}

Stream<void> getDataStream() async* {
  User? user = FirebaseAuth.instance.currentUser;

  String docID = await findDocID(user?.uid ?? "None", "Donators");
  yield* FirebaseFirestore.instance
      .collection("Donators")
      .doc(docID)
      .snapshots()
      .map((snapshot) {
    userCountry = snapshot["Country"];
    userCity = snapshot["City"];
  });
}

Stream<List<List<String>>> _getShowData() {
  DatabaseReference ref = FirebaseDatabase.instance.ref("Show");
  StreamController<List<List<String>>> controller =
      StreamController.broadcast();
  List<List<String>> mainData = [
    [""]
  ];

  ref.once().then((event) {
    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map;

      data.forEach((key, value) {
        List<String> secondData = [value[0], value[1], value[2], value[3]];
        mainData.add(secondData);
      });

      controller.add(mainData);
    }
  });

  ref.onChildChanged.listen((event) {
    final changes = (event.snapshot.value as List<Object?>)
        .map((item) => item.toString())
        .toList();

    final uid = changes[0];
    int index = 0;
    for (int i = 0; i < mainData.length; i++) {
      final tempList = mainData[i];
      if (tempList.contains(uid)) {
        index = i;
      }
    }
    mainData.removeAt(index);
    mainData.add(changes);
    controller.add(mainData);
  });

  ref.onChildRemoved.listen((event) {});

  return controller.stream;
}
