import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:naymat_khaana/app_classes/user_account.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_event.dart';
import 'package:naymat_khaana/blocs/regBloc/user_reg_state.dart';
import 'package:naymat_khaana/repositories/user_repository.dart';



class UserRegBloc extends Bloc<UserRegEvent,UserRegState>{

  UserRepository? userRepository;

  UserRegBloc() : super(UserRegInitialState()){
    this.userRepository = UserRepository();
  }

  UserRegState get initialState => UserRegInitialState() ;

  @override
  Stream<UserRegState> mapEventToState(UserRegEvent event) async* {
    // TODO: implement mapEventToState
    if (event is SignupButtonPressedEvent){
      try {
        yield UserRegLoading();
        UserAccount useraccount = (await userRepository!.createUser(event.fname, event.lname, event.dob, event.email, event.uname, event.password))!;
        yield UserRegSuccessful(useraccount:useraccount);
      } on Exception catch (e) {
        // TODO
        yield UserRegFailed(message: e.toString());
      }
    }
  }
}