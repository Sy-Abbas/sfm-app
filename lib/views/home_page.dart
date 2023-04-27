import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sfm/assets/sfm_icons.dart';
import 'package:sfm/views/home_donator.dart';
import 'package:sfm/views/home_ngo.dart';
import 'package:sfm/views/login_donator.dart';
import 'package:sfm/views/login_ngo.dart';

import '../main.dart';

var userType = "None";
var userDocID = "None";
List<bool> isDe = [false, false];

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  late Future<String> _getUserType;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    _getUserType = doneGetting();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getUserType,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (user != null) {
                if (user?.emailVerified ?? false) {
                  if (userType == "Donators") {
                    return const Check2("Donators");
                  } else if (userType == "NGOs") {
                    return const Check2("NGOs");
                  } else {
                    return const HomePage();
                  }
                } else {
                  if (userType == "Donators") {
                    return const LoginViewDonator();
                  } else if (userType == "NGOs") {
                    return const LoginViewNGO();
                  } else {
                    return const HomePage();
                  }
                }
              } else {
                return const HomePage();
              }

            default:
              return const Scaffold();
          }
        }));
  }
}

class Check2 extends StatefulWidget {
  final String useT;
  const Check2(this.useT, {super.key});
  @override
  State<Check2> createState() => _Check2State();
}

class _Check2State extends State<Check2> {
  late Future<String> _isDetailed;

  @override
  void initState() {
    String ut = widget.useT;
    _isDetailed = checkingDetailed(ut);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _isDetailed,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              if (isDe[0] == false || isDe[1] == false) {
                if (widget.useT == "NGOs") {
                  return const LoginViewNGO();
                } else if (widget.useT == "Donators") {
                  return const LoginViewDonator();
                }
              } else if (isDe[0] && isDe[1]) {
                if (widget.useT == "NGOs") {
                  return const HomeNGO();
                } else if (widget.useT == "Donators") {
                  return const HomeDonators();
                }
              } else {
                return const HomePage();
              }
              return const HomePage();

            default:
              return const Scaffold();
          }
        }));
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFDBE8D8),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                onPressed: (() {}),
                icon: const Icon(SFMIcons.burger),
                color: const Color(0xff138034),
              ),
              IconButton(
                onPressed: (() {}),
                icon: const Icon(SFMIcons.apple),
                color: const Color(0xff138034),
              ),
              IconButton(
                onPressed: (() {}),
                icon: const Icon(SFMIcons.pizza),
                color: const Color(0xff138034),
              )
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 172,
                      height: 172,
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage("assets/logo.png"),
                        fit: BoxFit.fitWidth,
                      )),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.02,
                    ),
                    const Text(
                      "Surplus Food Management",
                      style: TextStyle(
                          fontSize: 35,
                          fontFamily: "Roboto",
                          color: Color(0xff05240E)),
                      textAlign: TextAlign.center,
                    )
                  ]),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(42),
                        topRight: Radius.circular(42)),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      width: MediaQuery.of(context).size.width * 0.85,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Ending Hunger, One Meal at a Time with SFM",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontFamily: "Roboto",
                                  color: Color(0xff05240E),
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF05240E))),
                                onPressed: (() {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/logindonator/', (route) => true);
                                }),
                                child: const Text(
                                  "I'm a Donator",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.02,
                              ),
                              ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            const Color(0xFF05240E))),
                                onPressed: (() {
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                      '/loginngo/', (route) => true);
                                }),
                                child: const Text(
                                  "I'm an NGO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: "Roboto",
                                  ),
                                ),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Future<String> doneGetting() async {
  User? user = FirebaseAuth.instance.currentUser;
  userType = await getUserType(user?.uid ?? "None");
  return "Done";
}

Future<String> checkingDetailed(String uT) async {
  User? user = FirebaseAuth.instance.currentUser;
  userDocID = await findDocID(user?.uid ?? "None", uT);
  isDe[0] = await detailsEntered(user?.uid ?? "None", uT, userDocID);
  isDe[1] = await accountApproved(user?.uid ?? "None", uT, userDocID);
  return "Done";
}
