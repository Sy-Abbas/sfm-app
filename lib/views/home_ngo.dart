// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:sfm/assets/storage_service.dart';
import 'package:sfm/views/feedback_page.dart';
import 'package:sfm/views/privacy_policy.dart';
import 'package:sfm/views/recent.chats.dart';
import 'package:sfm/views/single_chat.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import 'dart:developer' as develtools show log;

import 'notfications.dart';

final Storage storage = Storage();
String userEmail = "";
String userName = "";
String userCountry = "";
String userCity = "";
String ngoName = "";
String ngoAddress = "";
String filePath = "";
String fileName = "";
ImageProvider<Object>? networkFile = const NetworkImage("");

enum MenuAction { logout, profile }

enum MenuRequest { add }

class HomeNGO extends StatefulWidget {
  const HomeNGO({super.key});

  @override
  State<HomeNGO> createState() => _HomeNGOState();
}

class _HomeNGOState extends State<HomeNGO> {
  final _foodItem = TextEditingController();
  final _cuisine = TextEditingController();
  final _numberOfPeople = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _clicked = false;
  User? user = FirebaseAuth.instance.currentUser;
  bool showYourCity = true;
  String selectedData = userCity;
  bool _isLoading = true;
  late Future<String> _getDetails;
  Timer? _timer;
  FToast? fToast;

  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    _getDetails = getPics();
    super.initState();
    _timer = Timer(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _foodItem.dispose();
    _cuisine.dispose();
    _numberOfPeople.dispose();
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
    return FutureBuilder(
        future: _getDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: getDataStream(),
                builder: (context, snapshot) {
                  if (ngoName != '') {
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
                              // Text(
                              //   "Surplus Food Management",
                              //   style: TextStyle(
                              //       fontSize:
                              //           MediaQuery.of(context).size.width *
                              //               0.046,
                              //       fontFamily: "Roboto",
                              //       color: const Color(0xff05240E)),
                              //   textAlign: TextAlign.center,
                              // )
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
                                  Expanded(
                                    child: Text(
                                      "Surplus Food Available",
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.060,
                                          fontFamily: "Roboto",
                                          color: const Color(0xff05240E)),
                                      // textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
                                color: Colors.green,
                                height: 2,
                                width: MediaQuery.of(context).size.width * 0.50,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              StreamBuilder<Map<String, List<List<String>>>>(
                                  stream: _getListing(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      final data = snapshot.data as Map;

                                      Map<String, List<List<String>>>
                                          cuisineData = {};
                                      data.forEach((key, value) {
                                        final d = value as List<List<String>>;
                                        for (List<String> x in d) {
                                          if (x.length > 1) {
                                            if (cuisineData.containsKey(x[0])) {
                                              final cuisineList =
                                                  cuisineData[x[0]]
                                                      as List<List<String>>;
                                              cuisineList.add(x);
                                              cuisineData[x[0]] = cuisineList;
                                            } else {
                                              List<List<String>> newList = [[]];
                                              newList.add(x);
                                              cuisineData[x[0]] = newList;
                                            }
                                          }
                                        }
                                      });

                                      List<String> cuisine = ["Nearby"];
                                      cuisineData.forEach(
                                        (key, value) {
                                          cuisine.add(key);
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
                                              itemCount: cuisine.length,
                                              itemBuilder: (context, index) {
                                                return index == 0
                                                    ? _cities(
                                                        cuisine[0],
                                                        showYourCity
                                                            ? "RobotoBold"
                                                            : "Roboto",
                                                        showYourCity
                                                            ? const Color(
                                                                0xff05240E)
                                                            : Colors.green,
                                                        selectedData ==
                                                            cuisine[index], () {
                                                        setState(() {
                                                          selectedData =
                                                              cuisine[index];
                                                          showYourCity = true;
                                                        });
                                                      })
                                                    : _cities(
                                                        cuisine[index],
                                                        "Roboto",
                                                        Colors.green,
                                                        selectedData ==
                                                            cuisine[index], () {
                                                        setState(() {
                                                          selectedData =
                                                              cuisine[index];
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
                                                        data[userCity].isEmpty
                                                            ? Center(
                                                                child: Column(
                                                                  children: const [
                                                                    Text(
                                                                      "No food listings from donators near you.",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height:
                                                                          10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              )
                                                            : SizedBox(
                                                                height: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .height *
                                                                    0.39,
                                                                child: ListView
                                                                    .builder(
                                                                        scrollDirection:
                                                                            Axis
                                                                                .horizontal,
                                                                        shrinkWrap:
                                                                            true,
                                                                        itemCount:
                                                                            data[userCity]
                                                                                .length,
                                                                        itemBuilder:
                                                                            (context,
                                                                                index) {
                                                                          return (_foodListingItem(
                                                                            context,
                                                                            data[userCity][index][1],
                                                                            data[userCity][index][6],
                                                                            data[userCity][index][3],
                                                                            data[userCity][index][4],
                                                                            data[userCity][index][7],
                                                                            data[userCity][index][8],
                                                                            data[userCity][index][9],
                                                                            data[userCity][index][0],
                                                                            data[userCity][index][10],
                                                                            data[userCity][index][5],
                                                                            data[userCity][index][11],
                                                                            data[userCity][index][12],
                                                                            data[userCity][index][13],
                                                                            data[userCity][index][14],
                                                                          ));
                                                                        }),
                                                              )
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
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.39,
                                                          child: cuisineData[selectedData] !=
                                                                  null
                                                              ? ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .horizontal,
                                                                      shrinkWrap:
                                                                          true,
                                                                      itemCount:
                                                                          cuisineData[selectedData]!
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return index ==
                                                                                0
                                                                            ? const SizedBox()
                                                                            : cuisineData[selectedData] != null
                                                                                ? (_foodListingItem(
                                                                                    context,
                                                                                    cuisineData[selectedData]![index][1],
                                                                                    cuisineData[selectedData]![index][2],
                                                                                    cuisineData[selectedData]![index][3],
                                                                                    cuisineData[selectedData]![index][4],
                                                                                    cuisineData[selectedData]![index][7],
                                                                                    cuisineData[selectedData]![index][8],
                                                                                    cuisineData[selectedData]![index][9],
                                                                                    cuisineData[selectedData]![index][0],
                                                                                    cuisineData[selectedData]![index][10],
                                                                                    cuisineData[selectedData]![index][5],
                                                                                    cuisineData[selectedData]![index][11],
                                                                                    cuisineData[selectedData]![index][12],
                                                                                    cuisineData[selectedData]![index][13],
                                                                                    cuisineData[selectedData]![index][14],
                                                                                  ))
                                                                                : const SizedBox();
                                                                      })
                                                              : const SizedBox(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                        ],
                                      );
                                    } else {
                                      return Center(
                                        child: _isLoading
                                            ? SizedBox(
                                                height: 50,
                                                child: OverflowBox(
                                                  minHeight: 150,
                                                  maxHeight: 150,
                                                  child: Lottie.asset(
                                                    "assets/animation/loading-utensils.json",
                                                  ),
                                                ),
                                              )
                                            : Column(
                                                children: [
                                                  SizedBox(
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.025,
                                                  ),
                                                  const Text(
                                                    "No food listing from donators found",
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
                              Padding(
                                  padding: const EdgeInsets.only(right: 14.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "My Food Requests",
                                            style: TextStyle(
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.06,
                                                fontFamily: "Roboto",
                                                color: const Color(0xff05240E)),
                                          ),
                                          IconButton(
                                              onPressed: _showDialog,
                                              icon: const Icon(
                                                Icons.add,
                                                color: Colors.green,
                                              ))
                                        ],
                                      ),
                                      SingleChildScrollView(
                                        child: StreamBuilder<
                                                List<List<String>>>(
                                            stream: _getRequestDetails(),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasData) {
                                                List<List<String>> data =
                                                    snapshot.data!;
                                                data.sort((a, b) =>
                                                    int.parse(b[4]).compareTo(
                                                        int.parse(a[4])));
                                                data.sort((a, b) {
                                                  var dateA = DateTime.parse(
                                                      "${a[3].split("-")[2]}-${a[3].split("-")[1]}-${a[3].split("-")[0]}");
                                                  var dateB = DateTime.parse(
                                                      "${b[3].split("-")[2]}-${b[3].split("-")[1]}-${b[3].split("-")[0]}");
                                                  return dateB.compareTo(dateA);
                                                });
                                                if (data.isNotEmpty) {
                                                  int numberOfRequest =
                                                      data.length;
                                                  return Column(
                                                    children: [
                                                      ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount:
                                                              numberOfRequest,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return _requestIltem(
                                                              context,
                                                              data[index][1],
                                                              data[index][2],
                                                              data[index][0],
                                                            );
                                                          })
                                                    ],
                                                  );
                                                } else {
                                                  return Center(
                                                    child: Column(
                                                      children: [
                                                        SizedBox(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.025,
                                                        ),
                                                        const Text(
                                                          "No food request made. Make some requests",
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
                                              } else {
                                                return Center(
                                                  child: _isLoading
                                                      ? SizedBox(
                                                          height: 50,
                                                          child: OverflowBox(
                                                            minHeight: 150,
                                                            maxHeight: 150,
                                                            child: Lottie.asset(
                                                              "assets/animation/loading-utensils.json",
                                                            ),
                                                          ),
                                                        )
                                                      : Column(
                                                          children: [
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height *
                                                                  0.025,
                                                            ),
                                                            const Text(
                                                              "No food request made. Make some requests",
                                                              style: TextStyle(
                                                                fontSize: 14,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors.grey,
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
                                      )
                                    ],
                                  ))
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
                        labelText: "Servings Available",
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
                          return "Please enter the servings available";
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
                    FirebaseDatabase database = FirebaseDatabase.instance;

                    Map<String, String> requestData = {
                      'Full Name': userName.trim(),
                      'Food Item': foodItem
                          .trim()
                          .toLowerCase()
                          .split(" ")
                          .map((word) =>
                              "${word[0].toUpperCase()}${word.substring(1)}")
                          .join(" "),
                      'Cuisine': cuisine
                          .trim()
                          .toLowerCase()
                          .split(" ")
                          .map((word) =>
                              "${word[0].toUpperCase()}${word.substring(1)}")
                          .join(" "),
                      'Number of people': numberPeople.trim(),
                      'Area': ngoAddress.trim(),
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
                    Navigator.of(context).pop();
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      Navigator.of(context).pop();
                      showToast("User not found");
                    }
                  } finally {
                    Navigator.pop(context);
                    setState(() {
                      _clicked = false;
                    });
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
          menuItem("Recent Chats", Icons.chat_outlined, () async {
            Navigator.of(context).pop();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => RecentChats(
                          userType: "NGOs",
                        )));
          }),
          menuItem("Notifications", Icons.notifications_outlined, () {
            Navigator.of(context).pop();

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const NotificationsPage()));
          }),
          const Divider(
            color: Colors.black,
          ),
          menuItem("Send Feedback", Icons.feedback_outlined, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const FeedbackPage()));
          }),
          menuItem("Privacy Policy", Icons.privacy_tip_outlined, () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const PrivacyPolicy()));
          }),
          const Divider(
            color: Colors.black,
          ),
          menuItem("Profile", Icons.person_outlined, () async {
            Navigator.of(context).pop();

            await Navigator.of(context).pushNamedAndRemoveUntil(
              '/profilengo/',
              (route) => true,
            );
          }),
          menuItem("Logout", Icons.logout_outlined, () async {
            final shouldLogout = await showLogOutDialog(context);
            if (shouldLogout) {
              userCountry = "";
              userCity = "";
              ngoName = "";
              ngoAddress = "";
              userName = "";
              userEmail = "";

              await FirebaseAuth.instance.signOut();
              await FirebaseAuth.instance.signOut(); // clear cached data

              await Navigator.of(context).pushNamedAndRemoveUntil(
                '/loginngo/',
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

  Widget _cities(
    String data,
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
                data,
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

Widget _foodListingItem(
    BuildContext context,
    String lineOne,
    String lineTwo,
    String userID,
    String orderNumber,
    String fullName,
    String imagePath,
    String foodItem,
    String cuisine,
    String serving,
    String bestBefore,
    String storeName,
    String storeNumber,
    String area,
    String city) {
  return Row(
    children: [
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        InkWell(
          onTap: (() {
            String dateListed = orderNumber;
            final formattedListed = formatDate1(dateListed);
            bestBefore = formatDate(bestBefore);
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text(
                    "Listing Details",
                    style: TextStyle(fontSize: 20),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Food Item: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: foodItem,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Cuisine: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: cuisine,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Serving: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: serving,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Date Listed On: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: formattedListed,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Best Before: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: bestBefore,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: "Donator's Name: ",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: fullName,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Store Name: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: storeName,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Store Number: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: storeNumber,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Area: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: area,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 5),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
                          children: [
                            const TextSpan(
                              text: 'City: ',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: city,
                              style: const TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                );
              },
            );
          }),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.56,
                  height: MediaQuery.of(context).size.height * 0.32,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.56,
                  height: MediaQuery.of(context).size.height * 0.32,
                  color: Colors.black.withOpacity(0.2),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6 - 90,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 2,
                      ),
                      Flexible(
                        child: Text(
                          lineOne,
                          style: const TextStyle(
                              fontSize: 14.5,
                              fontFamily: "Roboto",
                              color: Colors.green),
                        ),
                      ),
                      const SizedBox(
                        height: 2,
                      ),
                      Flexible(
                        child: Text(
                          lineTwo,
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: "Roboto",
                              color: Color(0xff05240E)),
                        ),
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
                      onPressed: (() {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetPictures(
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
        )
      ]),
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
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            textOne,
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Roboto",
                              color: Color(0xff05240E),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () async {
                              User? user = FirebaseAuth.instance.currentUser;
                              final _foodItem = TextEditingController();
                              final _cuisine = TextEditingController();
                              final _numberOfPeople = TextEditingController();
                              final _formKey = GlobalKey<FormState>();
                              bool _clicked = false;

                              DatabaseReference ref = FirebaseDatabase.instance
                                  .ref()
                                  .child("Requests")
                                  .child(userCountry)
                                  .child(userCity)
                                  .child(user!.uid)
                                  .child(dateTime);

                              DatabaseEvent event = await ref.once();
                              final requestData = event.snapshot.value as Map;
                              _cuisine.text = requestData["Cuisine"];
                              _foodItem.text = requestData["Food Item"];
                              _numberOfPeople.text =
                                  requestData["Number of people"];
                              showDialog(
                                // barrierDismissible: false,
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Update Details'),
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.72,
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
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Food Item",
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
                                                controller: _cuisine,
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: "Cuisine",
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
                                                controller: _numberOfPeople,
                                                textInputAction:
                                                    TextInputAction.next,
                                                keyboardType:
                                                    TextInputType.text,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      "Servings Available",
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
                                                          vertical: 15.0),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Please enter the servings available";
                                                  }
                                                  final pattern = RegExp(
                                                      r'^(\d+|\d+-\d+)$');
                                                  if (!pattern
                                                      .hasMatch(value)) {
                                                    return "Invalid! Enter a number or range (e.g. 2 or 2-4)";
                                                  }
                                                  final parts =
                                                      value.split('-');
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
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _foodItem.text = "";
                                          _cuisine.text = "";
                                          _numberOfPeople.text = "";
                                          Navigator.pop(context);
                                        },
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _clicked = true;
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          final foodItem = _foodItem.text;
                                          final cuisine = _cuisine.text;
                                          final numberPeople =
                                              _numberOfPeople.text;
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
                                            try {
                                              User? user = FirebaseAuth
                                                  .instance.currentUser;
                                              FirebaseDatabase database =
                                                  FirebaseDatabase.instance;

                                              Map<String, String> requestData =
                                                  {
                                                'Food Item': foodItem
                                                    .trim()
                                                    .toLowerCase()
                                                    .split(" ")
                                                    .map((word) =>
                                                        "${word[0].toUpperCase()}${word.substring(1)}")
                                                    .join(" "),
                                                'Cuisine': cuisine
                                                    .trim()
                                                    .toLowerCase()
                                                    .split(" ")
                                                    .map((word) =>
                                                        "${word[0].toUpperCase()}${word.substring(1)}")
                                                    .join(" "),
                                                'Number of people':
                                                    numberPeople.trim(),
                                              };
                                              database
                                                  .ref()
                                                  .child("Requests")
                                                  .child(userCountry)
                                                  .child(userCity)
                                                  .child(user!.uid)
                                                  .child(dateTime)
                                                  .update(requestData);
                                              _foodItem.text = "";
                                              _cuisine.text = "";
                                              _numberOfPeople.text = "";
                                              Navigator.of(context).pop();
                                            } on FirebaseAuthException catch (e) {
                                              if (e.code == 'user-not-found') {
                                                Navigator.of(context).pop();
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
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Roboto",
                                color: Color(0xff05240E),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            textTwo,
                            style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Roboto",
                              color: Colors.green,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: GestureDetector(
                            onTap: () async {
                              User? user = FirebaseAuth.instance.currentUser;
                              final userid = user!.uid;

                              bool cancel =
                                  await showCancelConfirmation(context);
                              if (cancel) {
                                DatabaseReference ref =
                                    FirebaseDatabase.instance.ref(
                                        "Requests/$userCountry/$userCity/$userid/$dateTime");

                                await ref.remove();
                              }
                            },
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Roboto",
                                color: Colors.red.shade600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ]),
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

String formatDate(String input) {
  final parts = input.split('-');
  final day = int.parse(parts[0]);
  final monthNumber = int.parse(parts[1]);
  final year = int.parse(parts[2]);
  final monthName = _getMonthName(monthNumber);
  return '$day$monthName';
}

String _getMonthName(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return 'st January';
    case 2:
      return 'nd February';
    case 3:
      return 'rd March';
    case 4:
      return 'th April';
    case 5:
      return 'th May';
    case 6:
      return 'th June';
    case 7:
      return 'th July';
    case 8:
      return 'th August';
    case 9:
      return 'th September';
    case 10:
      return 'th October';
    case 11:
      return 'th November';
    case 12:
      return 'th December';
    default:
      return '';
  }
}

String formatDate1(String input) {
  final date = DateFormat("dd-MM-yyyy HH:mm:ss:SSS").parse(input);
  final day = date.day;
  final monthName = DateFormat("MMMM").format(date);
  return '$day${_getOrdinalSuffix(day)} $monthName';
}

String _getOrdinalSuffix(int day) {
  if (day >= 11 && day <= 13) {
    return "th";
  }
  switch (day % 10) {
    case 1:
      return "st";
    case 2:
      return "nd";
    case 3:
      return "rd";
    default:
      return "th";
  }
}

Stream<List<List<String>>> _getRequestDetails() {
  User? user = FirebaseAuth.instance.currentUser;
  final userUID = user?.uid ?? "";
  DatabaseReference ref =
      FirebaseDatabase.instance.ref("Requests/$userCountry/$userCity/$userUID");
  StreamController<List<List<String>>> controller =
      StreamController.broadcast();
  List<List<String>> mainData = [];

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
        cuisine = data2["Cuisine"];
        foodItem = data2["Food Item"];
        numberOfPeople = data2["Number of people"];
        lineOne = "$foodItem - $cuisine";
        lineTwo = "$numberOfPeople servings";
        final dateTime = key as String;
        final date = dateTime.split(" ")[0];
        final time = dateTime.split(" ")[1].replaceAll(":", "");
        secondData = [key, lineOne, lineTwo, date, time];
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

    cuisine = data["Cuisine"];
    foodItem = data["Food Item"];
    numberOfPeople = data["Number of people"];
    lineOne = "$foodItem - $cuisine";
    lineTwo = "$numberOfPeople servings";
    final dateTime = event.snapshot.key as String;
    final date = dateTime.split(" ")[0];
    final time = dateTime.split(" ")[1].replaceAll(":", "");
    secondData = [event.snapshot.key ?? "", lineOne, lineTwo, date, time];

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

Stream<void> getDataStream() async* {
  User? user = FirebaseAuth.instance.currentUser;
  String docID = await findDocID(user?.uid ?? "None", "NGOs");
  yield* FirebaseFirestore.instance
      .collection("NGOs")
      .doc(docID)
      .snapshots()
      .map((snapshot) {
    userCountry = snapshot["Country"];
    userCity = snapshot["City"];
    ngoName = snapshot["NGO Name"];
    ngoAddress = snapshot["Address Line"];
    userName = snapshot["Full Name"];
    userEmail = snapshot["Email"];
  });
}

Stream<Map<String, List<List<String>>>> _getListing() {
  Map<String, List<List<String>>> myMap = {};

  DatabaseReference ref = FirebaseDatabase.instance.ref("Orders/$userCountry");

  StreamController<Map<String, List<List<String>>>> controller =
      StreamController.broadcast();

  ref.once().then((event) {
    if (event.snapshot.value != null) {
      final data = event.snapshot.value as Map;

      data.forEach((key, value) {
        List<List<String>> cityData = [];
        final cityKey = key;
        final users = value as Map;

        users.forEach((key, value) {
          List<String> reqData = [];
          final userID = key;
          final userOrder = value as Map;

          userOrder.forEach((key, value) {
            final orderTime = key;

            final requestData = value as Map;

            String storeNumber = requestData["Store Number"];
            String imagePath = requestData["File Path"];
            String fullName = requestData["Full Name"];
            String beforeDate = requestData["Best Before"];
            String storeName = requestData["Store Name"];
            String area = requestData["Area"];
            String cuisine = requestData["Cuisine"];
            String foodItem = requestData["Food Item"];
            String numberOfPeople = requestData["Number of people"];
            String lineOne = "$storeName - $foodItem";
            String lineTwo = "$numberOfPeople servings, $cityKey";
            String lineThree = "$numberOfPeople servings, $area";
            final dateTime = orderTime as String;
            final date = dateTime.split(" ")[0];
            final time = dateTime.split(" ")[1].replaceAll(":", "");
            reqData = [
              cuisine,
              lineOne,
              lineTwo,
              userID,
              orderTime,
              beforeDate,
              lineThree,
              fullName,
              imagePath, foodItem, // 9
              numberOfPeople, // 10
              storeName, // 11
              storeNumber, // 12
              area, // 13
              cityKey,
              date,
              time // 14
            ];
            if (reqData.isNotEmpty) {
              cityData.add(reqData);
            }
          });
        });
        cityData.sort((a, b) => int.parse(b[16]).compareTo(int.parse(a[16])));
        cityData.sort((a, b) {
          var dateA = DateTime.parse(
              "${a[15].split("-")[2]}-${a[15].split("-")[1]}-${a[15].split("-")[0]}");
          var dateB = DateTime.parse(
              "${b[15].split("-")[2]}-${b[15].split("-")[1]}-${b[15].split("-")[0]}");
          return dateB.compareTo(dateA);
        });
        myMap[cityKey] = cityData;
      });

      List<List<String>> userCityValues = myMap.remove(userCity) ?? [];
      myMap = {userCity: userCityValues, ...myMap};

      controller.add(myMap);
    }
  });
  ref.onChildChanged.listen((event) {
    final data = event.snapshot.value as Map;
    final keyCity = event.snapshot.key;
    myMap.remove(keyCity);
    List<List<String>> cityData = [];
    data.forEach((key, value) {
      List<String> reqData = [];
      final userID = key;
      final userOrder = value as Map;

      userOrder.forEach((key, value) {
        final orderTime = key;

        final requestData = value as Map;
        String storeNumber = requestData["Store Number"];
        String fullName = requestData["Full Name"];
        String imagePath = requestData["File Path"];
        String beforeDate = requestData["Best Before"];
        String storeName = requestData["Store Name"];
        String area = requestData["Area"];
        String cuisine = requestData["Cuisine"];
        String foodItem = requestData["Food Item"];
        String numberOfPeople = requestData["Number of people"];
        String lineOne = "$storeName - $foodItem";
        String lineTwo = "$numberOfPeople servings, $keyCity";
        String lineThree = "$numberOfPeople servings, $area";
        final dateTime = orderTime as String;
        final date = dateTime.split(" ")[0];
        final time = dateTime.split(" ")[1].replaceAll(":", "");
        reqData = [
          cuisine, // 0
          lineOne, // 1
          lineTwo, // 2
          userID, // 3
          orderTime, // 4
          beforeDate, // 5
          lineThree, // 6
          fullName, // 7
          imagePath, // 8
          foodItem, // 9
          numberOfPeople, // 10
          storeName, // 11
          storeNumber, // 12
          area, // 13
          keyCity!,
          date,
          time
        ];
        if (reqData.isNotEmpty) {
          cityData.add(reqData);
        }
      });
    });
    cityData.sort((a, b) => int.parse(b[16]).compareTo(int.parse(a[16])));
    cityData.sort((a, b) {
      var dateA = DateTime.parse(
          "${a[15].split("-")[2]}-${a[15].split("-")[1]}-${a[15].split("-")[0]}");
      var dateB = DateTime.parse(
          "${b[15].split("-")[2]}-${b[15].split("-")[1]}-${b[15].split("-")[0]}");
      return dateB.compareTo(dateA);
    });
    myMap[keyCity!] = cityData;
    List<List<String>> userCityValues = myMap.remove(userCity) ?? [];
    myMap = {userCity: userCityValues, ...myMap};

    controller.add(myMap);
  });
  ref.onChildAdded.listen((event) {
    final data = event.snapshot.value as Map;
    final keyCity = event.snapshot.key;
    myMap.remove(keyCity);
    List<List<String>> cityData = [];
    data.forEach((key, value) {
      List<String> reqData = [];
      final userID = key;
      final userOrder = value as Map;

      userOrder.forEach((key, value) {
        final orderTime = key;

        final requestData = value as Map;

        String storeNumber = requestData["Store Number"];
        String fullName = requestData["Full Name"];
        String imagePath = requestData["File Path"];
        String beforeDate = requestData["Best Before"];
        String storeName = requestData["Store Name"];
        String area = requestData["Area"];
        String cuisine = requestData["Cuisine"];
        String foodItem = requestData["Food Item"];
        String numberOfPeople = requestData["Number of people"];
        String lineOne = "$storeName - $foodItem";
        String lineTwo = "$numberOfPeople servings, $keyCity";
        String lineThree = "$numberOfPeople servings, $area";
        final dateTime = orderTime as String;
        final date = dateTime.split(" ")[0];
        final time = dateTime.split(" ")[1].replaceAll(":", "");
        reqData = [
          cuisine,
          lineOne,
          lineTwo,
          userID,
          orderTime,
          beforeDate,
          lineThree,
          fullName,
          imagePath,
          foodItem, // 9
          numberOfPeople, // 10
          storeName, // 11
          storeNumber, // 12
          area, // 13
          keyCity!, // 14
          date,
          time
        ];
        if (reqData.isNotEmpty) {
          cityData.add(reqData);
        }
      });
    });
    cityData.sort((a, b) => int.parse(b[16]).compareTo(int.parse(a[16])));
    cityData.sort((a, b) {
      var dateA = DateTime.parse(
          "${a[15].split("-")[2]}-${a[15].split("-")[1]}-${a[15].split("-")[0]}");
      var dateB = DateTime.parse(
          "${b[15].split("-")[2]}-${b[15].split("-")[1]}-${b[15].split("-")[0]}");
      return dateB.compareTo(dateA);
    });
    myMap[keyCity!] = cityData;
    List<List<String>> userCityValues = myMap.remove(userCity) ?? [];
    myMap = {userCity: userCityValues, ...myMap};

    controller.add(myMap);
  });
  ref.onChildRemoved.listen((event) {
    final key = event.snapshot.key;
    myMap.remove(key);
    List<List<String>> userCityValues = myMap.remove(userCity) ?? [];
    myMap = {userCity: userCityValues, ...myMap};
    controller.add(myMap);
  });

  return controller.stream;
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
