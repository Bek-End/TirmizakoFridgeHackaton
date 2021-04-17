import 'package:rxdart/rxdart.dart';

enum HomePageEvents {
  HOME,
  RECEIPTS,
  HISTORY,
  CALENDAR,
  CALCULATOR,
  SHOP,
  MY_PROFILE,
  SETTINGS,
  EXIT
}
enum HomePageStates {
  HOME,
  RECEIPTS,
  HISTORY,
  CALENDAR,
  CALCULATOR,
  SHOP,
  MY_PROFILE,
  SETTINGS,
  EXIT
}

class ChangeHomeBloc {
  BehaviorSubject<HomePageStates> _subject = BehaviorSubject();
  BehaviorSubject<HomePageStates> get subject => _subject;

  void mapEventToState(HomePageEvents event) {
    switch (event) {
      case HomePageEvents.HOME:
        _subject.sink.add(HomePageStates.HOME);
        break;
      case HomePageEvents.RECEIPTS:
        _subject.sink.add(HomePageStates.RECEIPTS);
        break;
      case HomePageEvents.HISTORY:
        _subject.sink.add(HomePageStates.HISTORY);
        break;
      case HomePageEvents.CALENDAR:
        _subject.sink.add(HomePageStates.CALENDAR);
        break;
      case HomePageEvents.CALCULATOR:
        _subject.sink.add(HomePageStates.CALCULATOR);
        break;
      case HomePageEvents.SHOP:
        _subject.sink.add(HomePageStates.SHOP);
        break;
      case HomePageEvents.MY_PROFILE:
        _subject.sink.add(HomePageStates.MY_PROFILE);
        break;
      case HomePageEvents.SETTINGS:
        _subject.sink.add(HomePageStates.SETTINGS);
        break;
      case HomePageEvents.EXIT:
        _subject.sink.add(HomePageStates.EXIT);
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final changeHomeBloc = ChangeHomeBloc();
