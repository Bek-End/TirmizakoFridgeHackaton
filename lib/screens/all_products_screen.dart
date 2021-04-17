import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/constants/constants.dart';
import 'package:hackaton_fridge/bloc/products_bloc.dart';
import 'package:hackaton_fridge/models/products_model.dart';

final String mainUrl = "https://tirmizako-fridge-hackaton.herokuapp.com";
bool all = true, fresh = false, expired = false;
int currentIndex = 0;
bool isInCart = false;

class AllProducts extends StatefulWidget {
  @override
  _AllProductsState createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts> {
  Products products;
  @override
  void initState() {
    super.initState();
    productBloc.mapEventToState(InitialEvent());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
        stream: productBloc.subject.stream,
        builder: (context, AsyncSnapshot<ProductState> snapshot) {
          if (snapshot.hasData) {
            switch (snapshot.data.runtimeType) {
              case InitialState:
                InitialState initialState = snapshot.data;
                products = initialState.products;
                print(products.product[0].quantity);
                break;
              case ProductChangeBottomNavBarState:
                ProductChangeBottomNavBarState barState = snapshot.data;
                currentIndex = barState.index;
                break;
              case ProductCartState:
                ProductCartState cartState = snapshot.data;
                products = cartState.products;
                break;
              case ProductIsAlreadyInCart:
                isInCart = true;
                break;
              case ProductRemoveAlert:
                isInCart = false;
                break;
              case ProductOnBtnTapState:
                ProductOnBtnTapState tapState = snapshot.data;
                switch (tapState.button) {
                  case Buttons.ALL:
                    all = true;
                    fresh = false;
                    expired = false;
                    products = tapState.products;
                    break;
                  case Buttons.FRESH:
                    all = false;
                    fresh = true;
                    expired = false;
                    products = tapState.products;
                    break;
                  case Buttons.EXPIRED:
                    all = false;
                    fresh = false;
                    expired = true;
                    products = tapState.products;
                    break;
                }
                break;
            }
            return Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: true,
                backgroundColor: kWhite,
                title: Text(
                  currentIndex == 3 ? "Покупки" : "Все продукты",
                  style: TextStyle(color: kBlack),
                ),
                actions: [
                  IconButton(
                      icon: Icon(
                        Icons.search_outlined,
                        color: kBlack,
                      ),
                      onPressed: () {})
                ],
              ),
              body: Container(
                height: size.height,
                width: size.width,
                child: ListView(
                  padding: EdgeInsets.only(top: 16, left: 16),
                  children: [
                        buildCategories("Все", "Свежие", "Испорченные", all,
                            fresh, expired, size.width),
                        SizedBox(
                          height: 16,
                        ),
                      ] +
                      checkCategory(products),
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                  showUnselectedLabels: true,
                  unselectedItemColor: kGreyText,
                  selectedItemColor: kBlack,
                  selectedFontSize: 12,
                  onTap: (value) {
                    productBloc.mapEventToState(
                        PrductChangeBottomNavBarEvent(navBar: value));
                  },
                  currentIndex: currentIndex,
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/Book-mark.svg",
                          color: kGreyText,
                        ),
                        activeIcon: SvgPicture.asset(
                          "assets/Book-mark.svg",
                          color: kBrown,
                        ),
                        label: "Продукты"),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/qr.svg",
                        ),
                        activeIcon: SvgPicture.asset(
                          "assets/qr.svg",
                          color: kBrown,
                        ),
                        label: "Добавить"),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/qr-.svg",
                        ),
                        activeIcon: SvgPicture.asset(
                          "assets/qr-.svg",
                          color: kBrown,
                        ),
                        label: "Удалить"),
                    BottomNavigationBarItem(
                        icon: SvgPicture.asset(
                          "assets/cart-.svg",
                          color: kGreyText,
                        ),
                        activeIcon: SvgPicture.asset(
                          "assets/cart-.svg",
                          color: kBrown,
                        ),
                        label: "Покупка")
                  ]),
              floatingActionButton: FloatingActionButton(
                backgroundColor: kBrown,
                child: SvgPicture.asset("assets/add.svg"),
                onPressed: () {
                  navigatorBloc.mapEventToState(
                      NavigatorChangeScreenEvent(screen: Screens.ADD_SCREEN));
                },
              ),
            );
          } else {
            return Container();
          }
        });
  }

  Widget buildProduct(Product product) {
    return Slidable(
      actionExtentRatio: 0.25,
      actionPane: SlidableDrawerActionPane(),
      actions: [
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
                backgroundColor: Color(0xFFFFFFFF),
                context: context,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                builder: (context) => Wrap(
                      children: [
                        Container(
                          padding: EdgeInsets.all(17),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Удалить продукт",
                                style: TextStyle(
                                    fontSize: 21, fontWeight: FontWeight.bold),
                              ),
                              Container(
                                padding: EdgeInsets.only(right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          alignment: Alignment.center,
                                          height: 76,
                                          width: 76,
                                          child: ClipRRect(
                                            child: Image.network(
                                              mainUrl + product.image,
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Column(
                                          children: [
                                            Text(product.name,
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black)),
                                            Text(product.category,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Color(0xFFAAAAAA)))
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(product.quantity.toString(),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black)),
                                            SizedBox(
                                              width: 2,
                                            ),
                                            Text(product.unit,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.black))
                                          ],
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(product.expireDate,
                                            style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFAAAAAA)))
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Center(child: Text("Уменшить количество на ")),
                              SizedBox(
                                height: 7,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                      flex: 3,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                                color: kBrown, fontSize: 25),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: kWhite,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      )),
                                  Expanded(child: Center(child: Text("1"))),
                                  Expanded(
                                      flex: 3,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10, bottom: 10),
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                                color: kBrown, fontSize: 25),
                                          ),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                            primary: kWhite,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10))),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 7,
                              ),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "Сохранить",
                                      style: TextStyle(
                                          color: kWhite,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: kBrown,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    productBloc.mapEventToState(
                                        DeleteEvent(product: product));
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: Text(
                                      "Удалить всё",
                                      style: TextStyle(
                                          color: kWhite,
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                      primary: kRed,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ));
          },
          child: Container(
            alignment: Alignment.center,
            color: kRed,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.delete,
                  color: kWhite,
                ),
                Text(
                  "Удалить",
                  style: TextStyle(color: kWhite),
                ),
              ],
            ),
          ),
        ),
        currentIndex == 3
            ? null
            : GestureDetector(
                onTap: () {
                  productBloc
                      .mapEventToState(ProductAddToCartEvent(product: product));
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(right: 10),
                  color: isInCart ? kYellow : kGreen,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart,
                        color: kWhite,
                      ),
                      Text(
                        isInCart ? "Продукт уже в корзине" : "В покупки",
                        style: TextStyle(color: kWhite),
                      ),
                    ],
                  ),
                ),
              )
      ],
      child: Container(
        padding: EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
            border:
                Border(top: BorderSide(color: Colors.black.withOpacity(0.08)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  alignment: Alignment.center,
                  height: 76,
                  width: 76,
                  child: ClipRRect(
                    child: Image.network(
                      mainUrl + product.image,
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Column(
                  children: [
                    Text(product.name,
                        style: TextStyle(fontSize: 17, color: Colors.black)),
                    Text(product.category,
                        style:
                            TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)))
                  ],
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  children: [
                    Text(product.quantity.toString(),
                        style: TextStyle(fontSize: 13, color: Colors.black)),
                    SizedBox(
                      width: 2,
                    ),
                    Text(product.unit,
                        style: TextStyle(fontSize: 13, color: Colors.black))
                  ],
                ),
                SizedBox(
                  height: 7,
                ),
                Text(product.expireDate,
                    style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)))
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> checkCategory(Products products) {
    List<Widget> prods = [];
    for (int i = 0; i < products.product.length; i++) {
      prods.add(buildProduct(products.product[i]));
    }
    return prods;
  }
}

Widget buildCategories(String all, String fresh, String exp, bool a, bool f,
    bool e, double width) {
  return Container(
    width: width,
    height: 40,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(3),
      children: [
        buildButton(all, a, Buttons.ALL),
        SizedBox(
          width: 10,
        ),
        buildButton(fresh, f, Buttons.FRESH),
        SizedBox(
          width: 10,
        ),
        buildButton(exp, e, Buttons.EXPIRED)
      ],
    ),
  );
}

Widget buildButton(String text, bool isEnabled, Buttons button) {
  return ElevatedButton(
    onPressed: () {
      switch (button) {
        case Buttons.ALL:
          productBloc
              .mapEventToState(ProductOnBtnTapEvent(button: Buttons.ALL));
          print("all");
          break;
        case Buttons.FRESH:
          productBloc
              .mapEventToState(ProductOnBtnTapEvent(button: Buttons.FRESH));
          print("fresh");
          break;
        case Buttons.EXPIRED:
          productBloc
              .mapEventToState(ProductOnBtnTapEvent(button: Buttons.EXPIRED));
          break;
      }
    },
    child: Container(
        padding: EdgeInsets.only(left: 31, right: 31),
        child: Text(
          text,
          style: TextStyle(color: isEnabled ? kWhite : kBlack),
        )),
    style: ElevatedButton.styleFrom(
        primary: isEnabled ? kYellow : kWhite,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
  );
}
