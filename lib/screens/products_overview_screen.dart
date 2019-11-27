import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/main_drawer.dart';
import '../widgets/badge.dart';
import '../screens/cart_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/products_provider.dart';

enum Filters { favorites, all}

class ProductsOverViewScreen extends StatefulWidget {
  static const String routeName = "/";

  @override
  _ProductsOverViewScreenState createState() => _ProductsOverViewScreenState();
}

class _ProductsOverViewScreenState extends State<ProductsOverViewScreen> {

  bool _showFavorites = false;
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if(_isInit){
      setState(()=>_isLoading = true);
      Provider.of<Products>(context).fetchData()
      .then((_){
        setState(()=>_isLoading=false);
      })
      .catchError((e){
        setState(()=>_isLoading = false);
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_,cart,ch)=>Badge(
              child: ch,
              value: '${cart.itemCount}',
            ),
            child:IconButton(
              icon: Icon(Icons.shopping_basket),
              onPressed: ()=> Navigator.of(context).pushNamed(CartScreen.routeName),
            ),
          ),
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (val){
              if(val == Filters.favorites)
                setState(() {_showFavorites =true;});
              else
                setState(() { _showFavorites = false; });
            },
            itemBuilder: (_){
              return [
                PopupMenuItem(
                  value: Filters.all,
                  child: Text('All items'),
                ),
                PopupMenuItem(
                  value: Filters.favorites,
                  child: Text('Favorites'),
                )
              ];
            },
          )
        ],
      ),

      body: !_isLoading ? ProductsGrid(_showFavorites)
        :Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Please wait.....',
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(height: 10,),
              CircularProgressIndicator()
            ],
          ),
        ),

      drawer: MainDrawer(),
    );
  }
}