import 'package:flutter/material.dart';

class CartItem{
  final String id;
  final String title;
  final double price;
  final int quantity;
  
  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier{

  Map<String,CartItem> _items = {};

  Map<String,CartItem> get items => {..._items};

  int get itemCount => _items.length;

  void addItemToCart(String productId,String title,double price){
    if(_items.containsKey(productId)){
      _items.update(productId, (oldItem){
        return CartItem(
          id: oldItem.id,
          price: oldItem.price,
          quantity: oldItem.quantity + 1,
          title: oldItem.title
        );
      });
    }else{
      _items.putIfAbsent(productId, (){
        return CartItem(
          id: DateTime.now().toIso8601String(),
          price: price,
          quantity: 1,
          title: title
        );
      });
    }
    notifyListeners();
  }
  
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId){
    if(!_items.containsKey(productId))
      return;

    if(_items[productId].quantity > 1){
      _items.update(productId, (oldItem){
        return CartItem(
          id: oldItem.id,
          price: oldItem.price,
          quantity: oldItem.quantity - 1,
          title: oldItem.title
        );
      });
    }else{
       _items.remove(productId);
    }
    notifyListeners();  
  }

  double get totalPrice{
    var total = 0.0;
    _items.forEach((key,value){
      total = total + (value.quantity * value.price);
    });
    return total;
  }

  void clear(){
    _items.clear();
    notifyListeners();
  }
}