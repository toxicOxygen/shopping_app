import 'package:flutter/material.dart';
import '../screens/edit_products_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String imageUrl;
  final String title;

  UserProductItem({
    @required this.id,
    @required this.imageUrl,
    @required this.title
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: ()=>Navigator.of(context).pushNamed(
              EditProductScreen.routeName,
              arguments: id
            ),
          ),
          SizedBox(width: 5,),
          IconButton(
            icon:Icon(Icons.delete),
            color: Theme.of(context).errorColor,
            onPressed: (){},
          )
        ],
      ),
    );
  }
}