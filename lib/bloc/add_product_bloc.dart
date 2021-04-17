import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackaton_fridge/models/response_fromJson.dart';
import 'package:hackaton_fridge/repo/repo.dart';
import 'products_bloc.dart';
import 'navigator_bloc.dart';

abstract class AddProductEvents {}

enum Counter { INCREMENT, DECREMENT }

class AddProductCounterEvent extends AddProductEvents {
  final Counter counter;
  AddProductCounterEvent({this.counter});
}

class AddProductPassDateEvent extends AddProductEvents {
  final String date;
  AddProductPassDateEvent({this.date});
}

class AddProductAddPhotoEvent extends AddProductEvents {}

class AddProductSaveEvent extends AddProductEvents {
  final String name;
  final String category;
  final String unit;
  final double count;
  final String date;
  final File image;
  AddProductSaveEvent(
      {this.name, this.category, this.unit, this.count, this.date, this.image});
}

abstract class AddProductStates {}

class AddProductCounterState extends AddProductStates {
  final int counter;
  AddProductCounterState({this.counter});
}

class AddProductPassDateState extends AddProductStates {
  final String date;
  AddProductPassDateState({this.date});
}

class AddProductAddPhotoState extends AddProductStates {
  final Image image;
  final File file;
  AddProductAddPhotoState({this.image, this.file});
}

class AddProductBloc {
  BehaviorSubject<AddProductStates> _subject = BehaviorSubject();
  BehaviorSubject<AddProductStates> get subject => _subject;
  int counter = 0;
  final imagePicker = ImagePicker();

  void mapEventToState(AddProductEvents event) async {
    switch (event.runtimeType) {
      case AddProductCounterEvent:
        AddProductCounterEvent counterEvent = event;
        switch (counterEvent.counter) {
          case Counter.INCREMENT:
            counter++;
            _subject.sink.add(AddProductCounterState(counter: counter));
            break;
          case Counter.DECREMENT:
            if (counter > 0) {
              counter--;
            }
            _subject.sink.add(AddProductCounterState(counter: counter));
            break;
        }
        break;
      case AddProductPassDateEvent:
        AddProductPassDateEvent dateEvent = event;
        _subject.sink.add(AddProductPassDateState(date: dateEvent.date));
        break;
      case AddProductAddPhotoEvent:
        var file = await imagePicker.getImage(source: ImageSource.gallery);
        var image = Image.file(File(file.path));
        subject.sink
            .add(AddProductAddPhotoState(image: image, file: File(file.path)));
        break;
      case AddProductSaveEvent:
        AddProductSaveEvent saveEvent = event;
        ResponseFromJson fromJson = await projectRepo.addProduct(
            name: saveEvent.name,
            category: saveEvent.category,
            expireDate: saveEvent.date,
            unit: saveEvent.unit,
            quantity: saveEvent.count,
            file: saveEvent.image);
        productBloc.mapEventToState(InitialEvent());
        navigatorBloc.mapEventToState(NavigatorPopEvent());
        break;
    }
  }

  void dispose() {
    _subject?.close();
  }
}

final addProductBloc = AddProductBloc();
