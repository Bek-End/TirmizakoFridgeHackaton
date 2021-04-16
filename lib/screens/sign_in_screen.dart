import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/bloc/sign_in_bloc.dart';
import 'package:hackaton_fridge/constants/constants.dart';

class SignInSCreen extends StatefulWidget {
  static final routeName = "/sign-in";
  @override
  _SignInSCreenState createState() => _SignInSCreenState();
}

class _SignInSCreenState extends State<SignInSCreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<String> text = [
    "Войти",
    "Имя пользователя",
    "Введите ваше имя пользователя",
    "Пароль",
    "Введите ваш пароль",
    "Войти",
    "Зарегистрироваться",
    "Забыли пароль?",
    "Войти с помощью Google",
    "Заполните пустые поля пожалуйста",
    "Неверно введены данные",
    "Успешно:)"
  ];
  @override
  void initState() {
    super.initState();
    signInBloc.mapEventToState(SignIninitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    Text warningText;
    bool isLoading = false;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder(
              stream: signInBloc.subject.stream,
              builder: (context, AsyncSnapshot<SignInStates> snapshot) {
                if (snapshot.hasData) {
                  warningText = Text('');
                  isLoading = false;
                  switch (snapshot.data.runtimeType) {
                    case SignInFillEmptyFieldsState:
                      warningText = Text(
                        text[9],
                        style: TextStyle(color: kRed),
                      );
                      break;
                    case SignInWrongCredentialsState:
                      warningText = Text(
                        text[10],
                        style: TextStyle(color: kRed),
                      );
                      break;
                    case SignInLoadingState:
                      isLoading = true;
                      break;
                    case SignInOkState:
                      warningText = Text(
                        text[11],
                        style: TextStyle(color: kGreen),
                      );
                      break;
                    case SignInDisAppearWarningTextState:
                      warningText = Text('');
                      break;
                  }
                  return Container(
                    height: _size.height,
                    width: _size.width,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: _size.height - _size.height / 1.2,
                            ),
                            Text(
                              text[0],
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            labelText(text[1]),
                            SizedBox(
                              height: 8,
                            ),
                            emailInput(text[2], usernameController),
                            SizedBox(
                              height: 16,
                            ),
                            labelText(text[3]),
                            SizedBox(
                              height: 8,
                            ),
                            passwordInput(text[4], passwordController),
                            SizedBox(
                              height: 8,
                            ),
                            warningText,
                            SizedBox(
                              height: 8,
                            ),
                            signIn(text[5], usernameController.text,
                                passwordController.text, isLoading),
                            SizedBox(
                              height: 8,
                            ),
                            signUp(text[6]),
                            SizedBox(
                              height: 16,
                            ),
                            forgotPassword(text[7]),
                          ],
                        ),
                        googleSignIn(text[8])
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              }),
        ),
      ),
    );
  }
}

Widget emailInput(String hinText, TextEditingController usernameController) {
  return SizedBox(
    height: 48,
    child: TextFormField(
      controller: usernameController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 12),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFFC99573),
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFACAFBD))),
        hintText: hinText,
      ),
      textInputAction: TextInputAction.next,
    ),
  );
}

Widget passwordInput(
    String hintText, TextEditingController passwordController) {
  return SizedBox(
    height: 48,
    child: TextFormField(
      controller: passwordController,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 12),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Color(0xFFC99573),
            )),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Color(0xFFACAFBD))),
        hintText: hintText,
      ),
      textInputAction: TextInputAction.done,
      obscureText: true,
    ),
  );
}

Widget signIn(String text, String username, String password, bool isLoading) {
  return RaisedButton(
    elevation: 0,
    onPressed: () {
      signInBloc.mapEventToState(
          SignInOnTapEvent(username: username, password: password));
    },
    color: Color(0xFFC99573),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Container(
      padding: EdgeInsets.all(12),
      child: Center(
        child: isLoading
            ? SpinKitCircle(
                color: kWhite,
                size: 20,
              )
            : Text(
                text,
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFFFFFFF)),
              ),
      ),
    ),
  );
}

Widget signUp(String text) {
  return RaisedButton(
      elevation: 0,
      onPressed: () {
        navigatorBloc.mapEventToState(
            NavigatorChangeScreenEvent(screen: Screens.SIGN_UP));
      },
      padding: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
            color: Color(0xFFFFFFFF),
            border: Border.all(color: Color(0xFFC99573), width: 1),
            borderRadius: BorderRadius.circular(16)),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC99573),
            ),
          ),
        ),
      ));
}

Widget forgotPassword(String text) {
  return TextButton(
      onPressed: () {
        // switchSCreenBloc.mapEventToState(SwitchScreenEvents.FORGOT_PASSWORD);
      },
      child: Text(
        text,
        style: TextStyle(color: Color(0xFF6860AF)),
      ));
}

Widget googleSignIn(String text) {
  return RaisedButton(
    elevation: 0,
    onPressed: () {},
    padding: EdgeInsets.all(12),
    color: Color(0xFFE9F5FF),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset("assets/google.svg"),
          Text(
            text,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Color(0xFF000000)),
          ),
        ],
      ),
    ),
  );
}

Widget labelText(String label) {
  return Align(
    alignment: Alignment.centerLeft,
    child: Text(
      label,
      style: TextStyle(
        color: Color(0xFF000000),
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.start,
    ),
  );
}
