// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devetools show log;
import 'package:intl/intl.dart';
import 'package:sfm/assets/storage_service.dart';
import 'package:sfm/views/single_chat.dart';
import '../main.dart';

final Storage storage = Storage();
String userEmail = "";
String userName = "";
String userCountry = "";
String userCity = "";
String storeName = "";
String storeAddress = "";
String filePath = "";
String fileName = "";
ImageProvider<Object>? networkFile = const NetworkImage("");

enum MenuAction {
  dashboard,
  recentChat,
  profile,
  privacyPolicy,
  sendFeedback,
  logout,
}

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
  final _date = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _clicked = false;
  bool showYourCity = true;
  String selectedCity = userCity;
  DateTime? _dateTime;
  bool _isLoading = true;

  late Future<String> _getDetails;

  @override
  void initState() {
    _getDetails = getPics();
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _foodItem.dispose();
    _cuisine.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: getDataStream(),
                builder: (context, snapshot) {
                  if (storeName != '') {
                    return Scaffold(
                      backgroundColor: Colors.white,
                      appBar: AppBar(
                        iconTheme: const IconThemeData(color: Colors.green),
                        backgroundColor: Colors.transparent,
                        elevation: 0,
                        automaticallyImplyLeading: false,
                        title: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
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
                                    fontSize: 16,
                                    fontFamily: "Roboto",
                                    color: Color(0xff05240E)),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                      endDrawer: Drawer(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              myHeaderDrawer(),
                              myDrawerList(),
                            ],
                          ),
                        ),
                      ),
                      body: Padding(
                        padding: const EdgeInsets.only(
                            top: 25, left: 22, right: 8, bottom: 8),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "SFM - $storeName Homepage",
                                    style: TextStyle(
                                        fontSize:
                                            MediaQuery.of(context).size.width *
                                                0.072,
                                        fontFamily: "Roboto",
                                        color: const Color(0xff05240E)),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                              // const TestPicture(),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),

                              StreamBuilder<Map<String, List<List<String>>>>(
                                  stream: _getRequestDetails(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data as Map;
                                      // devetools.log(data.toString());
                                      List<String> cities = [];
                                      data.forEach(
                                        (key, value) {
                                          cities.add(key);
                                        },
                                      );

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                            ? const Color(
                                                                0xff05240E)
                                                            : Colors.green,
                                                        selectedCity ==
                                                            cities[index], () {
                                                        setState(() {
                                                          selectedCity =
                                                              cities[index];
                                                          showYourCity = true;
                                                        });
                                                      })
                                                    : _cities(
                                                        cities[index],
                                                        "Roboto",
                                                        Colors.green,
                                                        selectedCity ==
                                                            cities[index], () {
                                                        setState(() {
                                                          selectedCity =
                                                              cities[index];
                                                          showYourCity = false;
                                                        });
                                                      });
                                              },
                                            ),
                                          ),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          showYourCity
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 14.0),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        data[userCity] != null
                                                            ? ListView.builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: data[
                                                                        userCity]
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return index ==
                                                                          0
                                                                      ? (data[userCity].length ==
                                                                              1
                                                                          ? Center(
                                                                              child: Column(
                                                                                children: const [
                                                                                  Text(
                                                                                    "No food requests in your area.",
                                                                                    style: TextStyle(
                                                                                      fontSize: 14,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      color: Colors.grey,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    height: 10,
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            )
                                                                          : const SizedBox())
                                                                      : (_requestIltem(
                                                                          context,
                                                                          data[userCity][index]
                                                                              [
                                                                              2],
                                                                          data[userCity][index]
                                                                              [
                                                                              3],
                                                                          data[userCity][index]
                                                                              [
                                                                              1],
                                                                          data[userCity][index]
                                                                              [
                                                                              4],
                                                                          data[userCity][index]
                                                                              [
                                                                              0],
                                                                        ));
                                                                })
                                                            : const SizedBox(),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 14.0),
                                                  child: SingleChildScrollView(
                                                    child: Column(
                                                      children: [
                                                        data[selectedCity] !=
                                                                null
                                                            ? ListView.builder(
                                                                physics:
                                                                    const NeverScrollableScrollPhysics(),
                                                                shrinkWrap:
                                                                    true,
                                                                itemCount: data[
                                                                        selectedCity]
                                                                    .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return index ==
                                                                          0
                                                                      ? const SizedBox()
                                                                      : (_requestIltem(
                                                                          context,
                                                                          data[selectedCity][index]
                                                                              [
                                                                              2],
                                                                          data[selectedCity][index]
                                                                              [
                                                                              3],
                                                                          data[selectedCity][index]
                                                                              [
                                                                              1],
                                                                          data[selectedCity][index]
                                                                              [
                                                                              4],
                                                                          data[selectedCity][index]
                                                                              [
                                                                              0],
                                                                        ));
                                                                })
                                                            : const SizedBox()
                                                      ],
                                                    ),
                                                  ),
                                                )
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        children: [
                                          _cities(
                                              userCity,
                                              "RobotoBold",
                                              const Color(0xff05240E),
                                              true,
                                              () {}),
                                          SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.025,
                                          ),
                                          _isLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : const Text(
                                                  "No Request Data",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    }
                                  }),

                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.005,
                              ),
                              Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "My Listing",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                fontFamily: "Roboto",
                                                color: const Color(0xff05240E)),
                                          ),
                                          // PopupMenuButton<MenuRequest>(
                                          //     icon: const Icon(
                                          //       Icons.more_horiz,
                                          //       color: Colors.green,
                                          //     ),
                                          //     // color: const Color(0xFFDBE8D8),
                                          //     onSelected: (value) async {
                                          //       switch (value) {
                                          //         case MenuRequest.add:
                                          //           _showDialog();
                                          //           break;
                                          //       }
                                          //     },
                                          //     itemBuilder: ((context) {
                                          //       return const [
                                          //         PopupMenuItem<MenuRequest>(
                                          //           value: MenuRequest.add,
                                          //           child: Text(
                                          //             "Add Food Listing",
                                          //             style: TextStyle(
                                          //                 color: Color(0xFF05240E)),
                                          //           ),
                                          //         ),
                                          //       ];
                                          //     }))
                                          IconButton(
                                              onPressed: _showDialog,
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.green,
                                              ))
                                        ],
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.014,
                              ),
                              StreamBuilder<List<List<String>>>(
                                  stream: _getListingDetails(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      List<List<String>> data = snapshot.data!;
                                      if (data.length > 1) {
                                        int numberOfListing = data.length - 1;
                                        return SizedBox(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.39,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                shrinkWrap: true,
                                                itemCount: numberOfListing,
                                                itemBuilder: ((context, index) {
                                                  return _foodListingItem(
                                                      context,
                                                      data[index + 1][0],
                                                      data[index + 1][1],
                                                      data[index + 1][2]);
                                                })));
                                      } else {
                                        return Center(
                                          child: Column(
                                            children: [
                                              SizedBox(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.014,
                                              ),
                                              const Text(
                                                "No food listing made. Make some listings",
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                    } else {
                                      return Center(
                                        child: _isLoading
                                            ? const CircularProgressIndicator()
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.014,
                                                  ),
                                                  const Text(
                                                    "No food listing made. Make some listings",
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                ],
                                              ),
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Scaffold();
                  }
                });
          } else {
            return const Scaffold();
          }
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
              child: SingleChildScrollView(
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
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
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
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
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
                          borderSide:
                              BorderSide(color: Colors.green, width: 2.0),
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
                    Material(
                      child: GestureDetector(
                        onTap: _showDataPicker,
                        child: AbsorbPointer(
                          child: TextFormField(
                            readOnly: true,
                            controller: _date,
                            textInputAction: TextInputAction.next,
                            decoration: const InputDecoration(
                              labelText: "Best Before",
                              floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                                horizontal: 20.0,
                                vertical: 15.0,
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter the best before date";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _clicked = false;
                });
                _foodItem.text = "";
                _cuisine.text = "";
                _numberOfPeople.text = "";
                _date.text = "";
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
                final beforeDate = _date.text;
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
                    final String date = getFormattedDate();

                    Map<String, String> orderData = {
                      'Full Name': userName.trim(),
                      'Store Name': storeName.trim(),
                      'Best Before': beforeDate.trim(),
                      'Food Item': foodItem.trim(),
                      'Cuisine': cuisine.trim(),
                      'Number of people': numberPeople.trim(),
                      'Area': storeAddress.trim(),
                    };
                    database
                        .ref()
                        .child("Orders")
                        .child(userCountry)
                        .child(userCity)
                        .child(user!.uid)
                        .child(date)
                        .set(orderData);
                    _foodItem.text = "";
                    _cuisine.text = "";
                    _numberOfPeople.text = "";
                    _date.text = "";
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

  Widget myHeaderDrawer() {
    return Container(
      color: Colors.green,
      width: double.infinity,
      height: 200,
      padding: const EdgeInsets.only(top: 20),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const SizedBox(
          height: 14,
        ),
        CircleAvatar(
          backgroundColor: Colors.grey[300],
          radius: 42,
          foregroundImage: filePath == ""
              ? const AssetImage("assets/images/user2.png")
              : networkFile,
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          userName,
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
        Text(
          userEmail,
          style: TextStyle(color: Colors.grey.shade200, fontSize: 12),
        ),
      ]),
    );
  }

  Widget myDrawerList() {
    return Container(
      padding: const EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        children: [
          menuItem("Dashboard", Icons.dashboard_outlined, () {
            Navigator.of(context).pop();
          }),
          menuItem("Recent Chats", Icons.chat_outlined, () {}),
          menuItem("Notifications", Icons.notifications_outlined, () {}),
          const Divider(
            color: Colors.black,
          ),
          menuItem("Privacy Policy", Icons.dashboard_outlined, () {}),
          menuItem("Send Feedback", Icons.dashboard_outlined, () {}),
          const Divider(
            color: Colors.black,
          ),
          menuItem("Profile", Icons.person_outlined, () async {
            Navigator.of(context).pop();

            await Navigator.of(context).pushNamedAndRemoveUntil(
              '/profiledonator/',
              (route) => true,
            );
          }),
          menuItem("Logout", Icons.dashboard_outlined, () async {
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout) {
              userCountry = "";
              userCity = "";
              storeName = "";
              storeAddress = "";
              userName = "";
              userEmail = "";

              await FirebaseAuth.instance.signOut();
              await FirebaseAuth.instance.signOut(); // clear cached data

              await Navigator.of(context).pushNamedAndRemoveUntil(
                '/logindonator/',
                (route) => false,
              );
              Navigator.of(context).pop();
            }
          }),
        ],
      ),
    );
  }

  Widget menuItem(String title, IconData icon, VoidCallback onTap) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                icon,
                size: 20,
                color: Colors.black,
              )),
              Expanded(
                  flex: 3,
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void _showDataPicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime(2025))
        .then((value) {
      setState(() {
        _dateTime = value!;
      });
      if (_dateTime != null) {
        final date = _dateTime!.day;
        final month = _dateTime!.month;
        final year = _dateTime!.year;
        if (month < 10) {
          _date.text = "$date-0$month-$year";
        } else {
          _date.text = "$date-$month-$year";
        }
      }
    });
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
              String fullName = requestData["Full Name"];
              String area = requestData["Area"];
              String cuisine = requestData["Cuisine"];
              String foodItem = requestData["Food Item"];
              String numberOfPeople = requestData["Number of people"];
              String lineOne = "$foodItem - $cuisine";
              String lineTwo = "$numberOfPeople people, $area";
              reqData = [userID, orderTime, lineOne, lineTwo, fullName];
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
      final key = event.snapshot.key;
      myMap.remove(key);
      List<List<String>> cityData = [[]];
      data.forEach((key, value) {
        List<String> reqData = [];
        final userID = key;
        final userOrder = value as Map;

        userOrder.forEach((key, value) {
          final orderTime = key;

          final requestData = value as Map;
          String fullName = requestData["Full Name"];
          String area = requestData["Area"];
          String cuisine = requestData["Cuisine"];
          String foodItem = requestData["Food Item"];
          String numberOfPeople = requestData["Number of people"];
          String lineOne = "$foodItem - $cuisine";
          String lineTwo = "$numberOfPeople people, $area";
          reqData = [userID, orderTime, lineOne, lineTwo, fullName];
          if (reqData.isNotEmpty) {
            cityData.add(reqData);
          }
        });
      });
      myMap[key!] = cityData;
      List<List<String>> userCityValues = myMap.remove(userCity) ?? [[]];
      myMap = {userCity: userCityValues, ...myMap};

      controller.add(myMap);
    });
    ref.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map;
      final key = event.snapshot.key;
      myMap.remove(key);
      List<List<String>> cityData = [[]];
      data.forEach((key, value) {
        List<String> reqData = [];
        final userID = key;
        final userOrder = value as Map;

        userOrder.forEach((key, value) {
          final orderTime = key;

          final requestData = value as Map;
          String fullName = requestData["Full Name"];
          String area = requestData["Area"];
          String cuisine = requestData["Cuisine"];
          String foodItem = requestData["Food Item"];
          String numberOfPeople = requestData["Number of people"];
          String lineOne = "$foodItem - $cuisine";
          String lineTwo = "$numberOfPeople people, $area";
          reqData = [userID, orderTime, lineOne, lineTwo, fullName];
          if (reqData.isNotEmpty) {
            cityData.add(reqData);
          }
        });
      });
      myMap[key!] = cityData;
      List<List<String>> userCityValues = myMap.remove(userCity) ?? [[]];
      myMap = {userCity: userCityValues, ...myMap};

      controller.add(myMap);
    });
    ref.onChildRemoved.listen((event) {
      final key = event.snapshot.key;
      myMap.remove(key);
      List<List<String>> userCityValues = myMap.remove(userCity) ?? [[]];
      myMap = {userCity: userCityValues, ...myMap};
      controller.add(myMap);
    });

    return controller.stream;
  }

  Stream<List<List<String>>> _getListingDetails() {
    User? user = FirebaseAuth.instance.currentUser;
    final userUID = user?.uid ?? "";
    DatabaseReference ref =
        FirebaseDatabase.instance.ref("Orders/$userCountry/$userCity/$userUID");
    StreamController<List<List<String>>> controller =
        StreamController.broadcast();
    List<List<String>> mainData = [
      [""]
    ];

    ref.once().then((event) {
      if (event.snapshot.value != null) {
        final data = event.snapshot.value as Map;

        data.forEach((key, value) {
          String lineOne;
          String lineTwo;
          String cuisine;
          String foodItem;
          String numberOfPeople;

          List<String> secondData;

          final data2 = value as Map;
          // String beforeDate = data2["Best Before"];
          cuisine = data2["Cuisine"];
          foodItem = data2["Food Item"];
          numberOfPeople = data2["Number of people"];
          lineOne = "$foodItem - $cuisine";
          // lineTwo = "$numberOfPeople people, Expiry: $beforeDate";
          lineTwo = "$numberOfPeople people";

          secondData = [key, lineOne, lineTwo];
          mainData.add(secondData);
        });

        controller.add(mainData);
      }
    });

    ref.onChildChanged.listen((event) {
      final data = event.snapshot.value as Map;

      String lineOne;
      String lineTwo;
      String cuisine;
      String foodItem;
      String numberOfPeople;
      List<String> secondData;
      // String beforeDate = data["Best Before"];

      cuisine = data["Cuisine"];
      foodItem = data["Food Item"];
      numberOfPeople = data["Number of people"];
      lineOne = "$foodItem - $cuisine";
      // lineTwo = "$numberOfPeople people, Expiry: $beforeDate";
      lineTwo = "$numberOfPeople people";

      secondData = [event.snapshot.key ?? "", lineOne, lineTwo];

      int index = mainData.indexWhere((data) => data[0] == event.snapshot.key);
      if (index != -1) {
        mainData[index] = secondData;
      }

      controller.add(mainData);
    });

    ref.onChildRemoved.listen((event) {
      int index = mainData.indexWhere((data) => data[0] == event.snapshot.key);
      if (index != -1) {
        mainData.removeAt(index);
      }

      controller.add(mainData);
    });

    return controller.stream;
  }

  Widget _foodListingItem(BuildContext context, String orderNumber,
      String lineOne, String lineTwo) {
    return Row(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.56,
          height: MediaQuery.of(context).size.height * 0.4,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.green)),
                        onPressed: (() async {
                          User? user = FirebaseAuth.instance.currentUser;
                          final foodItemData = TextEditingController();
                          final cuisineData = TextEditingController();
                          final numberOfPeopleData = TextEditingController();
                          final beforeDateData = TextEditingController();
                          final formKey = GlobalKey<FormState>();
                          bool clicked = false;

                          DatabaseReference ref = FirebaseDatabase.instance
                              .ref()
                              .child("Orders")
                              .child(userCountry)
                              .child(userCity)
                              .child(user!.uid)
                              .child(orderNumber);

                          DatabaseEvent event = await ref.once();
                          final requestData = event.snapshot.value as Map;
                          beforeDateData.text = requestData["Best Before"];
                          cuisineData.text = requestData["Cuisine"];
                          foodItemData.text = requestData["Food Item"];
                          numberOfPeopleData.text =
                              requestData["Number of people"];
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Update Details'),
                                content: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.72,
                                  child: Form(
                                    key: formKey,
                                    autovalidateMode: clicked
                                        ? AutovalidateMode.onUserInteraction
                                        : AutovalidateMode.disabled,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: foodItemData,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            labelText: "Food Item",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 15.0),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter the food item";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        TextFormField(
                                          controller: cuisineData,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            labelText: "Cuisine",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 15.0),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter the cuisine";
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        TextFormField(
                                          controller: numberOfPeopleData,
                                          textInputAction: TextInputAction.next,
                                          keyboardType: TextInputType.text,
                                          decoration: const InputDecoration(
                                            labelText: "Number of people",
                                            floatingLabelBehavior:
                                                FloatingLabelBehavior.auto,
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
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 15.0),
                                          ),
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return "Please enter the number of people";
                                            }
                                            final pattern =
                                                RegExp(r'^(\d+|\d+-\d+)$');
                                            if (!pattern.hasMatch(value)) {
                                              return "Invalid! Enter a number or range (e.g. 2 or 2-4)";
                                            }
                                            final parts = value.split('-');
                                            if (parts.length > 1) {
                                              final start =
                                                  int.tryParse(parts[0]);
                                              final end =
                                                  int.tryParse(parts[1]);
                                              if (start == null ||
                                                  end == null ||
                                                  start >= end) {
                                                return "Invalid! Enter a valid range (e.g. 2-4)";
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 12),
                                        Material(
                                          child: GestureDetector(
                                            onTap: _showDataPicker,
                                            child: AbsorbPointer(
                                              child: TextFormField(
                                                readOnly: true,
                                                controller: beforeDateData,
                                                textInputAction:
                                                    TextInputAction.next,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Best Before",
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .auto,
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14.0)),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                14.0)),
                                                    borderSide: BorderSide(
                                                        color: Colors.green,
                                                        width: 2.0),
                                                  ),
                                                  contentPadding:
                                                      EdgeInsets.symmetric(
                                                    horizontal: 20.0,
                                                    vertical: 15.0,
                                                  ),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter the best before date";
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: (() async {
                                        User? user =
                                            FirebaseAuth.instance.currentUser;
                                        final userid = user!.uid;

                                        bool cancel =
                                            await showCancelConfirmation(
                                                context);
                                        if (cancel) {
                                          DatabaseReference ref =
                                              FirebaseDatabase.instance.ref(
                                                  "Orders/$userCountry/$userCity/$userid/$orderNumber");

                                          await ref.remove();
                                        }
                                        Navigator.pop(context);
                                      }),
                                      child: const Text("Cancel Order")),
                                  ElevatedButton(
                                    onPressed: () {
                                      foodItemData.text = "";
                                      cuisineData.text = "";
                                      numberOfPeopleData.text = "";
                                      beforeDateData.text = "";
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      clicked = true;
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();
                                      final foodItem = foodItemData.text;
                                      final cuisine = cuisineData.text;
                                      final numberPeople =
                                          numberOfPeopleData.text;
                                      final beforeDate = beforeDateData.text;
                                      if (formKey.currentState!.validate()) {
                                        showDialog(
                                            barrierDismissible: false,
                                            context: context,
                                            builder: (_) {
                                              return Dialog(
                                                // The background color
                                                backgroundColor: Colors.white,
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            14.0),
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
                                          User? user =
                                              FirebaseAuth.instance.currentUser;
                                          FirebaseDatabase database =
                                              FirebaseDatabase.instance;

                                          Map<String, String> requestData = {
                                            'Food Item': foodItem.trim(),
                                            'Cuisine': cuisine.trim(),
                                            'Number of people':
                                                numberPeople.trim(),
                                            'Best Before': beforeDate.trim(),
                                          };
                                          database
                                              .ref()
                                              .child("Orders")
                                              .child(userCountry)
                                              .child(userCity)
                                              .child(user!.uid)
                                              .child(orderNumber)
                                              .update(requestData);
                                          foodItemData.text = "";
                                          cuisineData.text = "";
                                          numberOfPeopleData.text = "";
                                          beforeDateData.text = "";
                                          Navigator.of(context).pop();
                                        } on FirebaseAuthException catch (e) {
                                          if (e.code == 'user-not-found') {
                                            Navigator.of(context).pop();

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                                    content: Text(
                                                        "User not found")));
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
                        }),
                        child: const Text(
                          "Edit",
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        )),
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
          title: const Text("Remove Listing"),
          content: const Text("Are you sure you want to remove this listing?"),
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

Widget _requestIltem(BuildContext context, String textOne, String textTwo,
    String orderNumber, String fullName, String userID) {
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
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Chat(
                                        otherUID: userID,
                                        fullName: fullName,
                                        orderNumber: orderNumber,
                                      )));
                        }),
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
  final formatter = DateFormat('dd-MM-yyyy HH:mm:ss:SSS');
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
    storeName = snapshot["Store Name"];
    storeAddress = snapshot["Address Line"];
    userName = snapshot["Full Name"];
    userEmail = snapshot["Email"];
  });
}

Future<String> getPics() async {
  final user = FirebaseAuth.instance.currentUser;
  final String userID = user!.uid;
  try {
    filePath = await storage.downloadURL("$userID/userProfile.jpg");
    networkFile = NetworkImage(filePath);
    // ignore: empty_catches
  } catch (error) {}
  return "";
}
