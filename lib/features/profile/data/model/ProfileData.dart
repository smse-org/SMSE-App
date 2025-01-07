class ProfileData{
  int id;
  String username;
  String email;
  String created_at;

  ProfileData({required this.id, required this.username, required this.email, required this.created_at});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
      return ProfileData(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        created_at: json['created_at'],
      );
    }
  Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = id;
      data['username'] = username;
      data['email'] = email;
      data['created_at'] = created_at;
      return data;
    }
}