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
import './screens/auth_screen.dart';
import './providers/auth_provider.dart';

void main(){
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider,Products>(
          builder: (ctx,auth,prev)=>Products(
            auth.token,
            auth.userId,
            prev == null ? [] : prev.items
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider,Orders>(
          builder: (ctx,auth,prev)=>Orders(auth.token,auth.userId,prev == null? []:prev.items),
        )
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx,auth,_){
          return MaterialApp(
            title: 'Shop App',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.pink,
              fontFamily: 'Ubuntu'
            ),
            home: !auth.isAuthenticated ? AuthScreen():ProductsOverViewScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx)=>ProductDetailScreen(),
              CartScreen.routeName: (ctx)=>CartScreen(),
              EditProductScreen.routeName: (ctx)=>EditProductScreen(),
              UserProductsScreen.routeName: (ctx)=>UserProductsScreen(),
              OrdersScreen.routeName: (ctx)=>OrdersScreen(),
              //AuthScreen.routeName: (ctx)=>AuthScreen()
            },
          );
        },
      ),
    );
  }
}