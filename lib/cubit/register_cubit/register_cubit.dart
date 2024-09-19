import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scholar_chat_app/cubit/register_cubit/register_state.dart';

class RegisterCubit extends Cubit<RegisterState>{

  RegisterCubit() : super(RegisterInitial());

  Future<void> registerUser(
      {required String emailAddress, required String password}) async {
    emit(RegisterLoading());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      emit(RegisterSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage: 'The password provided is too weak.'));
      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure(errMessage: 'The email address is not valid.'));
      }
      
      else if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(
            errMessage: 'The account already exists for that email.'));
      } else {
        emit(RegisterFailure(errMessage: 'Something went wrong.'));
      }
    }
  }
        

}