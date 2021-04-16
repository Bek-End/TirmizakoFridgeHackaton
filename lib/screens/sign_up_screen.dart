import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/bloc/sign_up_bloc.dart';
import 'package:hackaton_fridge/constants/constants.dart';

class SignUpScreen extends StatefulWidget {
  static final routeName = "/sign-up";
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  Text warningText = Text('');
  bool isLoading = false;
  final List<String> text = [
    "Создать Аккаунт",
    "Имя пользователя",
    "Введите имя пользователя",
    "Электронная почта",
    "Введите вашу почту",
    "Пароль",
    "Введите ваш пароль",
    "Зарегистрироваться",
    "Заполните пустые поля пожалуйста",
    "Неверный формат электронной почты",
    "Пользователь с таким именем уже существует, попробуйте другой вариант",
    "Успешно:)",
    "Пароль слишком короткий, необходимо по крайней мере 8 символов"
  ];

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    signUpBloc.mapEventToState(SignUpInitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return WillPopScope(
      // ignore: missing_return
      onWillPop: () {
        navigatorBloc.mapEventToState(NavigatorPopEvent());
      },
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          body: SingleChildScrollView(
            child: StreamBuilder(
                stream: signUpBloc.subject.stream,
                builder: (context, AsyncSnapshot<SignUpStates> snapshot) {
                  if (snapshot.hasData) {
                    isLoading = false;
                    warningText = Text('');
                    switch (snapshot.data.runtimeType) {
                      case SignUpDisappearWarningTextState:
                        warningText = Text('');
                        break;
                      case SignUpNotUniqueUsernameState:
                        warningText = Text(
                          text[10],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kRed),
                        );
                        break;
                      case SignUpEmptyFieldsState:
                        warningText = Text(
                          text[8],
                          style: TextStyle(color: kRed),
                        );
                        break;
                      case SignUpWrongEmailFormatState:
                        warningText = Text(
                          text[9],
                          style: TextStyle(color: kRed),
                        );
                        break;
                      case SignUpOkState:
                        warningText = Text(
                          text[11],
                          style: TextStyle(color: kGreen),
                        );
                        break;
                      case SignUpShortPasswordState:
                        warningText = Text(
                          text[12],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: kRed),
                        );
                        break;
                      case SignUpLoadingState:
                        isLoading = true;
                        break;
                    }
                    return Container(
                      height: _size.height,
                      width: _size.width,
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: _size.height - _size.height / 1.09),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          arrowBack(),
                          SizedBox(
                            height: 33,
                          ),
                          createAccount(text[0]),
                          SizedBox(
                            height: 16,
                          ),
                          labelText(text[1]),
                          SizedBox(
                            height: 8,
                          ),
                          userNameInput(text[2], usernameController),
                          SizedBox(
                            height: 16,
                          ),
                          labelText(text[5]),
                          SizedBox(
                            height: 8,
                          ),
                          passwordInput(text[6], passwordController),
                          SizedBox(
                            height: 8,
                          ),
                          Align(
                              alignment: Alignment.center, child: warningText),
                          SizedBox(
                            height: 8,
                          ),
                          signUp(text[7], isLoading,
                              username: usernameController.text,
                              password: passwordController.text)
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ),
      ),
    );
  }
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

Widget userNameInput(String hinText, TextEditingController controller) {
  return SizedBox(
    height: 48,
    child: TextFormField(
      controller: controller,
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

Widget arrowBack() {
  return GestureDetector(
    onTap: () {
      navigatorBloc.mapEventToState(NavigatorPopEvent());
    },
    child: Align(
      alignment: Alignment.centerLeft,
      child: SvgPicture.asset("assets/arrow_back.svg"),
    ),
  );
}

Widget createAccount(String text) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
    textAlign: TextAlign.start,
  );
}

Widget emailInput(String text, TextEditingController controller) {
  return SizedBox(
    height: 48,
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.emailAddress,
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
        hintText: text,
      ),
      textInputAction: TextInputAction.next,
    ),
  );
}

Widget passwordInput(String text, TextEditingController controller) {
  return SizedBox(
    height: 48,
    child: TextFormField(
      controller: controller,
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
        hintText: text,
      ),
      textInputAction: TextInputAction.done,
      obscureText: true,
    ),
  );
}

Widget signUp(String text, bool isLoading, {String username, String password}) {
  return RaisedButton(
    elevation: 0,
    onPressed: () {
      signUpBloc.mapEventToState(
          SignUpOnTapEvent(username: username, password: password));
    },
    padding: EdgeInsets.all(12),
    color: Color(0xFFC99573),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Center(
      child: isLoading
          ? Container(
              child: SpinKitCircle(
                size: 20,
                color: kWhite,
              ),
            )
          : Text(
              text,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFFFFFF)),
            ),
    ),
  );
}
