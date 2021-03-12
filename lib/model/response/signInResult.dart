import 'dart:convert';

SignInResult signInResultFromJson(String str) => SignInResult.fromJson(json.decode(str));

String signInResultToJson(SignInResult data) => json.encode(data.toJson());

class SignInResult {
    SignInResult({
        this.token,
        this.user,
    });

    String token;
    User user;

    factory SignInResult.fromJson(Map<String, dynamic> json) => SignInResult(
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    User({
        this.id,
        this.username,
        this.email,
    });

    int id;
    String username;
    String email;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
    };
}
