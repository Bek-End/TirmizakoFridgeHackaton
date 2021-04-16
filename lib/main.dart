import 'package:flutter/material.dart';
import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/constants/constants.dart';
import 'package:hackaton_fridge/screens/main_screen.dart';
import 'package:hackaton_fridge/screens/sign_in_screen.dart';
import 'package:hackaton_fridge/screens/sign_up_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    navigatorBloc
        .mapEventToState(NavigatorInitialEvent(navigatorKey: _navigatorKey));
  }

  @override
  Widget build(BuildContext context) {
    bool isSignedIn = true;
    return StreamBuilder(
        stream: navigatorBloc.subject.stream,
        builder: (context, AsyncSnapshot<NavigatorStates> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.runtimeType) {
              case NavigatorSignIn:
                isSignedIn = false;
                break;
            }
            return MaterialApp(
              title: 'IceBox',
              theme: ThemeData(
                fontFamily: 'Gilroy',
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              navigatorKey: _navigatorKey,
              routes: {
                SignInSCreen.routeName: (context) => SignInSCreen(),
                SignUpScreen.routeName: (context) => SignUpScreen(),
                MainScreen.routeName: (context) => MainScreen()
              },
              home: isSignedIn ? MainScreen() : SignInSCreen(),
            );
          } else {
            return MaterialApp(
              home: Scaffold(
                backgroundColor: kWhite,
                body: Center(
                  child: Text("Загрузка..."),
                ),
              ),
            );
          }
        });
  }
}
