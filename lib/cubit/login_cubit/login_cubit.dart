import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat_app/cubit/login_cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser(
      {required String emailAddress, required String password}) async {
    emit(LoginLoading());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailed(errMessage: 'No user found for this email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailed(
            errMessage: 'Wrong password, please enter the correct password'));
      } else if (e.code == 'invalid-email') {
        emit(LoginFailed(errMessage: 'The email address is not valid.'));
      } else if (e.code == 'user-disabled') {
        emit(LoginFailed(errMessage: 'The user account has been disabled.'));
      } else {
        emit(LoginFailed(errMessage: 'Something went wrong.'));
      }
    }
  }
}
