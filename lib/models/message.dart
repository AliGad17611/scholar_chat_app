import 'package:scholar_chat_app/constants.dart';

class Message {
  final String message;
  final String? senderEmail;

  Message({required this.senderEmail, required this.message});
  factory Message.fromJson(json) {
    return Message(message: json[kMessage], senderEmail: json[kUserEmail]);
  }
}
