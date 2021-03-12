import 'dart:convert';

import 'package:DevJurnal_new_world/model/response/signInResult.dart';

Response responseFromJson(String str) => Response.fromJson(json.decode(str));

Response responseFromSignInJson(String str) =>
    Response.fromSignInJson(json.decode(str));

String responseToJson(Response data) => json.encode(data.toJson());

class Response {
  Response({
    this.status,
    this.message,
    this.results,
  });

  bool status;
  String message;
  dynamic results;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: json["status"],
        message: json["message"],
        results: json["results"],
      );

  factory Response.fromSignInJson(Map<String, dynamic> mapJson) => Response(
        status: mapJson["status"],
        message: mapJson["message"],
        results: mapJson["results"],
      );

  SignInResult signInResult() =>
      signInResultFromJson(json.encode(this.results));

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "results": results,
      };
}

// final singInResult = json.encode(trelloListFromJson(response.body).results);
// signInResultFromJson(singInResult);
