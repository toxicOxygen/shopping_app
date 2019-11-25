import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/cart_provider.dart';

class OrderListItem extends StatelessWidget {
  final DateTime dateTime;
  final double amount;
  final List<CartItem> products;

  OrderListItem({
    @required this.amount,
    @required this.dateTime,
    @required this.products
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "\$"+amount.toStringAsFixed(2),
            style: Theme.of(context).textTheme.title,
          ),
          Text(
            DateFormat('dd-MM-yyyy hh:mm').format(dateTime),
            style: Theme.of(context).textTheme.subtitle,
          )
        ],
      ),
      children: products.map((item)=>Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Divider(),
          ListTile(
            title: Text(item.title),
            leading: Chip(
              label: Text('\$${item.price}'),
              labelStyle: TextStyle(color: Colors.white),
              backgroundColor: Theme.of(context).primaryColor,
            ),
            trailing: Text('${item.quantity} x'),
          )
        ],
      )).toList(),
    );
  }
}