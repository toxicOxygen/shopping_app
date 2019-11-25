import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import './product_list_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorite;

  ProductsGrid(this.showFavorite);

  @override
  Widget build(BuildContext context) {
    final products = !showFavorite ? 
      Provider.of<Products>(context).products : 
      Provider.of<Products>(context).favorites;

    return products.length > 0 ? GridView.builder(
      padding: EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2/3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20
      ),
      itemCount: products.length,
      itemBuilder: (ctx,i){
        return ChangeNotifierProvider.value(
          value: products[i],
          child: ProductListItem(),
        );
      },
    ): 
    Center(
      child: Text(
        'No favorite items selected',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.display1,
      ),
    );
  }
}