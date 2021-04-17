import 'products_model.dart';

class ResponseFromJson {
  final Products products;
  final String error;

  ResponseFromJson({this.products, this.error});

  ResponseFromJson.fromJson(var json)
      : this.products = Products.fromJson(json),
        this.error = "";

  ResponseFromJson.withError(String errorValue)
      : error = errorValue,
        products = Products();
}
