import 'package:hackaton_fridge/bloc/add_product_qr_bloc.dart';
import 'package:hackaton_fridge/bloc/navigator_bloc.dart';
import 'package:hackaton_fridge/repo/repo.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hackaton_fridge/models/response_fromJson.dart';
import 'package:hackaton_fridge/models/products_model.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

abstract class ProductEvent {}

class InitialEvent extends ProductEvent {}

class DeleteEvent extends ProductEvent {
  final Product product;
  DeleteEvent({this.product});
}

class AddEvent extends ProductEvent {}

enum Buttons { ALL, FRESH, EXPIRED }

enum BottomNavBar { PRODUCTS, ADD_QR, REMOVE_QR, CART }

class PrductChangeBottomNavBarEvent extends ProductEvent {
  final int navBar;
  PrductChangeBottomNavBarEvent({this.navBar});
}

class ProductOnBtnTapEvent extends ProductEvent {
  final Buttons button;
  ProductOnBtnTapEvent({this.button});
}

class ProductAddToCartEvent extends ProductEvent {
  final Product product;
  ProductAddToCartEvent({this.product});
}

abstract class ProductState {}

class InitialState extends ProductState {
  final Products products;
  InitialState({this.products});
}

class ProductChangeBottomNavBarState extends ProductState {
  final int index;
  ProductChangeBottomNavBarState({this.index});
}

class DeleteState extends ProductState {}

class AddState extends ProductState {}

class ProductIsAlreadyInCart extends ProductState {}

class ProductRemoveAlert extends ProductState {}

class ProductOnBtnTapState extends ProductState {
  final Buttons button;
  final Products products;
  ProductOnBtnTapState({this.button, this.products});
}

class ProductCartState extends ProductState {
  final String title;
  final Products products;
  ProductCartState({this.title, this.products});
}

class ProductBloc {
  BehaviorSubject<ProductState> _subject = BehaviorSubject<ProductState>();
  BehaviorSubject<ProductState> get subject => _subject;
  ResponseFromJson responseFromJson;

  void mapEventToState(ProductEvent event) async {
    switch (event.runtimeType) {
      case InitialEvent:
        responseFromJson = await projectRepo.getProducts();
        print(responseFromJson.products.product[0].category);
        _subject.sink.add(InitialState(products: responseFromJson.products));
        break;
      case ProductAddToCartEvent:
        ProductAddToCartEvent cartEvent = event;
        bool res = await projectRepo.addToCart(cartEvent.product.id);
        if (!res) {
          _subject.sink.add(ProductIsAlreadyInCart());
          await Future.delayed(Duration(seconds: 2));
          _subject.sink.add(ProductRemoveAlert());
        }
        break;
      case ProductOnBtnTapEvent:
        ProductOnBtnTapEvent tapEvent = event;
        Products products;
        switch (tapEvent.button) {
          case Buttons.ALL:
            ResponseFromJson responseFromJson = await projectRepo.getProducts();
            products = responseFromJson.products;
            break;
          case Buttons.FRESH:
            ResponseFromJson responseFromJson =
                await projectRepo.getFreshProducts();
            products = responseFromJson.products;
            break;
          case Buttons.EXPIRED:
            ResponseFromJson responseFromJson =
                await projectRepo.getExpiredProducts();
            products = responseFromJson.products;
            break;
        }
        _subject.sink.add(
            ProductOnBtnTapState(button: tapEvent.button, products: products));
        break;
      case DeleteEvent:
        DeleteEvent deleteEvent = event;
        bool resp = await projectRepo.removeProduct(deleteEvent.product.id);
        productBloc.mapEventToState(InitialEvent());
        break;
      case PrductChangeBottomNavBarEvent:
        PrductChangeBottomNavBarEvent navBarEvent = event;
        _subject.sink
            .add(ProductChangeBottomNavBarState(index: navBarEvent.navBar));
        if (navBarEvent.navBar == 1) {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", true, ScanMode.BARCODE);
          print("QR $barcodeScanRes");
          addProductQrBloc
              .mapEventToState(AddProductInitialEvent(qr: barcodeScanRes));
          navigatorBloc.mapEventToState(
              NavigatorChangeScreenEvent(screen: Screens.ADD_SCREEN_QR));
        } else if (navBarEvent.navBar == 2) {
          String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
              "#ff6666", "Cancel", true, ScanMode.BARCODE);
          print("QR $barcodeScanRes");
          bool res = await projectRepo.removeByBarcode(barcodeScanRes);
          productBloc.mapEventToState(InitialEvent());
        } else if (navBarEvent.navBar == 3) {
          ResponseFromJson responseFromJson =
              await projectRepo.getCartProducts();
          _subject.sink.add(ProductCartState(
              title: "Покупки", products: responseFromJson.products));
        } else if (navBarEvent.navBar == 0) {
          responseFromJson = await projectRepo.getProducts();
          print(responseFromJson.products.product[0].category);
          _subject.sink.add(InitialState(products: responseFromJson.products));
        }
        break;
      case DeleteEvent:
        break;
      case AddEvent:
        break;
    }
  }
}

ProductBloc productBloc = ProductBloc();
