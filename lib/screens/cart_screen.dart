import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/cart_list_item.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = "/cart-screen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final order = Provider.of<Orders>(context,listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text('Total',style: TextStyle(fontSize: 20)),
                  Spacer(),
                  Chip(
                    label: Text('\$${cart.totalPrice.toStringAsFixed(2)}'),
                    labelStyle: TextStyle(color: Colors.white),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  FlatButton(
                    child: !_isLoading? Text('ORDER NOW'):CircularProgressIndicator(),
                    textColor: Theme.of(context).primaryColor,
                    onPressed:cart.totalPrice != 0 ? (){
                      setState(()=>_isLoading = true);
                      order.addOrder(cart.items.values.toList(), cart.totalPrice)
                      .then((_){
                        cart.clear();
                        setState(()=>_isLoading = false);
                      });
                    }:null,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx,i)=>CartListItem(
                id: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                quantity: cart.items.values.toList()[i].quantity,
                title: cart.items.values.toList()[i].title,
                productId: cart.items.keys.toList()[i],
              ),
            ),
          )
        ],
      ),
    );
  }
}