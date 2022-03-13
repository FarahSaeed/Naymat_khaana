import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_state.dart';
import 'package:naymat_khaana/blocs/basketBloc/basket_state.dart';
import 'package:naymat_khaana/repositories/food_item_repository.dart';
import 'basket_event.dart';




class BasketBloc extends Bloc<BasketEvent,BasketState>{

  FoodItemRepository? foodItemRepository;

  BasketBloc() : super(BasketInitialState()){
    this.foodItemRepository = FoodItemRepository();
  }

  BasketState get initialState => BasketInitialState() ;


  @override
  Stream<BasketState> mapEventToState(BasketEvent event) async* {
    // TODO: implement mapEventToState
    if (event is RemoveButtonPressedEvent){
      try {
        yield RemovingItem();
        var result = await this.foodItemRepository!.removeFromBasket(event.id, event.index);
        //yield LoginSuccessful(useraccount:useraccount1);
        //print(a);
        yield RemovingItemSuccessful();

      } on Exception catch (e) {
        // TODO
        yield RemovingItemFailed(message: e.toString());
      }
    }

    else if (event is HomePageStartedEvent){
      try {
        yield BasketCountLoading();
        int result = await this.foodItemRepository!.getBasketCount(event.uname);
        //yield LoginSuccessful(useraccount:useraccount1);
        //print(a);
        yield BasketCountLoaded(count: result);

      } on Exception catch (e) {
        // TODO
        yield BasketCountLoadingFailed(message: e.toString());
      }
    }
  }

  Future<QuerySnapshot> foodItemsListReference(String uname)  {
    return  this.foodItemRepository!.basketfoodItemsListReference(uname);
  }

  //Convert map to goal list
  List<FoodItem> mapToList({required List<DocumentSnapshot> docList}) {
    return  this.foodItemRepository!.mapToList(docList: docList);
  }

  bool isFoodItemsListPopulated() {
    return this.foodItemRepository!.isFoodItemsListEmpty();
  }

  Future<List<FoodItem>> searchfoodItems(String searchStr) {

    return this.foodItemRepository!.searchfoodItems(searchStr);
  }

  void setFoodItems(List<FoodItem> footItemsList) {

    this.foodItemRepository!.foodItemsList = footItemsList; //   searchfoodItems(searchStr);
  }

  List<FoodItem> getFoodItems() {

    return this.foodItemRepository!.foodItemsList; //   searchfoodItems(searchStr);
  }
}