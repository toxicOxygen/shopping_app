import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/order_list_item.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders-screens";

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: MainDrawer(),
      body: orders.isNotEmpty ? ListView.builder(
        itemCount: orders.length,
        itemBuilder: (ctx,i)=>OrderListItem(
          amount: orders[i].amount,
          dateTime: orders[i].dateTime,
          products: orders[i].products,
        ),
      ):
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Text(
            'No orders available currently',
            style: Theme.of(context).textTheme.display1,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}