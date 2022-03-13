import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';

abstract class BasketState extends Equatable {}

class BasketInitialState extends BasketState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BasketItemsLoading extends BasketState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BasketItemsLoaded extends BasketState{
  FoodItem foodItem;

  BasketItemsLoaded({required this.foodItem});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BasketItemsLoadingFailed extends BasketState{
  String message;
  BasketItemsLoadingFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}



class RemovingItem extends BasketState{
  RemovingItem();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RemovingItemFailed extends BasketState{
  String message;
  RemovingItemFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class RemovingItemSuccessful extends BasketState{

  RemovingItemSuccessful();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BasketCountLoading extends BasketState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BasketCountLoaded extends BasketState{
  int count;
  BasketCountLoaded({required this.count});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class BasketCountLoadingFailed extends BasketState{
  String message;
  BasketCountLoadingFailed({required this.message});
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
