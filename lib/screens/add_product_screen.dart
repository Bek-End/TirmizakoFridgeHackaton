import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hackaton_fridge/bloc/add_product_bloc.dart';
import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/constants/constants.dart';

class AddProductScreen extends StatefulWidget {
  static final routeName = "/add-product";
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  TextEditingController controller = TextEditingController();
  String dropdownValue = 'Общие';
  String unitDrop = 'Штук';
  int count = 0;
  String chosenDate = '';
  Widget show = SvgPicture.asset("assets/attach_photo.svg");
  File image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: kWhite,
          elevation: 0,
          leading: IconButton(
              icon: SvgPicture.asset("assets/arrow_back.svg"),
              onPressed: () {
                navigatorBloc.mapEventToState(NavigatorPopEvent());
              }),
          title: Text(
            "Добавить продукт",
            style: TextStyle(color: kBlack),
          ),
          actions: [
            IconButton(
                icon: Icon(
                  Icons.more_vert,
                  color: kBlack,
                ),
                onPressed: () {})
          ],
        ),
        body: StreamBuilder(
            stream: addProductBloc.subject.stream,
            builder: (context, AsyncSnapshot<AddProductStates> snapshot) {
              switch (snapshot.data.runtimeType) {
                case AddProductCounterState:
                  AddProductCounterState counterState = snapshot.data;
                  count = counterState.counter;
                  break;
                case AddProductPassDateState:
                  AddProductPassDateState dateState = snapshot.data;
                  chosenDate = dateState.date;
                  break;
                case AddProductAddPhotoState:
                  AddProductAddPhotoState photoState = snapshot.data;
                  image = photoState.file;
                  show =
                      Container(height: 60, width: 60, child: photoState.image);
                  break;
              }
              return ListView(
                padding: EdgeInsets.all(16),
                children: [
                  buildHeader("Заполните информацию о продукте"),
                  SizedBox(
                    height: 16,
                  ),
                  labelText("Название продукта"),
                  SizedBox(
                    height: 7,
                  ),
                  nameInput("Введите название продукты", controller),
                  SizedBox(
                    height: 16,
                  ),
                  labelText("Категория"),
                  SizedBox(
                    height: 7,
                  ),
                  dropDown(),
                  SizedBox(
                    height: 16,
                  ),
                  labelText("Единица измерения"),
                  SizedBox(
                    height: 7,
                  ),
                  unitDropDown(),
                  SizedBox(
                    height: 16,
                  ),
                  labelText("Количество"),
                  SizedBox(
                    height: 20,
                  ),
                  counter(count),
                  SizedBox(
                    height: 16,
                  ),
                  labelText("Выберите срок истечения годности"),
                  SizedBox(
                    height: 16,
                  ),
                  buildChooseDateBtn("Выбрать дату"),
                  SizedBox(
                    height: 7,
                  ),
                  showTextDate(chosenDate),
                  SizedBox(
                    height: 30,
                  ),
                  buildPhotoAdd(show),
                  SizedBox(
                    height: 7,
                  ),
                  buildSave("Сохранить")
                ],
              );
            }),
      ),
    );
  }

  Widget buildPhotoAdd(Widget show) {
    return GestureDetector(
      onTap: () {
        addProductBloc.mapEventToState(AddProductAddPhotoEvent());
      },
      child: Container(
        child: show,
      ),
    );
  }

  Widget showTextDate(String date) {
    return Center(
      child: Text(
        date,
        style: TextStyle(color: kBlack, fontSize: 17),
      ),
    );
  }

  Widget buildChooseDateBtn(String text) {
    return ElevatedButton(
      onPressed: () async {
        DateTime pass = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now(),
          lastDate: DateTime(2022),
        );
        addProductBloc.mapEventToState(AddProductPassDateEvent(
            date: "${pass.day}.${pass.month}.${pass.year}"));
      },
      child: Text(
        text,
        style: TextStyle(color: kWhite),
      ),
      style: ElevatedButton.styleFrom(
          primary: kYellow,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget buildSave(String text) {
    return ElevatedButton(
      onPressed: () async {
        addProductBloc.mapEventToState(AddProductSaveEvent(
            category: dropdownValue,
            name: controller.text,
            unit: unitDrop,
            count: count.toDouble(),
            date: chosenDate,
            image: image));
      },
      child: Text(
        text,
        style: TextStyle(color: kWhite),
      ),
      style: ElevatedButton.styleFrom(
          primary: kBrown,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }

  Widget buildHeader(String text) {
    return Container(
      padding: EdgeInsets.only(right: 50),
      child: Text(
        text,
        style:
            TextStyle(fontSize: 21, color: kBlack, fontWeight: FontWeight.w600),
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

  Widget nameInput(String hinText, TextEditingController controller) {
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

  Widget dropDown() {
    return DropdownButton<String>(
      value: dropdownValue,
      iconSize: 0,
      elevation: 16,
      style: const TextStyle(color: kBlack),
      underline: Container(
        height: 1,
        color: kBrown,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        });
      },
      items: <String>[
        'Общие',
        'Фрукты',
        'Мучные продукты',
        'Мясные продукты',
        'Кондитерские изделия',
        'Другое'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget unitDropDown() {
    return DropdownButton<String>(
      value: unitDrop,
      iconSize: 0,
      elevation: 16,
      style: const TextStyle(color: kBlack),
      underline: Container(
        height: 1,
        color: kBrown,
      ),
      onChanged: (String newValue) {
        setState(() {
          unitDrop = newValue;
        });
      },
      items: <String>[
        'Штук',
        'Килограмм',
        'Грамм',
        'Литр',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget counter(int count) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: buildCountBtn("+", Counter.INCREMENT),
            flex: 3,
          ),
          Expanded(child: Center(child: Text(count.toString()))),
          Expanded(
            child: buildCountBtn("-", Counter.DECREMENT),
            flex: 3,
          ),
        ],
      ),
    );
  }

  Widget buildCountBtn(String text, Counter counter) {
    return ElevatedButton(
      onPressed: () {
        addProductBloc
            .mapEventToState(AddProductCounterEvent(counter: counter));
      },
      child: Container(
        margin: EdgeInsets.only(top: 10, bottom: 10),
        child: Text(
          text,
          style: TextStyle(color: kBrown, fontSize: 25),
        ),
      ),
      style: ElevatedButton.styleFrom(
          primary: kWhite,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    );
  }
}
