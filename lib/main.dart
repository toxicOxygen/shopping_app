import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/cart_screen.dart';
import './providers/products_provider.dart';
import './providers/cart_provider.dart';
import './screens/edit_products_screen.dart';
import './screens/user_products_screen.dart';
import './providers/orders_provider.dart';
import './screens/orders_screen.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        )
      ],
      child: MaterialApp(
        title: 'Shop App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.pink,
          fontFamily: 'Ubuntu'
        ),
        home: ProductsOverViewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx)=>ProductDetailScreen(),
          CartScreen.routeName: (ctx)=>CartScreen(),
          EditProductScreen.routeName: (ctx)=>EditProductScreen(),
          UserProductsScreen.routeName: (ctx)=>UserProductsScreen(),
          OrdersScreen.routeName: (ctx)=>OrdersScreen()
        },
      ),
    );
  }
}