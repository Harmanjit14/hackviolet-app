import 'package:baby2body/dashboard/blogs/blogpage.dart';
import 'package:baby2body/dashboard/chatbot/chatbot.dart';
import 'package:baby2body/dashboard/dashboard_data_builder.dart';
import 'package:baby2body/dashboard/exercise/sxercise.dart';
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BottomNavbarState extends GetxController {
  RxInt currentPage = 0.obs;
}

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final _controller = PageController(initialPage: 0);

  final state = Get.put(BottomNavbarState());
  final data = DataBuilder();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>>(
        future: data.dataBuilder(query: 'health AND pregnancy'), // async work
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                var _list = data.articles;
                return PageView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: _controller,
                  children: [
                    const Exercise(),
                    Chatbot(credentials: snapshot.data!['credentials']!),
                    BlogPage(
                      list: _list,
                    ),
                  ],
                );
              }
          }
        },
      ),
      extendBody: true,
      bottomNavigationBar: Obx(
        () => DotNavigationBar(
          backgroundColor: Colors.white.withOpacity(0.5),
          currentIndex: state.currentPage.value,
          onTap: (tap) {
            state.currentPage.value = tap;
            _controller.animateToPage(tap,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeIn);
          },
          items: [
            /// Likes
            DotNavigationBarItem(
              icon: const Icon(Icons.home),
              selectedColor: Colors.pink,
            ),

            /// Search
            DotNavigationBarItem(
              icon: const Icon(Icons.chat),
              selectedColor: Colors.pink,
            ),

            /// Profile
            DotNavigationBarItem(
              icon: const Icon(Icons.live_tv),
              selectedColor: Colors.pink,
            ),
          ],
        ),
      ),
    );
  }
}
