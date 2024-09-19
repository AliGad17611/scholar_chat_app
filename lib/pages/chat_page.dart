import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/cubit/chat_cubit/chat_cubit.dart';
import 'package:scholar_chat_app/models/message.dart';
import 'package:scholar_chat_app/widgets/friends_message.dart';
import 'package:scholar_chat_app/widgets/user_message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();

  final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    dynamic userEmail = ModalRoute.of(context)!.settings.arguments;

    return BlocProvider(
      create: (context) {
        var chatCubit = ChatCubit();
        chatCubit.getMessages();
        return chatCubit;
      },
      child: Scaffold(
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
        body: BlocBuilder<ChatCubit, ChatState>(
          builder: (context, state) {
            List<Message> messagesList =
                BlocProvider.of<ChatCubit>(context).messagesList;
            return Column(
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
                          BlocProvider.of<ChatCubit>(context).sendMessage(
                            message: messageController.text,
                            userEmail: userEmail,
                          );
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
            );
          },
        ),
      ),
    );
  }
}
