import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/cubit/bloc/auth_bloc.dart';
import 'package:scholar_chat_app/helper/show_snackbar.dart';
import 'package:scholar_chat_app/widgets/custom_button.dart';
import 'package:scholar_chat_app/widgets/custom_text_form_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String emailAddress = '';
  String password = '';
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthLoading) {
            isLoading = true;
          } else if (state is AuthSuccess) {
            isLoading = false;
            Navigator.pushNamed(this.context, '/chatPage',
                arguments: emailAddress);
          } else if (state is AuthFailed) {
            isLoading = false;
            showSnackBar(context, state.errMessage);
          } else {}
        },
        builder: (context, state) {
          return ModalProgressHUD(
            inAsyncCall: isLoading,
            child: Scaffold(
              backgroundColor: kPrimaryColor,
              body: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Header Section
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 50), // Added space at the top
                          Image.asset(kLogo),
                          const SizedBox(height: 15),
                          const Text(
                            'Scholar Chat',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontFamily: 'Pacifico',
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Scrollable Form Section
                    Expanded(
                      flex: 3,
                      child: Form(
                        key: formKey,
                        child: ListView(
                          children: [
                            const Text(
                              'LOGIN',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 15),
                            CustomTextFormField(
                              labelText: 'Email',
                              onChanged: (data) {
                                emailAddress = data;
                              },
                            ),
                            const SizedBox(height: 10),
                            CustomTextFormField(
                              labelText: 'Password',
                              obscureText: true,
                              onChanged: (data) {
                                password = data;
                              },
                            ),
                            const SizedBox(height: 15),
                            CustomButton(
                              buttonText: 'LOGIN',
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<AuthBloc>(context).add(
                                    LoginEvent(
                                      email: emailAddress,
                                      password: password,
                                    ),
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(color: Colors.white),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/registerPage');
                                  },
                                  child: const Text(
                                    'Register',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
