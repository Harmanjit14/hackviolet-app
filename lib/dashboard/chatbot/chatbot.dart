import 'package:baby2body/constants/text.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Messages {
  String? message;
  bool? frombot;

  Messages({required this.message, required this.frombot});
}

class MessageList extends GetxController {
  RxList list = [].obs;
}

class Chatbot extends StatefulWidget {
  Chatbot({Key? key, required this.credentials}) : super(key: key);
  final credentials;

  @override
  State<Chatbot> createState() => _ChatbotState();
}

class _ChatbotState extends State<Chatbot> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();

  final mesgObj = Get.put(MessageList());

  @override
  void initState() {
    final curruser = FirebaseAuth.instance.currentUser!.uid;
    dialogFlowtter = DialogFlowtter(
      credentials: widget.credentials,
      sessionId: '$curruser ${DateTime.now()}',
    );
    super.initState();
  }

  Future<void> createMessage({required Messages? message}) async {
    final QueryInput queryInput = QueryInput(
      text: TextInput(
        text: message!.message ?? 'Hello there',
        languageCode: "en",
      ),
    );
    DetectIntentResponse response = await dialogFlowtter.detectIntent(
      queryInput: queryInput,
    );
    Messages reply = Messages(message: response.text, frombot: true);
    mesgObj.list.add(reply);
    // return response.text ?? 'Error';
  }

  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PageView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _pageController,
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/bot.gif'),
              SizedBox(
                height: size.width / 30,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'This chatbot is backed up by AI which answers all your health/pregnancy related queries',
                  style: mediumtextsyle(size: size.width / 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: size.width / 30,
              ),
              ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.fromLTRB(15, 8, 15, 8)),
                    shape: MaterialStateProperty.all(const StadiumBorder()),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.pink[900]),
                  ),
                  onPressed: () {
                    _pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  },
                  child: Text(
                    'Start Chatting!',
                    style: mediumtextsyle(
                        size: size.width / 20, color: Colors.white),
                  ))
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Obx(
                () => ListView.builder(
                    shrinkWrap: false,
                    reverse: true,
                    itemCount: mesgObj.list.length,
                    itemBuilder: (context, index) {
                      var msg = mesgObj.list[mesgObj.list.length - 1 - index];
                      return SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          child: Align(
                            alignment: (msg.frombot)
                                ? Alignment.centerLeft
                                : Alignment.centerRight,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (msg.frombot!)
                                    ? Colors.grey[700]
                                    : Colors.pink[400],
                              ),
                              child: Text(
                                msg.message,
                                style: mediumtextsyle(
                                    size: size.width / 24, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      );
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(7, 10, 7, 10),
                        child: Row(
                          mainAxisAlignment: (msg.frombot!)
                              ? MainAxisAlignment.start
                              : MainAxisAlignment.end,
                          children: [
                            if (msg.frombot!)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.grey,
                                ),
                                child: Text(
                                  'B',
                                  style: boldtextsyle(
                                      size: size.width / 24,
                                      color: Colors.white),
                                ),
                              ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: (msg.frombot!)
                                    ? Colors.grey
                                    : Colors.pink[400],
                              ),
                              child: Text(
                                msg.message!,
                                maxLines: 20,
                                style: mediumtextsyle(
                                    size: size.width / 24, color: Colors.white),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            if (!msg.frombot!)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.pink[400],
                                ),
                                child: Text(
                                  'Y',
                                  style: boldtextsyle(
                                      size: size.width / 24,
                                      color: Colors.white),
                                ),
                              ),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.width / 5,
                  width: size.width / 1.25,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(13, 8, 13, 8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(blurRadius: 10, color: Colors.grey)
                          ]),
                      child: TextField(
                        controller: _controller,
                        style: mediumtextsyle(size: size.width / 24),
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Type to chat...',
                            hintStyle: mediumtextsyle(size: size.width / 24)),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: FloatingActionButton(
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        Messages temp =
                            Messages(message: _controller.text, frombot: false);
                        mesgObj.list.add(temp);
                        await createMessage(message: temp);
                        _controller.clear();
                      }
                    },
                    child: const Icon(Icons.send),
                  ),
                )
              ],
            ),
            SizedBox(
              height: size.height / 10,
            )
          ],
        ),
      ],
    );
  }
}
