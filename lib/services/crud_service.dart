import 'dart:convert';

import 'package:http/http.dart' as http;

class Crud {

  get(url) async {
    var response = await http.get(Uri.parse(url), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    });
    return _processResponse(response);
  }

  post(url, entity) async {
    var response = await http.post(url,
        headers: {
          "content-type": "application/json"
        },
        body: jsonEncode(entity));
    return await _processResponse(response);
  }

  update(url, entity) async {
    var response = await http.put(url,
        headers: {
          "content-type": "application/json",
          "Connection": "keep-alive"
        },
        body: jsonEncode(entity));
    return _processResponse(response);
  }

  delete(url) async {
    var response = await http.delete(url, headers: {
      "content-type": "application/json",
    });
    return _processResponse(response);
  }

  _processResponse(response) async {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body != null ? jsonDecode(response.body) : null;
    } else if (response.statusCode == 403 || response.statusCode == 401) {
      return false;
    } else if (response.statusCode == 500) {
      return false;
    }
    return null;
  }
}
