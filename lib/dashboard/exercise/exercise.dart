import 'package:baby2body/dashboard/exercise/all_exercises/squats.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Exercise extends StatelessWidget {
  const Exercise({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ElevatedButton(
            onPressed: () {
              Get.to(() => const Squats());
            },
            child: Text('press me'))
      ],
    );
  }
}
