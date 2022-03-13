import 'package:bloc/bloc.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';


import 'package:naymat_khaana/blocs/authBloc/auth_event.dart';
import 'package:naymat_khaana/blocs/authBloc/auth_state.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';



class AuthBloc extends Bloc<AuthEvent,AuthState>{

UserRepository? userRepository;

AuthBloc() : super(AuthIntialState()){
  this.userRepository = UserRepository();
}

  AuthState get initialState => AuthIntialState() ;

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    // TODO: implement mapEventToState
    if (event is AppStartedEvent){
      try {
        var isSignedIn = await this.userRepository!.isSignedIn();
        if  (isSignedIn) {
          UserAccount useraccount = (await this.userRepository!.getCurrentUser())!;
          yield AuthSuccessfulState(useraccount: useraccount);
        }
        else {
          yield AuthFailedState();
        }
      } on Exception catch (e) {
        // TODO
        yield AuthFailedState();
      }

    }
  }
}