import 'package:animated_drawer/bloc/home_page_bloc.dart';
import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackaton_fridge/constants/constants.dart';
import 'package:hackaton_fridge/bloc/change_home_page_bloc.dart';
import 'package:hackaton_fridge/screens/all_products_screen.dart';
import 'package:hackaton_fridge/repo/repo.dart';

List<Widget> svg = [
  SvgPicture.asset("assets/icon_image.svg"),
  SvgPicture.asset("assets/Vector.svg"),
  SvgPicture.asset("assets/sheet.svg"),
  SvgPicture.asset("assets/calendar.svg"),
  SvgPicture.asset("assets/calculator.svg"),
  SvgPicture.asset("assets/cart.svg"),
  SvgPicture.asset("assets/person.svg"),
  SvgPicture.asset("assets/settings.svg"),
  SvgPicture.asset("assets/exit.svg"),
];

class MainScreen extends StatefulWidget {
  static final routeName = "/main";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    projectRepo.updateDate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedDrawer(
      homePageXValue: 180,
      homePageYValue: 130,
      homePageAngle: -0.17,
      homePageSpeed: 250,
      shadowXValue: 150,
      shadowYValue: 180,
      shadowAngle: -0.23,
      shadowSpeed: 550,
      openIcon: Icon(Icons.menu_open, color: kBlack),
      closeIcon: Icon(Icons.arrow_back_ios, color: kBlack),
      shadowColor: Color(0xFF96542a),
      backgroundGradient: LinearGradient(
        colors: [Color(0xFFC99573), Color(0xFFC99573)],
      ),
      menuPageContent: Padding(
        padding: const EdgeInsets.only(top: 100.0, left: 15),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              avatar("Эмомали Рахмон"),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
              ),
              buildElevatedButton("Главная", svg[0], HomePageStates.HOME),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton("Рецепты", svg[1], HomePageStates.RECEIPTS),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton(
                  "История покупок", svg[2], HomePageStates.HISTORY),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton(
                  "Календарь событий", svg[3], HomePageStates.CALENDAR),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton(
                  "Калькулятор", svg[4], HomePageStates.CALCULATOR),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton("Магазины", svg[5], HomePageStates.SHOP),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton(
                  "Мой профиль", svg[6], HomePageStates.MY_PROFILE),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton("Настройки", svg[7], HomePageStates.SETTINGS),
              Padding(
                padding: EdgeInsets.only(bottom: 5),
              ),
              buildElevatedButton("Выход", svg[8], HomePageStates.EXIT),
            ],
          ),
        ),
      ),
      homePageContent: StreamBuilder(
          stream: changeHomeBloc.subject.stream,
          initialData: HomePageStates.HOME,
          builder: (context, AsyncSnapshot<HomePageStates> snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.data) {
                case HomePageStates.HOME:
                  return AllProducts();
                  break;
                case HomePageStates.RECEIPTS:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Рецепты"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.HISTORY:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("История покупок"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.CALENDAR:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Календарь"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.CALCULATOR:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Калькулятор"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.SHOP:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Покупки"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.MY_PROFILE:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Мой профиль"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.SETTINGS:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Настройки"),
                      ),
                    ),
                  );
                  break;
                case HomePageStates.EXIT:
                  return Container(
                    color: kWhite,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(45),
                        child: Text("Выход"),
                      ),
                    ),
                  );
                  break;
              }
            } else {
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: kWhite,
                padding: EdgeInsets.all(10),
                child: Text("Загрузка..."),
              );
            }
          }),
    ));
  }

  ElevatedButton buildElevatedButton(
      String title, SvgPicture svgPicture, HomePageStates event) {
    return ElevatedButton(
      onPressed: () {
        print(HomePageBloc.isOpen);
        changeHomeBloc.mapEventToState(HomePageEvents.values[event.index]);
      },
      style: ElevatedButton.styleFrom(
          primary: kTrans, padding: EdgeInsets.zero, elevation: 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          svgPicture,
          SizedBox(
            width: 5,
          ),
          Text(
            title,
            style: TextStyle(color: kWhite),
          )
        ],
      ),
    );
  }
}

Widget avatar(String name) {
  return Row(
    children: [
      Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(color: kWhite, shape: BoxShape.circle),
        child: ClipOval(
          child: Image.network(
            "https://www.azernews.az/media/2018/08/15/emomali_rahmon_190318.jpg",
            fit: BoxFit.cover,
          ),
        ),
      ),
      SizedBox(
        width: 5,
      ),
      Container(
        width: 150,
        child: Text(
          name,
          style: TextStyle(
              color: kWhite, fontSize: 20, fontWeight: FontWeight.w600),
        ),
      )
    ],
  );
}
