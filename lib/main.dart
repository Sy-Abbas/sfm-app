import 'dart:developer' as devetools show log;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sfm/views/home_donator.dart';
import 'package:sfm/views/home_ngo.dart';
import 'package:sfm/views/home_page.dart';
import 'package:sfm/views/login_donator.dart';
import 'package:sfm/views/login_ngo.dart';
import 'package:sfm/views/register_donator.dart';
import 'package:sfm/views/register_ngo.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "Surplus Food Management",
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const Initialize(),
    routes: {
      '/homepage/': (context) => const HomePage(),
      '/logindonator/': ((context) => const LoginViewDonator()),
      '/loginngo/': ((context) => const LoginViewNGO()),
      '/registerdonator/': ((context) => const RegisterViewDonator()),
      '/registerngo/': ((context) => const RegisterViewNGO()),
      '/homedonator/': ((context) => const HomeDonators()),
      '/homengo/': ((context) => const HomeNGO()),
    },
  ));
}

class Initialize extends StatelessWidget {
  const Initialize({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      ),
      builder: (context, snapshot) {
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
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: const Text("Verify Email"),
          content: const Text("Send verify email?"),
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
