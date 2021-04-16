import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/repo/repo.dart';
import 'package:rxdart/rxdart.dart';

abstract class SignInEvents {}

class SignIninitialEvent extends SignInEvents {}

class SignInOnTapEvent extends SignInEvents {
  final String username;
  final String password;
  SignInOnTapEvent({this.username, this.password});
}

abstract class SignInStates {}

class SignInInitialState extends SignInStates {}

class SignInFillEmptyFieldsState extends SignInStates {}

class SignInWrongCredentialsState extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInOkState extends SignInStates {}

class SignInDisAppearWarningTextState extends SignInStates {}

class SignInBloc {
  BehaviorSubject<SignInStates> _subject = BehaviorSubject<SignInStates>();
  BehaviorSubject<SignInStates> get subject => _subject;

  void mapEventToState(SignInEvents event) async {
    switch (event.runtimeType) {
      case SignIninitialEvent:
        _subject.sink.add(SignInInitialState());
        break;
      case SignInOnTapEvent:
        SignInOnTapEvent tapEvent = event;
        if (tapEvent.username.isEmpty || tapEvent.password.isEmpty) {
          _subject.sink.add(SignInFillEmptyFieldsState());
          await Future.delayed(Duration(seconds: 1));
          _subject.sink.add(SignInDisAppearWarningTextState());
        } else {
          _subject.sink.add(SignInLoadingState());
          String loginResponse =
              await projectRepo.signIn(tapEvent.username, tapEvent.password);
          if (loginResponse != 'Error') {
            _subject.sink.add(SignInOkState());
            await Future.delayed(Duration(seconds: 1));
            navigatorBloc.mapEventToState(
                NavigatorChangeScreenEvent(screen: Screens.MAIN));
          } else {
            _subject.sink.add(SignInWrongCredentialsState());
            await Future.delayed(Duration(seconds: 1));
            _subject.sink.add(SignInDisAppearWarningTextState());
          }
        }
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final signInBloc = SignInBloc();
