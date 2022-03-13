import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';

abstract class ExploreFoodItemsState extends Equatable {}

class ExploreFoodItemsInitialState extends ExploreFoodItemsState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ExploreFoodItemsLoading extends ExploreFoodItemsState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ExploreFoodItemsLoaded extends ExploreFoodItemsState{
  FoodItem foodItem;

  ExploreFoodItemsLoaded({required this.foodItem});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ExploreFoodItemsLoadingFailed extends ExploreFoodItemsState{
  String message;
  ExploreFoodItemsLoadingFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddingReciever extends ExploreFoodItemsState{
  AddingReciever();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddingRecieverFailed extends ExploreFoodItemsState{
  String message;
  AddingRecieverFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddingRecieverSuccessful extends ExploreFoodItemsState{

  AddingRecieverSuccessful();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
