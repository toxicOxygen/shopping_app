import 'package:flutter/material.dart';
import '../screens/edit_products_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

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
    final scaffold = Scaffold.of(context);

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
            onPressed: (){
              showDialog(
                context: context,
                builder: (c){
                  return AlertDialog(
                    content: Text('Are sure you want to delete?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('YES'),
                        onPressed: ()=>Navigator.of(c).pop(true),
                      ),
                      RaisedButton(
                        child: Text('NO'),
                        textColor: Colors.white,
                        onPressed: ()=>Navigator.of(c).pop(false),
                      )
                    ],
                  );
                }
              ).then((val){
                if(val == null)
                  return;
                if(val)
                  Provider.of<Products>(context,listen: false).deleteProduct(id)
                  .catchError((e){
                    scaffold.hideCurrentSnackBar();
                    scaffold.showSnackBar(SnackBar(
                      content: Text('failed to delete item'),
                      duration: Duration(milliseconds: 500),
                      action: SnackBarAction(
                        label: 'OK',
                        onPressed: (){},
                      ),
                    ));
                  });
              });
            },
          )
        ],
      ),
    );
  }
}