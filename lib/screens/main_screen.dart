import 'package:animated_drawer/views/animated_drawer.dart';
import 'package:flutter/material.dart';
import 'package:hackaton_fridge/constants/constants.dart';

class MainScreen extends StatelessWidget {
  static final routeName = "/main";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedDrawer(
      homePageXValue: 180,
      homePageYValue: 120,
      homePageAngle: -0.17,
      homePageSpeed: 250,
      shadowXValue: 150,
      shadowYValue: 110,
      shadowAngle: -0.25,
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
              Row(),
              Padding(
                padding: EdgeInsets.only(bottom: 40),
              ),
              Text(
                "Home Screen",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                "Screen 2",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
              ),
              Text(
                "About",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      homePageContent: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.blue[200],
        child: Center(
          child: Image.network(
            "https://user-images.githubusercontent.com/38032118/105316779-2a480980-5be3-11eb-900e-18fcd599493d.png",
            height: MediaQuery.of(context).size.height / 2,
          ),
        ),
      ),
    ));
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
              "https://www.azernews.az/media/2018/08/15/emomali_rahmon_190318.jpg"),
        ),
      ),
      SizedBox(
        width: 5,
      )
    ],
  );
}
