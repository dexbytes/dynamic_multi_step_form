import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HttpService {
  final String postsURL = "http://json.dexbytes.in/dynamicform.json";

  Future<String> getPosts() async {
    Response res = await get(Uri.parse(postsURL));
    if (res.statusCode == 200) {
      try {
       // var body = jsonDecode(res.body);
        String body = res.body;
        return body;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return "";
      }
    } else {
      return "";
    }
  }

}

final HttpService httpService = HttpService();