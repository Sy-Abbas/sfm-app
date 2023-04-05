import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lottie/lottie.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Color(0xff05240E),
        ),
        title: Text(
          "Notfications",
          style: TextStyle(
              color: const Color(0xff05240E),
              fontSize: MediaQuery.of(context).size.width * 0.065,
              fontFamily: "RobotoBold"),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 350,
              child: OverflowBox(
                minHeight: 350,
                maxHeight: 350,
                child: Lottie.asset(
                  "assets/animation/coming-soon.json",
                ),
              ),
            ),
            const Text(
              "Coming soon! We're working hard to bring you notifications. Stay tuned for updates on when this feature will be available",
              style: TextStyle(
                fontFamily: "Roboto",
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.09,
            )
          ],
        ),
      ),
    );
  }
}
