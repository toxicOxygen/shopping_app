import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  static const String routeName = "/edit-product-screen";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {

  final _form = GlobalKey<FormState>();
  final _priceNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlNode = FocusNode();
  final _imageUrlController = TextEditingController();

  var _isInit = true;
  var _isLoading = false;

  var _newProduct = {
    "id":'',
    'title':'',
    'description':'',
    'price':'',
    'imageUrl':''
  };

  @override
  void initState() {
    _imageUrlNode.addListener(_updateImage);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final id = ModalRoute.of(context).settings.arguments;
      if(id != null){
        final p = Provider.of<Products>(context,listen: false)
          .products.firstWhere((item)=>item.id == id);
        _newProduct['id'] = p.id;
        _newProduct['title'] = p.title;
        _newProduct['description']=p.description;
        _newProduct['imageUrl'] = p.imageUrl;
        _newProduct['price']= p.price.toString();

        _imageUrlController.text = _newProduct['imageUrl'];
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: ()=>_saveForm(),
          )
        ],
      ),
      body: !_isLoading? Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 15),
          children: <Widget>[
            TextFormField(
              initialValue: _newProduct['title'],
              decoration: InputDecoration(labelText: 'Title'),
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (_)=>FocusScope.of(context).requestFocus(_priceNode),
              onSaved: (val)=>_newProduct["title"] = val,
              validator: (val)=>val.isEmpty?"enter title":null,
            ),
            TextFormField(
              initialValue: _newProduct['price'],
              decoration: InputDecoration(labelText: 'Price'),
              textInputAction: TextInputAction.next,
              focusNode: _priceNode,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              onFieldSubmitted: (_)=>FocusScope.of(context).requestFocus(_descriptionNode),
              onSaved: (val)=>_newProduct["price"]= val,
              validator: (val)=>_validatePrice(val),
            ),
            TextFormField(
              initialValue: _newProduct['description'],
              decoration: InputDecoration(labelText: 'Description '),
              focusNode: _descriptionNode,
              maxLines: 3,
              onSaved: (val)=>_newProduct["description"]=val,
              validator: (val)=>val.isNotEmpty? null:"description must be filled",
            ),
            SizedBox(height: 20,),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey)
                  ),
                  child: _imageUrlController.text.isEmpty ? 
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(8),
                      child: Text('Enter image url',textAlign: TextAlign.center,),
                    ) : 
                    FittedBox(
                      child: Image.network(
                        _imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: TextFormField(
                    controller: _imageUrlController,
                    decoration: InputDecoration(labelText: 'Image Url'),
                    keyboardType: TextInputType.url,
                    textInputAction: TextInputAction.done,
                    focusNode: _imageUrlNode,
                    onSaved: (val)=>_newProduct["imageUrl"]=val,
                    validator: (val)=>_validateUrl(val),
                    onFieldSubmitted: (_)=>_saveForm(),
                  ),
                )
              ],
            )
          ],
        ),
      ):
      Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  void _updateImage(){
    if(!_imageUrlNode.hasFocus){
      var regExp = RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
      var normalExp = RegExp(r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$");
      
      var url = _imageUrlController.text;

      if(regExp.hasMatch(url)||normalExp.hasMatch(url)){
        setState((){});
      }
    }
  }

  String _validateUrl(String val){
    var regExp = RegExp(r"(http(s?):)([/|.|\w|\s|-])*\.(?:jpg|gif|png)");
    var normalExp = RegExp(r"^(?:http(s)?:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:/?#[\]@!\$&'\(\)\*\+,;=.]+$");

    if(regExp.hasMatch(val)||normalExp.hasMatch(val))
      return null;
    return "enter valid url";
  }

  String _validatePrice(String val){
    if(val.isEmpty)
      return "enter a price";
    
    if(double.tryParse(val) == null)
      return "enter valid number";
    
    if(double.parse(val) <= 0)
      return "price can not be 0";
    
    return null;
  }

  void _saveForm(){
    var isFormValid = _form.currentState.validate();

    if(isFormValid){
      _form.currentState.save();
      
      final prod = Provider.of<Products>(context,listen: false);

      setState((){_isLoading = true;});

      if(_newProduct["id"].isEmpty){
        print('creating new product..');
        prod.addProduct(_newProduct)
        .catchError((e){
          return showDialog(
            context:context,
            builder:(ctx){
              return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child:Text('OK'),
                    onPressed: ()=>Navigator.of(ctx).pop(),
                  )
                ],
                content: Text('An error ocurred try again later'),
              );
            }
          );
        })
        .then((_){
          setState((){_isLoading = false;});
          Navigator.of(context).pop();
        });
      }else{
        print('updating product');
        prod.updateProduct(_newProduct)
        .catchError((e){
          return showDialog(
            context:context,
            builder:(ctx){
              return AlertDialog(
                actions: <Widget>[
                  FlatButton(
                    child:Text('OK'),
                    onPressed: ()=>Navigator.of(ctx).pop(),
                  )
                ],
                content: Text('An error ocurred try again later'),
              );
            }
          );
        })
        .then((_){
          setState((){_isLoading = false;});
          Navigator.of(context).pop();
        });
      }

    }
  }

  @override
  void dispose() {
    _imageUrlNode.dispose();
    _priceNode.dispose();
    _descriptionNode.dispose();
    _imageUrlController.removeListener(_updateImage);
    super.dispose();
  }
}