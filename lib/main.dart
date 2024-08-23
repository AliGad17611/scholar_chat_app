import 'package:flutter/material.dart';
import 'package:scholar_chat_app/pages/chat_page.dart';
import 'package:scholar_chat_app/pages/login_page.dart';
import 'package:scholar_chat_app/pages/register_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ScholarChatApp());
}

class ScholarChatApp extends StatelessWidget {
  const ScholarChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        '/loginPage': (context) =>  const LoginPage(),
        '/registerPage': (context) =>  const RegisterPage(),
        '/chatPage': (context) =>   ChatPage(),
      },
      debugShowCheckedModeBanner: false,
      title: 'Scholar Chat App',
      theme: ThemeData.dark(),
      home:  const LoginPage(),
    );
  }
}
