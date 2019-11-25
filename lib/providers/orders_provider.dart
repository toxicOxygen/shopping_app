import 'package:flutter/material.dart';
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
  List<OrderItem> _items = [];

  List<OrderItem> get orders => [..._items];

  void addOrder(List<CartItem> items,double amount){
    _items.insert(0,OrderItem(
      id: DateTime.now().toIso8601String(),
      dateTime: DateTime.now(),
      amount: amount,
      products: items
    ));
    notifyListeners();
  }
}