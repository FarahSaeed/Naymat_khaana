
import 'package:equatable/equatable.dart';

abstract class SubmitFoodItemEvent extends Equatable {}

// ignore: must_be_immutable
class SubmitButtonPressedEvent extends SubmitFoodItemEvent{

  String iname, uname, aprice, dprice, sdate, edate, useremail;
  List<String> imagename;

  SubmitButtonPressedEvent({required this.iname, required this.uname, required this.aprice, required this.dprice, required this.sdate, required this.edate, required this.useremail, required this.imagename });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
