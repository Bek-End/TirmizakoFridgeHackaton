//events
import 'package:flutter/material.dart';
import 'package:hackaton_fridge/repo/repo.dart';
import 'package:hackaton_fridge/screens/add_product_qr_screen.dart';
import 'package:hackaton_fridge/screens/add_product_screen.dart';
import 'package:hackaton_fridge/screens/main_screen.dart';
import 'package:hackaton_fridge/screens/sign_in_screen.dart';
import 'package:hackaton_fridge/screens/sign_up_screen.dart';
import 'package:rxdart/rxdart.dart';

abstract class NavigatorEvents {}

class NavigatorInitialEvent extends NavigatorEvents {
  final GlobalKey<NavigatorState> navigatorKey;
  NavigatorInitialEvent({this.navigatorKey});
}

enum Screens { SIGN_IN, SIGN_UP, MAIN, ADD_SCREEN, ADD_SCREEN_QR }

class NavigatorChangeScreenEvent extends NavigatorEvents {
  final Screens screen;
  NavigatorChangeScreenEvent({this.screen});
}

class NavigatorPopEvent extends NavigatorEvents {}

//states
abstract class NavigatorStates {}

class NavigatorSignIn extends NavigatorStates {}

class NavigatorMain extends NavigatorStates {}

class NavigatorBloc {
  BehaviorSubject<NavigatorStates> _subject = BehaviorSubject();
  BehaviorSubject<NavigatorStates> get subject => _subject;
  GlobalKey<NavigatorState> navigatorKey;
  void mapEventToState(NavigatorEvents event) async {
    switch (event.runtimeType) {
      case NavigatorInitialEvent:
        NavigatorInitialEvent initialEvent = event;
        navigatorKey = initialEvent.navigatorKey;
        bool check = await projectRepo.localSignIn();
        if (check) {
          _subject.sink.add(NavigatorMain());
        } else {
          _subject.sink.add(NavigatorSignIn());
        }
        break;
      case NavigatorChangeScreenEvent:
        NavigatorChangeScreenEvent screenEvent = event;
        switch (screenEvent.screen) {
          case Screens.SIGN_IN:
            navigatorKey.currentState.pushNamed(SignInSCreen.routeName);
            break;
          case Screens.SIGN_UP:
            navigatorKey.currentState.pushNamed(SignUpScreen.routeName);
            break;
          case Screens.MAIN:
            navigatorKey.currentState
                .pushReplacementNamed(MainScreen.routeName);
            break;
          case Screens.ADD_SCREEN:
            navigatorKey.currentState.pushNamed(AddProductScreen.routeName);
            break;
          case Screens.ADD_SCREEN_QR:
            navigatorKey.currentState.pushNamed(AddProductQrScreen.routeName);
            break;
        }
        break;
      case NavigatorPopEvent:
        navigatorKey.currentState.pop();
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final navigatorBloc = NavigatorBloc();
