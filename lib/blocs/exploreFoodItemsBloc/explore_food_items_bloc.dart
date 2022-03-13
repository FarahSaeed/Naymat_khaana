import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/blocs/exploreFoodItemsBloc/explore_food_items_state.dart';
import 'package:naymat_khaana/repositories/food_item_repository.dart';
import 'explore_food_items_event.dart';




class ExploreFoodItemsBloc extends Bloc<ExploreFoodItemsEvent,ExploreFoodItemsState>{

  FoodItemRepository? foodItemRepository;

  ExploreFoodItemsBloc() : super(ExploreFoodItemsInitialState()){
    this.foodItemRepository = FoodItemRepository();
  }

  ExploreFoodItemsState get initialState => ExploreFoodItemsInitialState() ;


  @override
  Stream<ExploreFoodItemsState> mapEventToState(ExploreFoodItemsEvent event) async* {
    // TODO: implement mapEventToState
    if (event is AddButtonPressedEvent){
      try {
        yield AddingReciever();
        var result = await this.foodItemRepository!.addReciever(event.id, event.recieveruname);
        //yield LoginSuccessful(useraccount:useraccount1);
        //print(a);
        yield AddingRecieverSuccessful();

      } on Exception catch (e) {
        // TODO
        yield AddingRecieverFailed(message: e.toString());
      }
    }
  }

  Future<QuerySnapshot> foodItemsListReference()  {
    return  this.foodItemRepository!.foodItemsListReference();
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