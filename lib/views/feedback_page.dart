// ignore_for_file: use_build_context_synchronously
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:sfm/assets/storage_service.dart';
import 'dart:developer' as devetools show log;

import '../assets/profile_pic.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final Storage storage = Storage();
  bool _login = false;
  bool _register = false;
  bool _profile = false;
  bool _listing = false;
  bool _request = false;
  bool _chat = false;
  bool _other = false;
  bool _suggestion = false;
  bool _useOne = false;
  bool _useTwo = false;
  bool _useThree = false;
  bool _useFour = false;
  bool _useFive = false;
  bool _effOne = false;
  bool _effTwo = false;
  bool _effThree = false;
  bool _effFour = false;
  bool _effFive = false;
  bool _editing = false;
  bool _effError = false;
  bool _useError = false;
  bool _useSelected = false;
  bool _effSelected = false;
  final TextEditingController _textController = TextEditingController();
  String filePath = "";
  FToast? fToast;
  String fileName = "";
  ImageProvider<Object>? networkFile = const NetworkImage("");
  final imageHelper = ImageHelper();
  @override
  void initState() {
    fToast = FToast();
    fToast!.init(context);
    super.initState();
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
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

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
          "Feedback",
          style: TextStyle(
              color: const Color(0xff05240E),
              fontSize: MediaQuery.of(context).size.width * 0.065,
              fontFamily: "RobotoBold"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, top: 8, bottom: 8, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 240,
                child: OverflowBox(
                  minHeight: 290,
                  maxHeight: 290,
                  child: Lottie.asset(
                    "assets/animation/feedback.json",
                  ),
                ),
              ),
              const SizedBox(
                height: 14,
              ),
              const Text(
                "Ease of use",
                style: TextStyle(
                    fontFamily: "RobotoBold",
                    fontSize: 25,
                    color: Color(0xff05240E)),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "How easy was it to navigate through the SFM application?",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _useError = false;
                        _useOne = true;
                        _useTwo = false;
                        _useThree = false;
                        _useFour = false;
                        _useFive = false;
                        _useSelected = true;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: (_useOne ||
                              _useTwo ||
                              _useThree ||
                              _useFour ||
                              _useFive)
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _useError = false;
                        _useTwo = true;
                        _useThree = false;
                        _useFour = false;
                        _useSelected = true;
                        _useFive = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          (_useTwo || _useThree || _useFour || _useFive)
                              ? Colors.green
                              : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _useError = false;
                        _useThree = true;
                        _useFour = false;
                        _useSelected = true;
                        _useFive = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: (_useThree || _useFour || _useFive)
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _useError = false;
                        _useFour = true;
                        _useSelected = true;
                        _useFive = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: (_useFour || _useFive)
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _useError = false;
                        _useSelected = true;
                        _useFive = true;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          _useFive ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              _useError
                  ? const SizedBox(
                      height: 8,
                    )
                  : const SizedBox(),
              _useError
                  ? const Text(
                      "Please select a rating.",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.red),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Impact on food waste reduction",
                style: TextStyle(
                    fontFamily: "RobotoBold",
                    fontSize: 25,
                    color: Color(0xff05240E)),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Do you believe that SFM can effectively reduce food waste?",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        _effError = false;
                        _effOne = true;
                        _effTwo = false;
                        _effThree = false;
                        _effFour = false;
                        _effFive = false;
                        _effSelected = true;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: (_effOne ||
                              _effTwo ||
                              _effThree ||
                              _effFour ||
                              _effFive)
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _effError = false;
                        _effTwo = true;
                        _effThree = false;
                        _effFour = false;
                        _effSelected = true;
                        _effFive = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          (_effTwo || _effThree || _effFour || _effFive)
                              ? Colors.green
                              : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _effError = false;
                        _effThree = true;
                        _effFour = false;
                        _effSelected = true;
                        _effFive = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: (_effThree || _effFour || _effFive)
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _effSelected = true;
                        _effError = false;
                        _effFour = true;
                        _effFive = false;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: (_effFour || _effFive)
                          ? Colors.green
                          : Colors.grey.shade300,
                    ),
                  ),
                  const SizedBox(
                    width: 14,
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        _effError = false;
                        _effSelected = true;
                        _effFive = true;
                      });
                    },
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor:
                          _effFive ? Colors.green : Colors.grey.shade300,
                    ),
                  ),
                ],
              ),
              _effError
                  ? const SizedBox(
                      height: 8,
                    )
                  : const SizedBox(),
              _effError
                  ? const Text(
                      "Please select a rating.",
                      style: TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 12,
                          color: Colors.red),
                    )
                  : const SizedBox(),
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Care to share more?",
                style: TextStyle(
                    fontFamily: "RobotoBold",
                    fontSize: 25,
                    color: Color(0xff05240E)),
              ),
              const SizedBox(
                height: 4,
              ),
              const Text(
                "Please select the features on which you would like to provide feedback.",
                style: TextStyle(
                  fontFamily: "Roboto",
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _login ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _login,
                                    onChanged: (value) {
                                      setState(() {
                                        _login = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Login",
                            style: TextStyle(
                                color: _login ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _register ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                height: 20,
                                width: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _register,
                                    onChanged: (value) {
                                      setState(() {
                                        _register = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Sign-up",
                            style: TextStyle(
                                color: _register ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _profile ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _profile,
                                    onChanged: (value) {
                                      setState(() {
                                        _profile = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Personal Profile",
                            style: TextStyle(
                                color: _profile ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _chat ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _chat,
                                    onChanged: (value) {
                                      setState(() {
                                        _chat = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Chatting",
                            style: TextStyle(
                                color: _chat ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _listing ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _listing,
                                    onChanged: (value) {
                                      setState(() {
                                        _listing = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Food Listing",
                            style: TextStyle(
                                color: _listing ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _request ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _request,
                                    onChanged: (value) {
                                      setState(() {
                                        _request = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Food Request",
                            style: TextStyle(
                                color: _request ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    _other ? Colors.green : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _other,
                                    onChanged: (value) {
                                      setState(() {
                                        _other = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Other Issues",
                            style: TextStyle(
                                color: _other ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Theme(
                            data: ThemeData(
                                unselectedWidgetColor: _suggestion
                                    ? Colors.green
                                    : Colors.black54),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: Checkbox(
                                    shape: const CircleBorder(),
                                    value: _suggestion,
                                    onChanged: (value) {
                                      setState(() {
                                        _suggestion = value!;
                                      });
                                    },
                                    activeColor: Colors.green),
                              ),
                            ),
                          ),
                          Text(
                            "Suggestions",
                            style: TextStyle(
                                color:
                                    _suggestion ? Colors.green : Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              buildFeedbackForm(),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                      onPressed: (() async {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (!_effSelected) {
                          setState(() {
                            _effError = true;
                          });
                        } else if (!_useSelected) {
                          setState(() {
                            _useError = true;
                          });
                        } else {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (_) {
                                return Dialog(
                                  // The background color
                                  backgroundColor: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20),
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

                          final user = FirebaseAuth.instance.currentUser;
                          final userUID = user!.uid;
                          var easeRating = "";
                          if (_useOne) {
                            easeRating = "1";
                          } else if (_useTwo) {
                            easeRating = "2";
                          } else if (_useThree) {
                            easeRating = "3";
                          } else if (_useFour) {
                            easeRating = "4";
                          } else if (_useFive) {
                            easeRating = "5";
                          }
                          var effRating = "";
                          if (_effOne) {
                            effRating = "";
                          } else if (_effTwo) {
                            effRating = "";
                          } else if (_effThree) {
                            effRating = "";
                          } else if (_effFour) {
                            effRating = "";
                          } else if (_effFive) {
                            effRating = "";
                          }
                          final dateTime = getFormattedDate();
                          try {
                            FirebaseDatabase database =
                                FirebaseDatabase.instance;
                            Map<String, String> feedbackData = {
                              "easeRating": easeRating,
                              "effectiveRaing": effRating,
                              "Login Issue": _login.toString(),
                              "Register Issue": _register.toString(),
                              "Profile Issue": _profile.toString(),
                              "Chat Issue": _chat.toString(),
                              "Food Listing": _listing.toString(),
                              "Food Request": _request.toString(),
                              "Other Issue": _other.toString(),
                              "Suggestions": _suggestion.toString(),
                              "Brief": _textController.text,
                            };
                            database
                                .ref()
                                .child("Feedback")
                                .child(userUID)
                                .child(dateTime)
                                .update(feedbackData);
                            if (filePath != "") {
                              await storage.uploadFile(filePath,
                                  "Feedabck/$userUID/$dateTime/feedbackPicture.jpg");
                              final Reference reference =
                                  FirebaseStorage.instance.ref().child(
                                      "Feedabck/$userUID/$dateTime/feedbackPicture.jpg");
                              final path = await reference.getDownloadURL();
                              Map<String, String> sendPath = {
                                "File Path": path
                              };
                              database
                                  .ref()
                                  .child("Feedback")
                                  .child(userUID)
                                  .child(dateTime)
                                  .update(sendPath);
                            }
                            setState(() {
                              _login = false;
                              _register = false;
                              _profile = false;
                              _listing = false;
                              _request = false;
                              _chat = false;
                              _other = false;
                              _suggestion = false;
                              _useOne = false;
                              _useTwo = false;
                              _useThree = false;
                              _useFour = false;
                              _useFive = false;
                              _effOne = false;
                              _effTwo = false;
                              _effThree = false;
                              _effFour = false;
                              _effFive = false;
                              _editing = false;
                              _effError = false;
                              _useError = false;
                              _useSelected = false;
                              _effSelected = false;
                              _textController.text = "";
                              fileName = "";
                              filePath = "";
                            });
                            Navigator.of(context).pop();
                            showToast("Thank you for your feedback");
                          } catch (e) {
                            Navigator.of(context).pop();
                            showToast("Error has occured");
                          }
                        }
                      }),
                      child: const Text("Submit"))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String getFormattedDate() {
    final now = DateTime.now();
    final formatter = DateFormat('dd-MM-yyyy HH:mm:ss');
    return formatter.format(now);
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(children: <Widget>[
        const Text(
          "Choose Profile Photo",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            TextButton.icon(
                onPressed: (() async {
                  // final user = FirebaseAuth.instance.currentUser;
                  // final String userID = user!.uid;

                  final files =
                      await imageHelper.pickImage(source: ImageSource.camera);

                  if (files.isNotEmpty) {
                    final croppedFile = await imageHelper.crop(
                        file: files.first, cropStyle: CropStyle.rectangle);
                    if (croppedFile != null) {
                      setState(() {
                        filePath = croppedFile.path;
                        fileName = files.first.name;
                      });

                      // devetools.log(filePath);
                    }
                  }
                  Navigator.pop(context);
                }),
                icon: const Icon(Icons.camera),
                label: const Text("Camera")),
            TextButton.icon(
                onPressed: (() async {
                  final files = await imageHelper.pickImage();

                  if (files.isNotEmpty) {
                    final croppedFile = await imageHelper.crop(
                        file: files.first, cropStyle: CropStyle.rectangle);
                    if (croppedFile != null) {
                      setState(() {
                        filePath = croppedFile.path;
                        fileName = files.first.name;
                      });
                      // devetools.log(filePath);
                    }
                  }
                  Navigator.pop(context);
                }),
                icon: const Icon(Icons.image),
                label: const Text("Gallery")),
          ],
        )
      ]),
    );
  }

  buildFeedbackForm() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          TextField(
            onTap: () {
              setState(() {
                _editing = true;
              });
            },
            controller: _textController,
            maxLines: 10,
            decoration: const InputDecoration(
              alignLabelWithHint: true,
              labelStyle: TextStyle(fontFamily: "Roboto", fontSize: 14),
              labelText: "Please briefly describe the issue",
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color(0xffe5e5e5),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      width: 1.0,
                      color: _editing
                          ? Colors.green
                          : const Color(
                              0xffa5a5a5,
                            )),
                ),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () async {
                      setState(() {
                        _editing = false;
                      });

                      await showModalBottomSheet(
                        context: context,
                        builder: (context) => bottomSheet(context),
                      );
                    },
                    child: const Icon(
                      Icons.add,
                      color: Color(
                        0xffa5a5a5,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    filePath != "" ? fileName : "Upload screenshot (optional)",
                    style: TextStyle(
                        fontFamily: "Roboto",
                        fontSize: 14,
                        color: filePath != "" ? Colors.black : Colors.grey),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
