import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false
  });

  void toggleFavorite(){
    isFavorite = !isFavorite;
    notifyListeners();
  }
}


class Products with ChangeNotifier{

  List<Product> _items = [
    Product(
      id: 'p0',
      title: 'CHECK PRINT SHIRT',
      price: 110.0,
      description: 'a red checkered shirt',
      imageUrl: 'http://t.ly/yxAxb'
    ),
    Product(
      id: 'p1',
      title: 'GLORIA HIGH LOGO SNEAKER',
      price: 91.0,
      description: 'a beautiful shoe',
      imageUrl: 'http://t.ly/OrPrl'
    ),
    Product(
      id: 'p2',
      title: 'CATE RIGID BAG',
      description: 'a nice bag',
      price: 94.5,
      imageUrl: 'http://t.ly/RJGJO'
    ),
    Product(
      id: 'p3',
      title: 'GUESS CONNECT WATCH',
      description: 'a beautiful wrist watch',
      price: 45.99,
      imageUrl: 'http://t.ly/mGAe5'
    )
  ];

  List<Product> get products{
    return [..._items];
  }

  List<Product> get favorites{
    return _items.where((item)=>item.isFavorite).toList();
  }

  void addProduct(Map<String,dynamic> data){
    _items.insert(0, Product(
      id: DateTime.now().toIso8601String(),
      description: data["description"],
      imageUrl: data["imageUrl"],
      price:double.parse(data["price"]),
      title: data["title"]
    ));
    notifyListeners();
  }

  void updateProduct(Map<String,dynamic> data){
    final index = _items.indexWhere((item)=>item.id==data["id"]);

    if(index >= 0){
      _items[index] = Product(
        id: data["id"],
        description: data["description"],
        imageUrl: data["imageUrl"],
        price:double.parse(data["price"]),
        title: data["title"]
      );
      notifyListeners();
    }
  }

  void deleteProduct(String productId){
    _items.removeWhere((item)=>item.id == productId);
    notifyListeners();
  }
}