import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';

abstract class AuthState extends Equatable {}

class AuthIntialState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthSuccessfulState extends AuthState {
  UserAccount? useraccount;

  AuthSuccessfulState({required this.useraccount});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AuthFailedState extends AuthState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}