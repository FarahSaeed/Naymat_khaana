
import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

// ignore: must_be_immutable
class LoginButtonPressedEvent extends LoginEvent{

  String email, password;

  LoginButtonPressedEvent({required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class LoginGoogleSignInEvent extends LoginEvent{

  String email;

  LoginGoogleSignInEvent({required this.email});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoginGoogleSignOutEvent extends LoginEvent{
  LoginGoogleSignOutEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitialGoogleSignOutEvent extends LoginEvent{
  InitialGoogleSignOutEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}