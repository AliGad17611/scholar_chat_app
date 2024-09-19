class LoginState {}

class LoginInitial extends LoginState {}  

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailed extends LoginState {
  String errMessage ;

  LoginFailed({required this.errMessage});
}