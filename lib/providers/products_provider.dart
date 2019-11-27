import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/http_exceptions.dart';

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

  Future<void> toggleFavorite(String authTokenn){
    final url = "https://shopping-app-ddbbc.firebaseio.com/products/$id.json?auth=$authTokenn";
    isFavorite = !isFavorite;
    notifyListeners();
    return http.patch(url,body:json.encode({"isFavorite":isFavorite}))
    .then((res){
      if(res.statusCode >= 400)
        throw HttpException('failed to change like status');
    })
    .catchError((e){
      isFavorite = !isFavorite;
      notifyListeners();
      throw e;
    });
  }
}


class Products with ChangeNotifier{

  final String authToken;
  final List<Product> items;

  Products(this.authToken,this.items);

  List<Product> _items = [];

  List<Product> get products{
    return [..._items];
  }

  List<Product> get favorites{
    return _items.where((item)=>item.isFavorite).toList();
  }

  Future<void> fetchData() async{
    final url = "https://shopping-app-ddbbc.firebaseio.com/products.json?auth=$authToken";
    try{
      final response = await http.get(url);
      if(response.body == null) return;
      Map<String,dynamic> responseData = json.decode(response.body);
      print(responseData);
      List<Product> _products = [];
      responseData.forEach((productId,productData){
        _products.add(Product(
          id: productId,
          description: productData["description"],
          imageUrl: productData["imageUrl"],
          price: double.parse(productData["price"]),
          title: productData["title"],
          isFavorite: productData["isFavorite"]
        ));
      });
      _items = _products;
      notifyListeners();
    }catch(e){
      print(e);
      throw e;
    }
  }

  Future<void> addProduct(Map<String,dynamic> data){
    final url = "https://shopping-app-ddbbc.firebaseio.com/products.json?auth=$authToken";
    data.remove("id");
    data = {...data,"isFavorite":false};

    return http.post(url, body: json.encode(data)
    ).then((res){
      final id = json.decode(res.body)["name"];
      _items.insert(0, Product(
        id: id,
        description: data["description"],
        imageUrl: data["imageUrl"],
        price:double.parse(data["price"]),
        title: data["title"]
      ));
      notifyListeners();
    }).catchError((e){
      print(e);
      throw e;
    });
    
  }

  Future<void> updateProduct(Map<String,dynamic> data) async{
    final productId = data["id"];
    final url = "https://shopping-app-ddbbc.firebaseio.com/products/$productId.json?auth=$authToken";
    data.remove("id");
    try{
      final index = _items.indexWhere((item)=>item.id==productId);
      if(index >= 0){
        await http.patch(url,body: json.encode(data));
        _items[index] = Product(
          id: productId,
          description: data["description"],
          imageUrl: data["imageUrl"],
          price:double.parse(data["price"]),
          title: data["title"],
          isFavorite: _items[index].isFavorite
        );
        notifyListeners();
      }
    }catch(e){
      throw e;
    }
  }

  Future<void> deleteProduct(String productId) {
    final url = "https://shopping-app-ddbbc.firebaseio.com/products/$productId.json?auth=$authToken";
    final productIndex = _items.indexWhere((item)=>item.id == productId);
    var existingProduct = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();

    return http.delete(url).then((res){
      if(res.statusCode >= 400)
        throw HttpException('failed to delete');
      existingProduct = null;
    }).catchError((e){
      _items.insert(productIndex, existingProduct);
      notifyListeners();
      throw e;
    });
  }

}