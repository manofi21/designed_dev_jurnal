import 'dart:convert';
import 'dart:io';
import 'package:DevJurnal_new_world/constant/named_navigation_collection.dart';
import 'package:DevJurnal_new_world/model/response/response.dart';
import 'package:DevJurnal_new_world/view/status_dialog.dart';
import 'package:DevJurnal_new_world/view_model/riverpod_notifier/task_API_riverpod.dart';
import 'package:http/http.dart' as http;

abstract class AuthenticationRepository {
  resendOtp();
  verifyOtp();
  forgotPassword();
  signIn();
  singUp();
  refreshToken();
  authenticationUser();
  signOut();
  resetPassword();
}

class AuthAccess {
  final baseUrl = "http://128.199.224.138:7088/dev-journal/api/v1/";

  Future<Response> singIn(String email, String pass) async {
    String apiUrl = baseUrl + "auth/sign-in";
    final body = {'email': email, 'password': pass};
    final jsonString = json.encode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(apiUrl, headers: headers, body: jsonString);
    final result = responseFromSignInJson(response.body);
    final singInResult = result.signInResult();
    showDialogClass({
      result.status: result.message + ". Halo ${singInResult.user.username}"
    }, navigation: HomeNavigtion, status: false);
    return result;
  }

  Future<Response> signUp(
      String username, String email, String password) async {
    String apiUrl = baseUrl + "auth/sign-up";
    final body = {'username': username, 'email': email, 'password': password};
    final jsonString = json.encode(body);
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final response =
        await http.post(apiUrl, headers: headers, body: jsonString);
    final result = responseFromJson(response.body);
    final String token =
        result.results.length == 0 ? result.message : result.results["token"];
    showDialogClass({result.status: result.message, false: token},
        navigation: OtpNavigation);
    return result;
  }

  Future<Response> otpVertification(String otp, String token) async {
    String apiUrl = baseUrl + "auth/verify-otp";
    final body = {'otp_code': otp};
    final jsonString = json.encode(body);
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer  $token"
    };
    final response =
        await http.post(apiUrl, headers: headers, body: jsonString);
    final result = responseFromJson(response.body);
    showDialogClass({result.status: result.message},
        navigation: SignInNavigation);
    return result;
  }

  Future<Response> resendOtp(String token) async {
    String apiUrl = baseUrl + "auth/resend-otp";
    final headers = {
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: "Bearer  $token"
    };
    final response = await http.get(apiUrl, headers: headers);
    final result = responseFromJson(response.body);
    showDialogClass({result.status: result.message});
    return result;
  }
}
