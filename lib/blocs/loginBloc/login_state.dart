import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';

abstract class LoginState extends Equatable {}

class LoginInitialState extends LoginState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginLoading extends LoginState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginSuccessful extends LoginState{
  UserAccount useraccount;

  LoginSuccessful({required this.useraccount});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginFailed extends LoginState{
  String message;
  LoginFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
