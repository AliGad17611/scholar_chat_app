import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/models/message.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Message> messagesList = [];
  CollectionReference messagesCollection =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  void sendMessage({required String message,required String userEmail}) {
    try {
      messagesCollection.add({
        kMessage: message,
        kCreatedAt: DateTime.now(),
        kUserEmail: userEmail,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  void getMessages() {
    messagesCollection
        .orderBy(kCreatedAt, descending: true)
        .snapshots()
        .listen((event) {
      messagesList.clear();
      for (var message in event.docs) {
        messagesList.add(Message.fromJson(message.data()));
      }
      emit(ChatSuccess(messagesList: messagesList));
    });
  }
}
