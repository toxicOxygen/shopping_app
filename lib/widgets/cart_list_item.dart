import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class CartListItem extends StatelessWidget {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String productId;

  CartListItem({
    @required this.id,
    @required this.price,
    @required this.quantity,
    @required this.title,
    @required this.productId
  });

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context,listen: false);

    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      onDismissed: (_){
        cart.removeItem(productId);
      },
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(Icons.delete,size: 40.0,color: Colors.white,),
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.only(right:10),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal:15,vertical: 3),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            title: Text(title),
            trailing: Text('$quantity x'),
            leading: Chip(
              label: Text('\$$price'),
              labelStyle: TextStyle(color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor
            ),
          ),
        ),
      ),
    );
  }
}