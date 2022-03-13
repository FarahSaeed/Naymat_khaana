import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';

import 'login_event.dart';
import 'login_state.dart';



class LoginBloc extends Bloc<LoginEvent,LoginState>{

  UserRepository? userRepository;

  LoginBloc() : super(LoginInitialState()){
    this.userRepository = UserRepository();
  }

  LoginState get initialState => LoginInitialState() ;

  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    // TODO: implement mapEventToState
    if (event is LoginButtonPressedEvent){
      try {
        yield LoginLoading();
        UserAccount useraccount1 = (await userRepository!.signInUser(event.email, event.password))!;
        yield LoginSuccessful(useraccount:useraccount1);
      } on Exception catch (e) {
        // TODO
        yield LoginFailed(message: e.toString());
      }
    }
    if (event is LoginGoogleSignInEvent){
      try {
        yield LoginLoading();
        UserAccount useraccount1 = (await userRepository!.getUser(event.email))!;
        yield LoginSuccessful(useraccount:useraccount1);
      } on Exception catch (e) {
        // TODO
        yield LoginFailed(message: e.toString());
      }
    }

  }
}