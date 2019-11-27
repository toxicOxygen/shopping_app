import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';
import '../screens/product_detail_screen.dart';
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';

class ProductListItem extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context,listen: false);
    final cart = Provider.of<Cart>(context,listen: false);
    final auth = Provider.of<AuthProvider>(context,listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(15.0),
      child: GridTile(
        child: InkWell(
          child: Image.network(product.imageUrl,fit: BoxFit.cover,),
          onTap: (){
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,arguments: product.id);
          },
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black54,
          leading: Consumer<Product>(
            builder: (ctx,product,_){
              return IconButton(
                icon: Icon(!product.isFavorite? Icons.favorite_border:Icons.favorite),
                onPressed: ()=>product.toggleFavorite(auth.token),
              );
            },
          ),
          title: Text(product.title),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: (){
              cart.addItemToCart(product.id,product.title,product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Item added to cart'),
                duration: Duration(seconds: 2),
                action: SnackBarAction(
                  label: 'UNDO',
                  onPressed: ()=>cart.removeSingleItem(product.id),
                ),
              ));
            },
          ),
        ),
        
      ),
    );
  }
}