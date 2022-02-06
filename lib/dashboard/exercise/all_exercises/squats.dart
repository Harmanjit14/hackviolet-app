import 'dart:convert';
import 'dart:math';

import 'package:baby2body/constants/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:teachable/teachable.dart';

class SquatsState extends GetxController {
  RxBool status = true.obs;
  RxString result = 'Loading Please wait..'.obs;
}

class Squats extends StatefulWidget {
  const Squats({Key? key}) : super(key: key);

  @override
  _SquatsState createState() => _SquatsState();
}

class _SquatsState extends State<Squats> {
  Map<String, dynamic> getMax(var res) {
    num a = res['mid_correct'];
    num a_in = res['mid_incorrect'];
    num b = res['low_correct'];
    num b_in = res['low_incorrect'];

    Map<String, dynamic> map = {};

    if (a > a_in && a > b && a > b_in) {
      map.putIfAbsent('res', () => 'Correct Pose: Keep Going!');
      map.putIfAbsent('status', () => true);
    } else if (b > a_in && b > b && b > b_in) {
      map.putIfAbsent('res', () => 'Correct Pose: Keep Going!');
      map.putIfAbsent('status', () => true);
    } else if (a_in > a && a_in > b && a_in > b_in) {
      map.putIfAbsent(
          'res', () => 'Incorrect: Put you knees inline with your ankles');
      map.putIfAbsent('status', () => false);
    } else if (b_in > a_in && b_in > b && b_in > a) {
      map.putIfAbsent(
          'res', () => 'Incorrect: Put you knees inline with your ankles');
      map.putIfAbsent('status', () => false);
    } else {
      map.putIfAbsent('res', () => 'Adjust the camera');
      map.putIfAbsent('status', () => false);
    }
    print(map);
    return map;
  }

  var state = Get.put(SquatsState());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 10,
                )
              ]),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Teachable(
                  path: "assets/posenet.html",
                  results: (res) {
                    // Recieve JSON data here

                    // Convert json to usable format
                    Map<String, dynamic> resp = jsonDecode(res);

                    Map<String, dynamic> temp = getMax(resp);
                    // print(temp);
                    state.result.value = temp['res'];
                    state.status.value = temp['status'];
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
            child: Obx(
              () => Container(
                child: Text(
                  state.result.value,
                  style: boldtextsyle(size: 20, color: Colors.white),
                ),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(blurRadius: 8, color: Colors.grey)
                    ],
                    color: (state.status.value) ? Colors.green : Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
