class Products {
  List<Product> product;

  Products({this.product});

  Products.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      product = new List<Product>();
      json['products'].forEach((v) {
        product.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.product != null) {
      data['products'] = this.product.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Product {
  int id;
  String name;
  String expireDate;
  String image;
  String category;
  double quantity;
  String unit;
  bool isExpired;

  Product(
      {this.id,
      this.name,
      this.expireDate,
      this.image,
      this.category,
      this.quantity,
      this.unit,
      this.isExpired});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    expireDate = json['expire_date'];
    image = json['image'];
    category = json['category'];
    quantity = json['quantity'] as double;
    unit = json['unit'];
    isExpired = json['isExpired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['expire_date'] = this.expireDate;
    data['image'] = this.image;
    data['category'] = this.category;
    data['quantity'] = this.quantity;
    data['unit'] = this.unit;
    data['isExpired'] = this.isExpired;
    return data;
  }
}