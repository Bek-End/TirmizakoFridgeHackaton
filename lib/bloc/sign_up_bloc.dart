import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/repo/repo.dart';
import 'package:rxdart/rxdart.dart';

//events
abstract class SignUpEvents {}

class SignUpInitialEvent extends SignUpEvents {}

class SignUpOnTapEvent extends SignUpEvents {
  final String username;
  final String password;
  SignUpOnTapEvent({this.username, this.password});
}

//states
abstract class SignUpStates {}

class SignUpInitialState extends SignUpStates {}

class SignUpEmptyFieldsState extends SignUpStates {}

class SignUpNotUniqueUsernameState extends SignUpStates {}

class SignUpWrongEmailFormatState extends SignUpStates {}

class SignUpShortPasswordState extends SignUpStates {}

class SignUpOkState extends SignUpStates {}

class SignUpDisappearWarningTextState extends SignUpStates {}

class SignUpLoadingState extends SignUpStates {}

//bloc
class SignUpBloc {
  BehaviorSubject<SignUpStates> _subject = BehaviorSubject<SignUpStates>();
  BehaviorSubject<SignUpStates> get subject => _subject;

  void mapEventToState(SignUpEvents event) async {
    switch (event.runtimeType) {
      case SignUpInitialEvent:
        _subject.sink.add(SignUpInitialState());
        break;
      case SignUpOnTapEvent:
        SignUpOnTapEvent tapEvent = event;
        if (tapEvent.password.isEmpty || tapEvent.username.isEmpty) {
          _subject.sink.add(SignUpEmptyFieldsState());
          await Future.delayed(Duration(seconds: 1));
          _subject.sink.add(SignUpDisappearWarningTextState());
        } else if (tapEvent.password.length < 8) {
          _subject.sink.add(SignUpShortPasswordState());
          await Future.delayed(Duration(seconds: 1));
          _subject.sink.add(SignUpDisappearWarningTextState());
        } else {
          _subject.sink.add(SignUpLoadingState());
          bool signUpResponse =
              await projectRepo.signUp(tapEvent.username, tapEvent.password);
          if (!signUpResponse) {
            _subject.sink.add(SignUpNotUniqueUsernameState());
            await Future.delayed(Duration(seconds: 1));
            _subject.sink.add(SignUpDisappearWarningTextState());
          } else {
            String loginResponse =
                await projectRepo.signIn(tapEvent.username, tapEvent.password);
            if (loginResponse != "Error") {
              await Future.delayed(Duration(seconds: 1));
              _subject.sink.add(SignUpOkState());
            } else {
              _subject.sink.add(SignUpNotUniqueUsernameState());
              await Future.delayed(Duration(seconds: 1));
              _subject.sink.add(SignUpDisappearWarningTextState());
              navigatorBloc.mapEventToState(NavigatorPopEvent());
              navigatorBloc.mapEventToState(
                  NavigatorChangeScreenEvent(screen: Screens.MAIN));
            }
          }
        }
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final signUpBloc = SignUpBloc();
