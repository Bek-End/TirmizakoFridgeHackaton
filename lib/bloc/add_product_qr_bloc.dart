import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackaton_fridge/models/response_fromJson.dart';
import 'package:hackaton_fridge/repo/repo.dart';
import 'products_bloc.dart';
import 'navigator_bloc.dart';

abstract class AddProductQrEvents {}

class AddProductInitialEvent extends AddProductQrEvents {
  final String qr;
  AddProductInitialEvent({this.qr});
}

enum Counter { INCREMENT, DECREMENT }

class AddProductCounterEvent extends AddProductQrEvents {
  final Counter counter;
  AddProductCounterEvent({this.counter});
}

class AddProductPassDateEvent extends AddProductQrEvents {
  final String date;
  AddProductPassDateEvent({this.date});
}

class AddProductAddPhotoEvent extends AddProductQrEvents {}

class AddProductSaveEvent extends AddProductQrEvents {
  final String name;
  final String category;
  final String unit;
  final double count;
  final String date;
  final File image;
  final String barcode;
  AddProductSaveEvent(
      {this.name,
      this.category,
      this.unit,
      this.count,
      this.date,
      this.image,
      this.barcode});
}

abstract class AddProductQrStates {}

class AddProductInitialState extends AddProductQrStates {
  final String qr;
  AddProductInitialState({this.qr});
}

class AddProductCounterState extends AddProductQrStates {
  final int counter;
  AddProductCounterState({this.counter});
}

class AddProductPassDateState extends AddProductQrStates {
  final String date;
  AddProductPassDateState({this.date});
}

class AddProductAddPhotoState extends AddProductQrStates {
  final Image image;
  final File file;
  AddProductAddPhotoState({this.image, this.file});
}

class AddProductBloc {
  BehaviorSubject<AddProductQrStates> _subject = BehaviorSubject();
  BehaviorSubject<AddProductQrStates> get subject => _subject;
  int counter = 0;
  final imagePicker = ImagePicker();

  void mapEventToState(AddProductQrEvents event) async {
    switch (event.runtimeType) {
      case AddProductInitialEvent:
        AddProductInitialEvent initialEvent = event;
        _subject.sink.add(AddProductInitialState(qr: initialEvent.qr));
        break;
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
        ResponseFromJson fromJson = await projectRepo.addProductQr(
            name: saveEvent.name,
            category: saveEvent.category,
            expireDate: saveEvent.date,
            unit: saveEvent.unit,
            quantity: saveEvent.count,
            qr: saveEvent.barcode,
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

final addProductQrBloc = AddProductBloc();
