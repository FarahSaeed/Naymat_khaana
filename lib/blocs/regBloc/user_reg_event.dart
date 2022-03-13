
import 'package:equatable/equatable.dart';

abstract class UserRegEvent extends Equatable {}

// ignore: must_be_immutable
class SignupButtonPressedEvent extends UserRegEvent{

  String fname, lname, dob, email, uname, password;


  SignupButtonPressedEvent({required this.fname, required this.lname, required this.dob, required this.email, required this.uname, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}