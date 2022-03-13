import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';

abstract class CheckoutState extends Equatable {}

class CheckoutInitialState extends CheckoutState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckoutLoading extends CheckoutState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckoutSuccessful extends CheckoutState{
  //FoodItem foodItem;

  CheckoutSuccessful();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckoutFailed extends CheckoutState{
  String message;
  CheckoutFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
