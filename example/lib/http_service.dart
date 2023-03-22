import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class HttpService {
  // final String postsURL = "http://54.37.200.85/json/forms/inputForm.json";
  final String postsURL = "http://json.dexbytes.in/dynamicform.json";

  Future<String> getPosts() async {
    Response res = await get(Uri.parse(postsURL));
    if (res.statusCode == 200) {
      try {
       // var body = jsonDecode(res.body);
        String body = res.body;
        /*List<User> posts = body
                  .map(
                    (dynamic item) => User.fromJson(item),
              )
                  .toList();*/
        return body;
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
        return "";
      }
    } else {
      return "";
      //throw "Unable to retrieve posts.";
    }
  }

}

final HttpService httpService = HttpService();