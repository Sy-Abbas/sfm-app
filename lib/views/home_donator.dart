// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum MenuAction { logout }

class HomeDonators extends StatefulWidget {
  const HomeDonators({super.key});

  @override
  State<HomeDonators> createState() => _HomeDonatorsState();
}

class _HomeDonatorsState extends State<HomeDonators> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text("HomePage Donator"),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogOurDialog(context);
                if (shouldLogout) {
                  await FirebaseAuth.instance.signOut();
                  await FirebaseAuth.instance.signOut(); // clear cached data

                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/logindonator/',
                    (route) => false,
                  );
                }
                break;
            }
          }, itemBuilder: ((context) {
            return const [
              PopupMenuItem<MenuAction>(
                value: MenuAction.logout,
                child: Text("Log Out"),
              )
            ];
          }))
        ],
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
