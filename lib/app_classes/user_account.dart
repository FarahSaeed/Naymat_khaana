import 'package:firebase_auth/firebase_auth.dart';

class UserAccount {

  User? user;
  String fname;
  String lname;
  String uname;
  String email;
  String dob;
  UserAccount({this.user, required this.fname, required this.lname, required this.uname, required this.email, required this.dob});

}
