import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import '../assets/storage_service.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as devetools show log;

String filePathOther = "";
String fileNameOther = "";
String preivousTime = '';
String preiousUID = '';
String filePathUser = "";
String fileNameUser = "";
ImageProvider<Object>? networkFileUser = const NetworkImage("");
ImageProvider<Object>? networkFileOther = const NetworkImage("");

class GetPictures extends StatefulWidget {
  String? otherUID;
  String? fullName;
  String? orderNumber;
  bool? showRecentChat;
  GetPictures({
    Key? key,
    this.otherUID,
    this.fullName,
    this.orderNumber,
    this.showRecentChat,
  }) : super(key: key);

  @override
  State<GetPictures> createState() => _GetPicturesState();
}

class _GetPicturesState extends State<GetPictures> {
  late Future<String> _getDetails;
  @override
  void initState() {
    _getDetails = getPics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _getDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Chat(
              otherUID: widget.otherUID,
              fullName: widget.fullName,
              orderNumber: widget.orderNumber,
              showRecentChat: widget.showRecentChat,
            );
          } else {
            return const Scaffold();
          }
        });
  }

  Future<String> getPics() async {
    preivousTime = '';
    preiousUID = '';
    final user = FirebaseAuth.instance.currentUser;
    final String userID = user!.uid;
    final otherUser = widget.otherUID;

    try {
      final Storage storage = Storage();
      filePathUser = await storage.downloadURL("$userID/userProfile.jpg");
      networkFileUser = NetworkImage(filePathUser);
      // ignore: empty_catches
    } catch (error) {}
    try {
      final Storage storage = Storage();
      filePathOther = await storage.downloadURL("$otherUser/userProfile.jpg");
      networkFileOther = NetworkImage(filePathOther);
      // ignore: empty_catches
    } catch (error) {}

    return "";
  }
}

class Chat extends StatefulWidget {
  String? otherUID;
  String? fullName;
  String? orderNumber;
  bool? showRecentChat;

  Chat(
      {Key? key,
      this.otherUID,
      this.fullName,
      this.orderNumber,
      this.showRecentChat})
      : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _textController = TextEditingController();

  final ScrollController _scrollController = ScrollController();
  double _keyboardHeight = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
      if (keyboardHeight > 0) {
        setState(() {
          _keyboardHeight = keyboardHeight;
        });
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + _keyboardHeight,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<List<String>>>(
        stream: _getChats(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data as List<List<String>>;
            data.sort((a, b) => int.parse(b[2]).compareTo(int.parse(a[2])));
            data.sort((a, b) {
              var dateA = DateTime.parse(
                  "${a[0].split("-")[2]}-${a[0].split("-")[1]}-${a[0].split("-")[0]}");
              var dateB = DateTime.parse(
                  "${b[0].split("-")[2]}-${b[0].split("-")[1]}-${b[0].split("-")[0]}");
              return dateB.compareTo(dateA);
            });
            devetools.log(data.toString());
            List<int> datesList = [];
            String currentKey = data.first.first;
            for (int i = 1; i < data.length; i++) {
              if (data[i].first != currentKey) {
                datesList.add(i - 1);
                currentKey = data[i].first;
              }
            }
            if (datesList.isEmpty || datesList.last != data.length - 1) {
              datesList.add(data.length - 1);
            }

            List<String> allTimes = [];

            for (List<String> sublist in data) {
              String hhMM1 = sublist[2].substring(0, 2);
              String hhMM2 = sublist[2].substring(2, 4);

              String time = "$hhMM1:$hhMM2";
              allTimes.add(time);
            }
            List<int> filteredTime = [];
            for (String x in allTimes) {
              String temp = x.replaceAll(':', '');
              int timeInt = int.parse(temp);
              if (filteredTime.isEmpty) {
                filteredTime.add(timeInt);
              } else {
                int plusOne = timeInt + 1;
                int plusTwo = timeInt + 2;
                int plusThree = timeInt + 3;
                int plusFour = timeInt + 4;
                int plusFive = timeInt + 5;
                int minusOne = timeInt - 1;
                int minusTwo = timeInt - 2;
                int minusThree = timeInt - 3;
                int minusFour = timeInt - 4;
                int minusFive = timeInt - 5;
                if (filteredTime.contains(timeInt) ||
                    filteredTime.contains(plusOne) ||
                    filteredTime.contains(plusTwo) ||
                    filteredTime.contains(plusThree) ||
                    filteredTime.contains(plusFour) ||
                    filteredTime.contains(plusFive) ||
                    filteredTime.contains(minusOne) ||
                    filteredTime.contains(minusTwo) ||
                    filteredTime.contains(minusThree) ||
                    filteredTime.contains(minusFour) ||
                    filteredTime.contains(minusFive)) {
                } else {
                  filteredTime.add(timeInt);
                }
              }
            }

            List<String> output = [];
            for (int i = 0; i < filteredTime.length; i++) {
              int hours = filteredTime[i] ~/ 100;
              int minutes = filteredTime[i] % 100;
              String hoursString = hours.toString().padLeft(2, '0');
              String minutesString = minutes.toString().padLeft(2, '0');
              output.add("$hoursString:$minutesString");
            }

            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                actions: [
                  IconButton(
                      color: Colors.white,
                      onPressed: () {},
                      icon: const Icon(Icons.phone))
                ],
                backgroundColor: Colors.green,
                centerTitle: true,
                title: Text(
                  widget.fullName!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.050,
                      fontFamily: "Roboto"),
                ),
              ),
              body: SafeArea(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: SingleChildScrollView(
                    child: Container(
                      color: Colors.green,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50)),
                            child: Container(
                              color: Colors.white,
                              height: MediaQuery.of(context).size.height * 0.78,
                              child: ListView.builder(
                                reverse: true,
                                itemCount: data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return index == 0
                                      ? _showChatMessage(
                                          data[index][0],
                                          data[index][1],
                                          data[index][3],
                                          false,
                                          datesList.contains(index),
                                          allTimes[index],
                                          output)
                                      : _showChatMessage(
                                          data[index][0],
                                          data[index][1],
                                          data[index][3],
                                          data[index][1] == data[index - 1][1],
                                          datesList.contains(index),
                                          allTimes[index],
                                          output);
                                },
                              ),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _textController,
                                      decoration: const InputDecoration(
                                        hintText: "Type a message",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8.0),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final message =
                                          _textController.text.trim();
                                      final user =
                                          FirebaseAuth.instance.currentUser;
                                      final String userID = user!.uid;
                                      final otherUserUID = widget.otherUID;
                                      final orderNum = widget.orderNumber;
                                      final dateTime = getFormattedDate();
                                      final date = dateTime[0];
                                      final time = dateTime[1];

                                      DatabaseReference ref;

                                      if (widget.showRecentChat ?? false) {
                                        ref = FirebaseDatabase.instance.ref(
                                            "Chats/$otherUserUID|$userID|$orderNum/$date/$userID/$time/");
                                      } else {
                                        ref = FirebaseDatabase.instance.ref(
                                            "Chats/$userID|$otherUserUID|$orderNum/$date/$userID/$time/");
                                      }
                                      if (message != '') {
                                        await ref.set({
                                          "Message": message,
                                        });
                                      }
                                      _textController.text = "";
                                    },
                                    child: const Text("Send"),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                actions: [
                  IconButton(
                      color: Colors.white,
                      onPressed: () {},
                      icon: const Icon(Icons.phone))
                ],
                backgroundColor: Colors.green,
                centerTitle: true,
                title: Text(
                  widget.fullName!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: MediaQuery.of(context).size.width * 0.050,
                      fontFamily: "Roboto"),
                ),
              ),
              body: Container(
                color: Colors.white,
                child: SafeArea(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: SingleChildScrollView(
                      child: Container(
                        color: Colors.green,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50)),
                              child: Container(
                                color: Colors.white,
                                height:
                                    MediaQuery.of(context).size.height * 0.78,
                                child: ListView.builder(
                                  reverse: true,
                                  itemCount: 1,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox();
                                  },
                                ),
                              ),
                            ),
                            Container(
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _textController,
                                        keyboardType: TextInputType.text,
                                        decoration: const InputDecoration(
                                          hintText: "Type a message",
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    ElevatedButton(
                                      onPressed: () async {
                                        final message =
                                            _textController.text.trim();
                                        final user =
                                            FirebaseAuth.instance.currentUser;
                                        final String userID = user!.uid;
                                        final otherUserUID = widget.otherUID;
                                        final orderNum = widget.orderNumber;
                                        final dateTime = getFormattedDate();
                                        final date = dateTime[0];
                                        final time = dateTime[1];
                                        DatabaseReference ref;

                                        if (widget.showRecentChat ?? false) {
                                          ref = FirebaseDatabase.instance.ref(
                                              "Chats/$otherUserUID|$userID|$orderNum/$date/$userID/$time/");
                                        } else {
                                          ref = FirebaseDatabase.instance.ref(
                                              "Chats/$userID|$otherUserUID|$orderNum/$date/$userID/$time/");
                                        }
                                        if (message != '') {
                                          await ref.set({
                                            "Message": message,
                                          });
                                        }
                                        _textController.text = "";
                                      },
                                      child: const Text("Send"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        });
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

  Widget _showChatMessage(String date, String uid, String chat, bool showPic,
      bool showDate, String time, List<String> filteredTime) {
    bool s = true;
    bool showTime = false;
    final today = getFormattedDate()[0];
    final yesDate = getFormattedYesterday();
    if (date == today) {
      date = "Today";
    } else if (date == yesDate) {
      date = "Yesterday";
    }
    if (widget.otherUID == uid) {
      s = false;
    }
    if (!showDate && showPic) {
      showPic = true;
    } else {
      showPic = false;
    }
    if (filteredTime.contains(time) || preiousUID != uid) {
      if (time != preivousTime && filteredTime.contains(time)) {
        showTime = true;
      } else if (preiousUID != uid) {
        showTime = true;
      }
    }
    preiousUID = uid;
    preivousTime = time;

    return s
        ? Column(
            children: [
              showDate
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: const Color(0xFFDBE8D8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(date),
                        ),
                      ))
                  : const SizedBox(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Flexible(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(14),
                                    topLeft: Radius.circular(14)),
                                child: Container(
                                  color: const Color(0xFFDBE8D8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      chat,
                                      style: const TextStyle(
                                          fontFamily: "Roboto", fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      // !showPic
                      //     ? CircleAvatar(
                      //         backgroundColor: Colors.grey[300],
                      //         radius: 20,
                      //         foregroundImage: filePathUser == ""
                      //             ? const AssetImage("assets/images/user2.png")
                      //             : networkFileUser,
                      //       )
                      //     : const SizedBox(width: 40, height: 40),
                      const SizedBox(width: 10),
                    ],
                  ),
                ],
              ),
              showTime
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          time,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(
                          width: 15,
                        )
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              ),
            ],
          )
        : Column(
            children: [
              showDate
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        color: const Color(0xFFDBE8D8),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(date),
                        ),
                      ))
                  : const SizedBox(),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(width: 10),
                      !showPic
                          ? CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 20,
                              foregroundImage: filePathOther == ""
                                  ? const AssetImage("assets/images/user2.png")
                                  : networkFileOther,
                            )
                          : const SizedBox(
                              width: 40,
                              height: 40,
                            ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.42,
                        child: Row(
                          children: [
                            Flexible(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(14),
                                    bottomRight: Radius.circular(14),
                                    topRight: Radius.circular(14)),
                                child: Container(
                                  color: Colors.green,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      chat,
                                      style: const TextStyle(
                                          fontFamily: "Roboto",
                                          color: Colors.white,
                                          fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  showTime
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              width: 65,
                            ),
                            Text(
                              time,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.005,
              )
            ],
          );
  }

  Stream<List<List<String>>> _getChats() {
    List<List<String>> message = [];
    final user = FirebaseAuth.instance.currentUser;
    final String userID = user!.uid;
    final otherUserUID = widget.otherUID;
    final orderNum = widget.orderNumber;
    DatabaseReference ref;
    if (widget.showRecentChat ?? false) {
      ref = FirebaseDatabase.instance
          .ref("Chats/$otherUserUID|$userID|$orderNum");
    } else {
      ref = FirebaseDatabase.instance
          .ref("Chats/$userID|$otherUserUID|$orderNum");
    }

    StreamController<List<List<String>>> controller =
        StreamController.broadcast();
    ref.onChildChanged.listen((event) {
      message = [];
      final addDate = event.snapshot.key as String;
      final data2 = event.snapshot.value as Map;
      data2.forEach((key, value) {
        final user = key;
        final data3 = value as Map;

        data3.forEach((key, value) {
          final secMessage = [
            addDate,
            user as String,
            (key.replaceAll(":", "") as String),
            value["Message"] as String
          ];
          message.add(secMessage);
        });
      });
      // message.sort((a, b) => a[2].compareTo(b[2]));
      // message.sort((a, b) => a[0].compareTo(b[0]));

      controller.add(message);
    });

    ref.onChildAdded.listen((event) {
      // message = [];
      final addDate = event.snapshot.key as String;
      final data2 = event.snapshot.value as Map;
      data2.forEach((key, value) {
        final user = key;
        final data3 = value as Map;

        data3.forEach((key, value) {
          final secMessage = [
            addDate,
            user as String,
            (key.replaceAll(":", "") as String),
            value["Message"] as String
          ];
          message.add(secMessage);
        });
      });
      // message.sort((a, b) => a[2].compareTo(b[2]));
      // message.sort((a, b) => a[0].compareTo(b[0]));
      controller.add(message);
    });
    return controller.stream;
  }
}
