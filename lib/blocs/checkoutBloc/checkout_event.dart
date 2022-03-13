
import 'package:equatable/equatable.dart';

abstract class CheckoutEvent extends Equatable {}

// ignore: must_be_immutable
class CheckoutButtonPressedEvent extends CheckoutEvent{

  String uname, address;

  CheckoutButtonPressedEvent({required this.uname, required this.address });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
