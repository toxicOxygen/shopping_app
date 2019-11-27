import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../models/http_exceptions.dart';

enum AuthMode { Login, SignUp }

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  var _authMode = AuthMode.Login;
  var _authData = {
    "email":"",
    "password":""
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 8.0,
      child: Container(
        height: _authMode == AuthMode.SignUp?320:260,
        constraints: BoxConstraints(
          minHeight: _authMode == AuthMode.SignUp?320:260
        ),
        width: deviceSize.width * 0.75,
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val)=>_validateEmail(val),
                  onSaved: (val)=>_authData["email"] = val,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (val)=>_validatePassword(val),
                  onSaved: (val)=>_authData["password"] = val,
                ),
                if(_authMode == AuthMode.SignUp)
                  TextFormField(
                    enabled: _authMode == AuthMode.SignUp,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (val)=> val == _passwordController.text?null:"Password don't match",
                  ),
                SizedBox(height: 20,),
                if(_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text(_authMode == AuthMode.Login?"LOGIN":"SIGN UP"),
                    onPressed: _sumbit,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 30),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text(_authMode ==AuthMode.Login?"SIGN UP INSTEAD":"LOGIN INSTEAD"),
                  padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                  onPressed: ()=>setState((){
                    if(_authMode == AuthMode.Login)
                      _authMode = AuthMode.SignUp;
                    else
                      _authMode = AuthMode.Login;
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _validateEmail(String val){
    var regExp = RegExp(r"[^@]+@[^\.]+\..+"); 
    if(regExp.hasMatch(val)){
      return null;
    }
    return "Enter a valid email";
  }

  String _validatePassword(String val){
    var regExp = RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%\^&\*])(?=.{8,})");
    if(regExp.hasMatch(val)) return null;
    return "The string must contain at least\n 1 lowercase\n1 uppercase\n1 number\none special character\nand must be eight characters or longer";
  }
  
  void _sumbit() async{
    if(!_form.currentState.validate()) return ;
    _form.currentState.save();
    setState(()=>_isLoading = true);
    final auth = Provider.of<AuthProvider>(context,listen: false);

    try{
      if(_authMode == AuthMode.Login){
        //logging in
        await auth.login(_authData["email"],_authData["password"]);
      }else{
        //signing up
        await auth.signup(_authData["email"],_authData["password"]);
      }
    }on HttpException catch(e){
      print(e.toString());
      _show(context, e.toString());
    }catch(e){
      print(e.toString());
      _show(context, e.toString());
    }

    setState(()=>_isLoading = false);
  }

  void _show(BuildContext context,String errorMessage){
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        duration: Duration(seconds: 3),
        action: SnackBarAction(label: 'OK',onPressed: (){
          Scaffold.of(context).hideCurrentSnackBar();
        },),
      )
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
}