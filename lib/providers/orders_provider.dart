import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart_provider.dart';


class OrderItem{
  final DateTime dateTime;
  final double amount;
  final List<CartItem> products;
  final String id;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products
  }); 
}


class Orders with ChangeNotifier{
  final String authToken;
  final List<OrderItem> items;
  
  Orders(this.authToken,this.items);

  List<OrderItem> _items = [];

  List<OrderItem> get orders => [..._items];

  Future<void> addOrder(List<CartItem> items,double amount){
    final url = "https://shopping-app-ddbbc.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();

    return http.post(url,body: json.encode({
      'amount':amount,
      'dateTime':timeStamp.toIso8601String(),
      'products':items.map((cp)=>{
        'id':cp.id,
        'title':cp.title,
        'price':cp.price,
        'quantity':cp.quantity
      }).toList()
    }))
    .then((res){
      final id = json.decode(res.body);
      print(id['name']);
      _items.insert(0,OrderItem(
        id: id['name'],
        dateTime: timeStamp,
        amount: amount,
        products: items
      ));
      notifyListeners();
    })
    .catchError((e){
      print(e);
      throw e;
    });
  }

  Future<void> fetchOrders() async{
    final url = "https://shopping-app-ddbbc.firebaseio.com/orders.json";
    final response = await http.get(url);
    try{
      if(response.body == null) return;
      final Map<String,dynamic> data = json.decode(response.body);
      List<OrderItem> _newList = [];

      data.forEach((key,value){
        _newList.add(OrderItem(
          id: key,
          amount: value["amount"],
          dateTime: DateTime.parse(value["dateTime"]),
          products: (value['products'] as List<dynamic>).map((item){
            return CartItem(
              id: item["id"],
              price: item['price'],
              quantity: item['quantity'],
              title: item['title']
            );
          }).toList()
        ));
      });
      _items = _newList.reversed.toList();
      _newList = null;
      notifyListeners();
    }catch(e){
      print(e);
      throw e;
    }
  }
}