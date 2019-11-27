import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../widgets/order_list_item.dart';
import '../providers/orders_provider.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = "/orders-screens";

  @override
  Widget build(BuildContext context) {
    //final orders = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Your orders'),
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context,listen: false).fetchOrders(),
        builder: (ctx,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          
          final bool isError = snapshot.error??false;
          if(isError)
            return Center(child: Text('Encountered an error try again'),);
          else
            return Consumer<Orders>(
              builder: (c,order,_){
                return ListView.builder(
                  itemCount: order.orders.length,
                  itemBuilder: (ctx,i)=>OrderListItem(
                    amount: order.orders[i].amount,
                    dateTime: order.orders[i].dateTime,
                    products: order.orders[i].products,
                  ),
                );
              },
            );
        },
      ),
    );
  }
}