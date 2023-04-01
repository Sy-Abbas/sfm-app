import 'package:flutter/material.dart';

class AutoSizeContainer extends StatefulWidget {
  final String text;

  AutoSizeContainer({required this.text});

  @override
  _AutoSizeContainerState createState() => _AutoSizeContainerState();
}

class _AutoSizeContainerState extends State<AutoSizeContainer> {
  double _height = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => updateHeight());
  }

  void updateHeight() {
    setState(() {
      _height = MediaQuery.of(context).size.height;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFDBE8D8),
      height: _height,
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 16.0),
      ),
    );
  }
}
