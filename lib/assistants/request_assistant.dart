import 'dart:convert';

import 'package:http/http.dart' as http;

class RequestAssistant {

  static Future<dynamic> receiveRequest(String url) async {
    http.Response httpResponse = await http.get(Uri.parse(url));

    //Success Response
    try {
      if (httpResponse.statusCode == 200) {
        String responseData = httpResponse.body; // JSON response
        var decodeResponseData = jsonDecode(responseData);
        return decodeResponseData;
      } else {
        return "Error Occurred, No Response.";
      }
    } catch(exp){
      return "Error Occurred, No Response.";
    }

  }
}