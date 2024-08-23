import 'package:flutter/material.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/models/message.dart';
import 'package:scholar_chat_app/widgets/friends_message.dart';
import 'package:scholar_chat_app/widgets/user_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection(kMessagesCollection);
  TextEditingController messageController = TextEditingController();
  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    var userEmail = ModalRoute.of(context)!.settings.arguments;
    return StreamBuilder<QuerySnapshot>(
        stream: messagesCollection
            .orderBy(kCreatedAt, descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Message> messagesList = [];
            for (var message in snapshot.data!.docs) {
              messagesList.add(Message.fromJson(message.data()));
            }
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: kPrimaryColor,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      kLogo,
                      height: 50,
                    ),
                    const SizedBox(width: 10),
                    const Text('Chat'),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                        reverse: true,
                        controller: _controller,
                        itemCount: messagesList.length,
                        itemBuilder: (context, index) {
                          return messagesList[index].senderEmail == userEmail
                              ? UserMessage(
                                  message: messagesList[index],
                                )
                              : FriendsMessage(
                                  message: messagesList[index],
                                );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText: 'Send a message',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.send),
                          onPressed: () {
                            messagesCollection.add({
                              kMessage: messageController.text,
                              kCreatedAt: DateTime.now(),
                              kUserEmail: userEmail,
                            });
                            messageController.clear();
                            _controller.animateTo(
                              0,
                              duration: const Duration(seconds: 1),
                              curve: Curves.easeIn,
                            );
                          },
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          borderSide: BorderSide(
                            color: kPrimaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        });
  }
}
