import 'dart:developer' as devetools show log;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sfm/views/home_donator.dart';
import 'package:sfm/views/home_ngo.dart';
import 'package:sfm/views/login_donator.dart';
import 'package:sfm/views/login_ngo.dart';

import '../main.dart';

final user = FirebaseAuth.instance.currentUser;
var userType = "None";

class Check extends StatefulWidget {
  const Check({super.key});

  @override
  State<Check> createState() => _CheckState();
}

class _CheckState extends State<Check> {
  late Future<String> _getUserType;

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
                    return const HomeDonators();
                  } else if (userType == "NGOs") {
                    return const HomeNGO();
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
          gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Colors.black, Color(0xFF00242c), Color(0xFF81e291)],
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // appBar: AppBar(
        //   title: const Text("Welcome to SFM"),
        //   centerTitle: true,
        //   backgroundColor: Colors.green,
        // ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  // ignore: prefer_const_constructors
                  decoration: BoxDecoration(
                    image: const DecorationImage(
                      image: AssetImage("assets/logo.png"),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "Reducing Food Waste, Feeding the Hungry",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: (() {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/logindonator/', (route) => false);
                  }),
                  child: const Text(
                    "Restaurant & Hotels",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green)),
                  onPressed: (() {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        '/loginngo/', (route) => false);
                  }),
                  child: const Text(
                    "NGOs",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> doneGetting() async {
  userType = await getUserType(user?.uid ?? "None");
  return "Done";
}
