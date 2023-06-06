import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../http_exception.dart';

class Auth with ChangeNotifier {
  late String _token;
  late DateTime _expiryTokenDate;
  late String _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryTokenDate.isAfter(DateTime.now()) &&
        _expiryTokenDate != null &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDYm1qhZPPWfIqphWxX2mbrbp0xnaVGK0s');

    try {
      final response = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true
          }));
      print(json.decode(response.body));

      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message'] as String);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryTokenDate = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
    // final url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDYm1qhZPPWfIqphWxX2mbrbp0xnaVGK0s');
    // await http.post(url,
    //     body: json.encode(
    //         {'email': email, 'password': password, 'returnSecureToken': true}));
  }
}
