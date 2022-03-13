import 'package:bloc/bloc.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/repositories/food_item_repository.dart';

import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent,CheckoutState>{

  FoodItemRepository? foodItemRepository;

  CheckoutBloc() : super(CheckoutInitialState()){
    this.foodItemRepository = FoodItemRepository();
  }

  CheckoutState get initialState => CheckoutInitialState();

  @override
  Stream<CheckoutState> mapEventToState(CheckoutEvent event) async* {
    // TODO: implement mapEventToState
    if (event is CheckoutButtonPressedEvent){
      try {
        yield CheckoutLoading();
        foodItemRepository!.checkout(event.address, event.uname);
        //FoodItem foodItem = FoodItem(iname: event.iname, uname: event.uname, aprice: event.aprice, dprice: event.dprice, sdate: event.sdate, edate: event.edate, useremail: event.useremail);
       // var result =  await this.foodItemRepository!.submitItem(foodItem);
        yield CheckoutSuccessful();
      } on Exception catch (e) {
        // TODO
        yield CheckoutFailed(message: e.toString());
      }
    }
  }
}