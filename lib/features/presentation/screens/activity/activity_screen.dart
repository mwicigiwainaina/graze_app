
import 'package:flutter/material.dart';
import 'package:graze_app/core/constants/constants.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text("Activity", style: TextStyle(color: primaryColor),),
      ),
    );
  }
}
