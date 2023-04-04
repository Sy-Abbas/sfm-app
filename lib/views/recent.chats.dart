import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:sfm/main.dart';
import 'package:sfm/views/single_chat.dart';
import '../assets/storage_service.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as devetools show log;

class RecentChats extends StatefulWidget {
  String? userType;
  RecentChats({Key? key, this.userType}) : super(key: key);

  @override
  State<RecentChats> createState() => _RecentChatsState();
}

class _RecentChatsState extends State<RecentChats> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, List<String>>>>(
        stream: getInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data;
            return RecentChats2(
              data: data,
              userType: widget.userType,
            );
          } else {
            return MainRecentChats(
              userType: widget.userType,
            );
          }
        });
  }

  Stream<List<Map<String, List<String>>>> getInfo() {
    User? user = FirebaseAuth.instance.currentUser;
    final userUID = user?.uid ?? "";

    StreamController<List<Map<String, List<String>>>> controller =
        StreamController.broadcast();
    Map<String, List<String>> youStarted = {};
    Map<String, List<String>> otherStarted = {};

    DatabaseReference ref = FirebaseDatabase.instance.ref("Chats/");
    ref.onChildAdded.listen((event) {
      if (event.snapshot.value != null) {
        List<String> parts = event.snapshot.key!.split("|");
        if (parts.contains(userUID)) {
          if (parts[0] == userUID) {
            List<List<String>> message = [];

            final mapKey = parts[1];
            final orderNumber = parts[2];
            final data = event.snapshot.value as Map;
            data.forEach((key, value) {
              final addDate = key as String;
              final data2 = value as Map;
              data2.forEach((key, value) {
                final user = key;
                final data3 = value as Map;

                data3.forEach((key, value) {
                  final secMessage = [
                    addDate,
                    user as String,
                    (key.replaceAll(":", "") as String),
                    value["Message"] as String,
                    orderNumber
                  ];
                  message.add(secMessage);
                });
              });
            });

            message.sort((a, b) => int.parse(b[2]).compareTo(int.parse(a[2])));
            message.sort((a, b) {
              var dateA = DateTime.parse(
                  "${a[0].split("-")[2]}-${a[0].split("-")[1]}-${a[0].split("-")[0]}");
              var dateB = DateTime.parse(
                  "${b[0].split("-")[2]}-${b[0].split("-")[1]}-${b[0].split("-")[0]}");
              return dateB.compareTo(dateA);
            });
            youStarted = {mapKey: message[0]};
          } else {
            List<List<String>> message = [];

            final mapKey = parts[0];
            final orderNumber = parts[2];

            final data = event.snapshot.value as Map;
            data.forEach((key, value) {
              final addDate = key as String;
              final data2 = value as Map;
              data2.forEach((key, value) {
                final user = key;
                final data3 = value as Map;

                data3.forEach((key, value) {
                  final secMessage = [
                    addDate,
                    user as String,
                    (key.replaceAll(":", "") as String),
                    value["Message"] as String,
                    orderNumber
                  ];
                  message.add(secMessage);
                });
              });
            });

            message.sort((a, b) => int.parse(b[2]).compareTo(int.parse(a[2])));
            message.sort((a, b) {
              var dateA = DateTime.parse(
                  "${a[0].split("-")[2]}-${a[0].split("-")[1]}-${a[0].split("-")[0]}");
              var dateB = DateTime.parse(
                  "${b[0].split("-")[2]}-${b[0].split("-")[1]}-${b[0].split("-")[0]}");
              return dateB.compareTo(dateA);
            });
            otherStarted[mapKey] = message[0];
          }

          controller.add([youStarted, otherStarted]);
        }
      }
    });
    ref.onChildChanged.listen((event) {
      if (event.snapshot.value != null) {
        List<String> parts = event.snapshot.key!.split("|");
        if (parts.contains(userUID)) {
          if (parts[0] == userUID) {
            List<List<String>> message = [];

            final mapKey = parts[1];
            final orderNumber = parts[2];

            final data = event.snapshot.value as Map;
            data.forEach((key, value) {
              final addDate = key as String;
              final data2 = value as Map;
              data2.forEach((key, value) {
                final user = key;
                final data3 = value as Map;

                data3.forEach((key, value) {
                  final secMessage = [
                    addDate,
                    user as String,
                    (key.replaceAll(":", "") as String),
                    value["Message"] as String,
                    orderNumber
                  ];
                  message.add(secMessage);
                });
              });
            });

            message.sort((a, b) => int.parse(b[2]).compareTo(int.parse(a[2])));
            message.sort((a, b) {
              var dateA = DateTime.parse(
                  "${a[0].split("-")[2]}-${a[0].split("-")[1]}-${a[0].split("-")[0]}");
              var dateB = DateTime.parse(
                  "${b[0].split("-")[2]}-${b[0].split("-")[1]}-${b[0].split("-")[0]}");
              return dateB.compareTo(dateA);
            });
            youStarted = {mapKey: message[0]};
          } else {
            List<List<String>> message = [];

            final mapKey = parts[0];

            final orderNumber = parts[2];
            final data = event.snapshot.value as Map;
            data.forEach((key, value) {
              final addDate = key as String;
              final data2 = value as Map;
              data2.forEach((key, value) {
                final user = key;
                final data3 = value as Map;

                data3.forEach((key, value) {
                  final secMessage = [
                    addDate,
                    user as String,
                    (key.replaceAll(":", "") as String),
                    value["Message"] as String,
                    orderNumber
                  ];
                  message.add(secMessage);
                });
              });
            });

            message.sort((a, b) => int.parse(b[2]).compareTo(int.parse(a[2])));
            message.sort((a, b) {
              var dateA = DateTime.parse(
                  "${a[0].split("-")[2]}-${a[0].split("-")[1]}-${a[0].split("-")[0]}");
              var dateB = DateTime.parse(
                  "${b[0].split("-")[2]}-${b[0].split("-")[1]}-${b[0].split("-")[0]}");
              return dateB.compareTo(dateA);
            });
            otherStarted = {mapKey: message[0]};
          }

          controller.add([youStarted, otherStarted]);
        }
      }
    });

    return controller.stream;
  }
}

List<List<dynamic>> imagesYou = [];
List<List<dynamic>> imagesOther = [];

class RecentChats2 extends StatefulWidget {
  List<Map<String, List<String>>>? data;
  String? userType;

  RecentChats2({Key? key, this.data, this.userType}) : super(key: key);

  @override
  State<RecentChats2> createState() => _RecentChats2State();
}

class _RecentChats2State extends State<RecentChats2> {
  late Future<String> _getPictures;

  @override
  void initState() {
    _getPictures = getPictures();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getPictures,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return MainRecentChats(
              pictures: [imagesYou, imagesOther],
              data: widget.data,
              userType: widget.userType,
            );
          } else {
            return Stack(
              children: [
                MainRecentChats(
                  userType: widget.userType,
                ),
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                      child: Dialog(
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
                  )),
                ),
              ],
            );
          }
        });
  }

  Future<String> getPictures() async {
    imagesYou = [];
    imagesOther = [];
    final youData = widget.data![0];
    final otherData = widget.data![1];
    final storage = Storage();

    await Future.forEach(youData.entries, (entry) async {
      final userUID = entry.key.trim();
      final userType = await getUserType(userUID);
      final userDocID = await findDocID(userUID, userType);
      String filePathUser = "";
      ImageProvider<Object>? networkFileUser = const NetworkImage("");
      String userName = "";
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection(userType)
          .doc(userDocID)
          .get();
      userName = userDocSnapshot["Full Name"];

      try {
        filePathUser = await storage.downloadURL("$userUID/userProfile.jpg");
        networkFileUser = NetworkImage(filePathUser);
      } catch (e) {
        networkFileUser = null;
      }
      imagesYou.add([networkFileUser, userName]);
    });

    await Future.forEach(otherData.entries, (entry) async {
      final userUID = entry.key.trim();
      final userType = await getUserType(userUID);

      final userDocID = await findDocID(userUID, userType);
      String filePathUser = "";
      ImageProvider<Object>? networkFileUser = const NetworkImage("");
      String userName = "";
      final userDocSnapshot = await FirebaseFirestore.instance
          .collection(userType)
          .doc(userDocID)
          .get();
      userName = userDocSnapshot["Full Name"];

      try {
        filePathUser = await storage.downloadURL("$userUID/userProfile.jpg");
        networkFileUser = NetworkImage(filePathUser);
      } catch (e) {
        networkFileUser = null;
      }
      imagesOther.add([networkFileUser, userName]);
    });

    return "";
  }
}

class MainRecentChats extends StatefulWidget {
  List<List<List<dynamic>>>? pictures;
  List<Map<String, List<String>>>? data;
  String? userType;
  MainRecentChats({Key? key, this.pictures, this.data, this.userType})
      : super(key: key);

  @override
  State<MainRecentChats> createState() => _MainRecentChatsState();
}

class _MainRecentChatsState extends State<MainRecentChats> {
  String youText = '';
  String otherText = '';
  String selectedTag = '';
  bool showYour = false;
  @override
  void initState() {
    if (widget.userType == "NGOs") {
      setState(() {
        youText = "Food Listings";
        otherText = "Request Listings";
        selectedTag = otherText;
      });
    } else {
      setState(() {
        otherText = "Food Listings";
        youText = "Request Listings";
        selectedTag = otherText;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color(0xff05240E),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Recent Chat",
          style: TextStyle(
              color: const Color(0xff05240E),
              fontSize: MediaQuery.of(context).size.width * 0.065,
              fontFamily: "RobotoBold"),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedTag = otherText;
                    showYour = false;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      otherText,
                      style: TextStyle(
                          color: selectedTag == otherText
                              ? Colors.green
                              : Colors.grey.shade400,
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          fontFamily: "RobotoBold"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: selectedTag == otherText
                          ? Colors.green
                          : Colors.grey.shade400,
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.5,
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedTag = youText;
                    showYour = true;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      youText,
                      style: TextStyle(
                          color: selectedTag == youText
                              ? Colors.green
                              : Colors.grey.shade400,
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          fontFamily: "RobotoBold"),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      color: selectedTag == youText
                          ? Colors.green
                          : Colors.grey.shade400,
                      height: 5,
                      width: MediaQuery.of(context).size.width * 0.5,
                    )
                  ],
                ),
              ),
            ],
          ),
          widget.data != null
              ? showYour
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: widget.data![0].length,
                          itemBuilder: ((context, index) {
                            List<String> uids = [];
                            final uidData = widget.data![0];
                            uidData.forEach((key, value) {
                              uids.add(key);
                            });
                            return showRecent(
                              uids[index],
                              widget.pictures![0][index][0],
                              widget.pictures![0][index][1],
                              widget.data![0][uids[index]]![3],
                              widget.data![0][uids[index]]![2],
                              widget.data![0][uids[index]]![4],
                              widget.data![0][uids[index]]![1],
                              widget.data![0][uids[index]]![0],
                            );
                          })),
                    )
                  : SizedBox(
                      height: MediaQuery.of(context).size.height * 0.8,
                      child: ListView.builder(
                          itemCount: widget.data![1].length,
                          itemBuilder: ((context, index) {
                            List<String> uids = [];
                            final uidData = widget.data![1];
                            uidData.forEach((key, value) {
                              uids.add(key);
                            });
                            return showRecent(
                              uids[index],
                              widget.pictures![1][index][0],
                              widget.pictures![1][index][1],
                              widget.data![1][uids[index]]![3],
                              widget.data![1][uids[index]]![2],
                              widget.data![1][uids[index]]![4],
                              widget.data![1][uids[index]]![1],
                              widget.data![1][uids[index]]![0],
                            );
                          })),
                    )
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget showRecent(
      String uid,
      ImageProvider<Object>? image,
      String name,
      String lastMessage,
      String timeDate,
      String orderNumber,
      String whoMessaged,
      String date) {
    final today = getFormattedDate()[0];
    final yesterday = getFormattedYesterday();
    if (date == today) {
      timeDate = "${timeDate.substring(0, 2)}:${timeDate.substring(2, 4)}";
    } else if (date == yesterday) {
      timeDate = "Yesterday";
    } else {
      timeDate = "${date.substring(0, 2)}-${date.substring(3, 5)}";
    }
    final user = FirebaseAuth.instance.currentUser;
    final String userID = user!.uid;
    if (whoMessaged == userID) {
      lastMessage = "You: $lastMessage";
    }
    if (lastMessage.length > 36) {
      lastMessage = "${lastMessage.substring(0, 36)}...";
    }
    if (name.length > 26) {
      name = "${name.substring(0, 26)}...";
    }
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GetPictures(
                      otherUID: uid,
                      fullName: name,
                      orderNumber: orderNumber,
                      showRecentChat: !showYour,
                    )));
      },
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Row(
            children: [
              const SizedBox(
                width: 14,
              ),
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                radius: 30,
                foregroundImage:
                    image ?? const AssetImage("assets/images/user2.png"),
              ),
              const SizedBox(
                width: 14,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                          color: const Color(0xff05240E),
                          fontSize: MediaQuery.of(context).size.width * 0.042,
                          fontFamily: "RobotoBold"),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            lastMessage,
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                fontFamily: "Roboto"),
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.15,
                          child: Text(
                            timeDate,
                            style: TextStyle(
                                color: Colors.green,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.032,
                                fontFamily: "Roboto"),
                            textAlign: TextAlign.right,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black,
          )
        ],
      ),
    );
  }

  List<String> getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy HH:mm:ss:SSS');
    final dataTime = formatter.format(now);
    List<String> dateAndTime = dataTime.split(' ');
    return dateAndTime;
  }

  String getFormattedYesterday() {
    final now = DateTime.now();
    final yesterday = now.subtract(const Duration(days: 1));

    final formatter = DateFormat('dd-MM-yyyy');
    final dataTime = formatter.format(yesterday);
    return dataTime;
  }
}
