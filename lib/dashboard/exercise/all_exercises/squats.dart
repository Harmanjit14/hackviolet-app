import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:teachable/teachable.dart';

class Squats extends StatefulWidget {
  const Squats({Key? key}) : super(key: key);

  @override
  _SquatsState createState() => _SquatsState();
}

class _SquatsState extends State<Squats> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Teachable(
        path: "assets/posenet.html",
        results: (res) {
          // Recieve JSON data here

          // Convert json to usable format
          var resp = jsonDecode(res);
          print("The values are $resp");
        },
      ),
    );
  }
}
