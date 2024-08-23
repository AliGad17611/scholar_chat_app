import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/helper/show_snackbar.dart';
import 'package:scholar_chat_app/widgets/custom_button.dart';
import 'package:scholar_chat_app/widgets/custom_text_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String emailAddress = '';
  String password = '';

  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                        'REGISTER',
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
                        buttonText: 'REGISTER',
                        onPressed: () async {
                          if (emailAddress.isEmpty || password.isEmpty) {
                            showSnackBar(context, 'Please enter both email and password');
                            return;
                          }

                          if (formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });

                            try {
                              await registerUser();

                              if (!mounted) return;
                              showSnackBar(this.context, 'Registered Successfully');
                              Navigator.pushNamed(this.context, '/chatPage', arguments: emailAddress);
                            } on FirebaseAuthException catch (e) {
                              if (!mounted) return;
                              handleFirebaseAuthError(e);
                            } catch (e) {
                              if (!mounted) return;
                              showSnackBar(this.context, 'Something went wrong');
                            } finally {
                              setState(() {
                                isLoading = false;
                              });
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account?',
                            style: TextStyle(color: Colors.white),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Login',
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
  }

  Future<UserCredential> registerUser() async {
    return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
  }

  void handleFirebaseAuthError(FirebaseAuthException e) {
    if (e.code == 'weak-password') {
      showSnackBar(context, 'The password provided is too weak');
    } else if (e.code == 'invalid-email') {
      showSnackBar(context, 'The email provided is invalid');
    } else if (e.code == 'email-already-in-use') {
      showSnackBar(context, 'The account already exists for that email.');
    } else {
      showSnackBar(context, 'Something went wrong');
    }
  }
}
