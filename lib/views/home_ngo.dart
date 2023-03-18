// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MenuAction { logout, profile }

class HomeNGO extends StatefulWidget {
  const HomeNGO({super.key});

  @override
  State<HomeNGO> createState() => _HomeNGOState();
}

class _HomeNGOState extends State<HomeNGO> {
  @override
  Widget build(BuildContext context) {
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
                        final shouldLogout = await showLogOurDialog(context);
                        if (shouldLogout) {
                          await FirebaseAuth.instance.signOut();
                          await FirebaseAuth.instance
                              .signOut(); // clear cached data
                          await Navigator.of(context).pushNamedAndRemoveUntil(
                            '/loginngo/',
                            (route) => false,
                          );
                        }
                        break;
                      case MenuAction.profile:
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                          '/profilengo/',
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
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              children: const [
                Text(
                  "SFM - NGO's Homepage",
                  style: TextStyle(
                      fontSize: 30,
                      fontFamily: "Roboto",
                      color: Color(0xff05240E)),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> showLogOurDialog(BuildContext context) {
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
