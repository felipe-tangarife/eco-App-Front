import 'dart:convert';

import 'package:http/http.dart' as http;

class AuthService {

  login(url, entity) async {
    var response = await http.post(Uri.parse(url),
        headers: {
          "content-type": "application/json"
        },
        body: jsonEncode(entity));
    return response;
  }

  register(url, entity) async {
    var response = await http.post(Uri.parse(url),
        headers: {
          "content-type": "application/json"
        },
        body: jsonEncode(entity));
    return response;
  }

}