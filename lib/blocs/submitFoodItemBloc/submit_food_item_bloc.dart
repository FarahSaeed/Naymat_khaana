import 'package:bloc/bloc.dart';
import 'package:naymat_khaana/app_classes/food_item.dart';
import 'package:naymat_khaana/blocs/submitFoodItemBloc/submit_food_item_event.dart';
import 'package:naymat_khaana/blocs/submitFoodItemBloc/submit_food_item_state.dart';
import 'package:naymat_khaana/repositories/food_item_repository.dart';




class SubmitFoodItemBloc extends Bloc<SubmitFoodItemEvent,SubmitFoodItemState>{

  FoodItemRepository? foodItemRepository;

  SubmitFoodItemBloc() : super(SubmitFoodInitialState()){
    this.foodItemRepository = FoodItemRepository();
  }

  SubmitFoodItemState get initialState => SubmitFoodInitialState();

  @override
  Stream<SubmitFoodItemState> mapEventToState(SubmitFoodItemEvent event) async* {
    // TODO: implement mapEventToState
    if (event is SubmitButtonPressedEvent){
      try {
        yield SubmissionLoading();
        FoodItem foodItem = FoodItem(iname: event.iname, uname: event.uname, aprice: event.aprice, dprice: event.dprice, sdate: event.sdate, edate: event.edate, useremail: event.useremail, imagename: [event.imagename]);

        var result =  await this.foodItemRepository!.submitItem(foodItem);

        yield SubmissionSuccessful(foodItem: foodItem);
      } on Exception catch (e) {
        // TODO
        yield SubmissionFailed(message: e.toString());
      }
    }
  }
}