import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';

abstract class UserRegState extends Equatable {}

class UserRegInitialState extends UserRegState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserRegLoading extends UserRegState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserRegSuccessful extends UserRegState{
  UserAccount useraccount;

  UserRegSuccessful({required this.useraccount});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UserRegFailed extends UserRegState{
  String message;
  UserRegFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
