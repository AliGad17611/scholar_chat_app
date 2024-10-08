import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat_app/constants.dart';
import 'package:scholar_chat_app/cubit/register_cubit/register_cubit.dart';
import 'package:scholar_chat_app/cubit/register_cubit/register_state.dart';
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
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state is RegisterLoading) {
            isLoading = true;
          } else if (state is RegisterSuccess) {
            isLoading = false;
            Navigator.pushNamed(this.context, '/chatPage', arguments: emailAddress);
          } else if (state is RegisterFailure) {
            isLoading = false;
            showSnackBar(context, state.errMessage);
          } else {
            isLoading = false;
          }
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
                                  showSnackBar(context,
                                      'Please enter both email and password');
                                  return;
                                }

                                if (formKey.currentState!.validate()) {
                                  BlocProvider.of<RegisterCubit>(context)
                                      .registerUser(
                                          emailAddress: emailAddress,
                                          password: password);
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
        },
      ),
    );
  }
}
