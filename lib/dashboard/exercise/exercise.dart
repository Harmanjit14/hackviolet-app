import 'package:baby2body/constants/text.dart';
import 'package:baby2body/dashboard/exercise/all_exercises/squats.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';

class Exercise extends StatelessWidget {
  Exercise({Key? key, required this.map}) : super(key: key);
  final Map<int, int> map;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListView(
      shrinkWrap: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            "Activity Space",
            style: boldtextsyle(size: size.width / 10, shadow: true),
          ),
        ),
        SizedBox(
          height: size.width / 50,
        ),
        CalenderBuilder(map: map),
        SizedBox(
          height: size.width / 70,
        ),
        const Divider(),
        SizedBox(
          height: size.width / 100,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 20, 0),
          child: Text(
            "Exercises for you!",
            style: mediumtextsyle(size: size.width / 17),
          ),
        ),
        ExerciseGrid(),
      ],
    );
  }
}

class CalenderBuilder extends StatelessWidget {
  const CalenderBuilder({Key? key, required this.map}) : super(key: key);
  final Map<int, int> map;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2022, 1, 1),
          lastDay: DateTime.utc(2025, 1, 1),
          focusedDay: DateTime.now(),
          holidayPredicate: (day) {
            if (map.containsKey(day.day)) {
              if (map[day.day] == day.month) {
                return true;
              }
            }
            return false;
          },
          headerVisible: false,
          calendarBuilders: CalendarBuilders(
            holidayBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: Colors.green, shape: BoxShape.circle),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return Center(
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: const BoxDecoration(
                      color: Colors.pink, shape: BoxShape.circle),
                  child: Text(
                    day.day.toString(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Row(
            children: [
              Container(
                child: const SizedBox(
                  width: 13,
                  height: 13,
                ),
                decoration: const BoxDecoration(
                    color: Colors.green, shape: BoxShape.circle),
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                'You were active these days',
                style: mediumtextsyle(size: 13),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class ExerciseGrid extends StatelessWidget {
  ExerciseGrid({Key? key}) : super(key: key);

  final List<String> tags = ['Squats', 'Lunges', 'Push-Ups'];
  final List<String> video = ['Squats', 'Lunges', 'Push-Ups'];
  final List<String> assets = [
    'assets/squats.gif',
    'assets/lunges.gif',
    'assets/pushups.gif'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 5,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                  onTap: () async {
                    if (index == 0) {
                      FirebaseFirestore.instance
                          .collection(
                              FirebaseAuth.instance.currentUser!.uid.toString())
                          .add({
                        'day': DateTime.now().day,
                        'month': DateTime.now().month,
                      });
                      Get.to(() => const Squats());
                    } else {
                      Get.snackbar(
                          'Error', 'Currently this service is not available.');
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    blurRadius: 8,
                                    color: Colors.grey,
                                  )
                                ]),
                            child: Image.asset('assets/squats.gif'),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          tags[index],
                          style: boldtextsyle(size: 15),
                        )
                      ],
                    ),
                  ));
            }),
      ),
    );
  }
}
