import 'package:bloc/bloc.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';

import 'home_page_event.dart';
import 'home_page_state.dart';



class HomePageBloc extends Bloc<HomePageEvent,HomePageState>{

  UserRepository? userRepository;

  HomePageBloc() : super(LogoutInitialState()){
    this.userRepository = UserRepository();
  }

  HomePageState get initialState => LogoutInitialState() ;

  @override
  Stream<HomePageState> mapEventToState(HomePageEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LogoutButtonPressedEvent){

        await userRepository!.signOut();
        yield LogoutSuccessful();

    }
  }
}