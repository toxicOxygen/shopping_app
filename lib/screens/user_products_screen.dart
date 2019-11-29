import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/main_drawer.dart';
import '../providers/products_provider.dart';
import '../widgets/user_product_list_item.dart';
import './edit_products_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = "/user-products";

  Future<void> _refreshList(BuildContext context) async{
    Provider.of<Products>(context,listen: false).fetchData(true);
  }

  @override
  Widget build(BuildContext context) {
    //final products = Provider.of<Products>(context).products;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: ()=>Navigator.of(context).pushNamed(EditProductScreen.routeName),
          )
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: _refreshList(context),
        builder: (ctx,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator(),);
          
          return RefreshIndicator(
            onRefresh: ()=>_refreshList(context),
            child: Consumer<Products>(
              builder: (ctx,prdts,_){
                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: prdts.products.length,
                  itemBuilder: (_,i)=>Column(
                    children: <Widget>[
                      UserProductItem(
                        id: prdts.products[i].id,
                        imageUrl: prdts.products[i].imageUrl,
                        title: prdts.products[i].title,
                      ),
                      Divider()
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}