import 'dart:convert';
import '../models/http_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class AuthProvider with ChangeNotifier{
  static const API_KEY = "AIzaSyBVzCwcHznJllgOLgWZY-MjyLF_V1bhdLU";
  String _token;
  String _userId;
  DateTime _expiryDate;

  bool get isAuthenticated{
    return token != null;
  }

  String get token{
    if(_expiryDate != null && _expiryDate.isAfter(DateTime.now()) && _token != null)
      return _token;
    return null;
  }

  Future<void> signup(String email,String password){
    final url = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$API_KEY";
    return http.post(url,body:json.encode({
      'email':email,
      'password':password,
      'returnSecureToken':true
    }))
    .then((res){
      final responseData = json.decode(res.body);
      if(responseData["error"] != null)
        throw HttpException(responseData["error"]["message"]);
      
      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData["expiresIn"])
      ));
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
    .then((res){
      final responseData = json.decode(res.body);
      if(responseData["error"] != null)
        throw HttpException(responseData["error"]["message"]);

      _token = responseData["idToken"];
      _userId = responseData["localId"];
      _expiryDate = DateTime.now().add(Duration(
        seconds: int.parse(responseData["expiresIn"])
      ));
      notifyListeners();
    })
    .catchError((e){
      throw e;
    });
  }
}