class SignupModel {
  final String username;
  final String email;
  final String password;

  SignupModel({
    required this.username,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  factory SignupModel.fromJson(Map<String, dynamic> json) {
    return SignupModel(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}
