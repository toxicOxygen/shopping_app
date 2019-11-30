import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exceptions.dart';



class AuthProvider with ChangeNotifier{
  static const API_KEY = "AIzaSyBVzCwcHznJllgOLgWZY-MjyLF_V1bhdLU";
  String _token;
  String _userId;
  DateTime _expiryDate;
  Timer _authTimer;

  bool get isAuthenticated{
    return token != null;
  }

  String get token{
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null)
      return _token;
    return null;
  }

  String get userId{
    return _userId;
  }

  Future<void> signup(String email,String password){
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY";
    return http.post(url,body:json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }))
    .then((res)async{
      final responseData = json.decode(res.body);
      if(responseData["error"] != null)
        throw HttpException(responseData["error"]["message"]);
      
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData["expiresIn"])
      ));
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token":_token,
        "expiryDate":_expiryDate.toIso8601String(),
        "userId":_userId
      });
      await prefs.setString("userData", userData);
      notifyListeners();
    })
    .catchError((e){
      throw e;
    });
  }

  Future<void> login(String email,String password){
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$API_KEY";
    return http.post(url,body: json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }))
    .then((res)async{
      final responseData = json.decode(res.body);
      if(responseData["error"] != null)
        throw HttpException(responseData["error"]["message"]);

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData["expiresIn"])
      ));
      _autoLogout();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        "token":_token,
        "expiryDate":_expiryDate.toIso8601String(),
        "userId":_userId
      });
      await prefs.setString("userData", userData);
      notifyListeners();
    })
    .catchError((e){
      throw e;
    });
  }

  Future<bool> tryAutoLogin() async{
    final prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('userData'))
      return false;
    
    final extractedData =  json.decode(prefs.getString('userData')) as Map<String,dynamic>;
    final expiryDate = DateTime.parse(extractedData["expiryDate"]);
    
    if(expiryDate.isBefore(DateTime.now()))
      return false;
    
    _token = extractedData["token"];
    _expiryDate = extractedData["expiryDate"];
    _userId = extractedData["userId"];
    notifyListeners();
    _autoLogout();
    return true;
  }

  void logout() async{
    final prefs = await SharedPreferences.getInstance();
    _token = null;
    _expiryDate = null;
    _userId = null;
    if(_authTimer != null){
      _authTimer.cancel();
      _authTimer = null;
    }
    await prefs.clear();
    notifyListeners();
  }

  void _autoLogout(){
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    if(_authTimer != null){
      _authTimer.cancel();
    }
    _authTimer = Timer(Duration(seconds: timeToExpiry),logout);
  }

}