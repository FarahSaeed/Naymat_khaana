import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';

abstract class SubmitFoodItemState extends Equatable {}

class SubmitFoodInitialState extends SubmitFoodItemState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubmissionLoading extends SubmitFoodItemState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubmissionSuccessful extends SubmitFoodItemState{
  FoodItem foodItem;

  SubmissionSuccessful({required this.foodItem});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SubmissionFailed extends SubmitFoodItemState{
  String message;
  SubmissionFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
