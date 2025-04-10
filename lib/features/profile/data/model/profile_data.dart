class ProfileData{
  int id;
  String username;
  String email;
  String createdAt;

  ProfileData({required this.id, required this.username, required this.email, required this.createdAt});

  factory ProfileData.fromJson(Map<String, dynamic> json) {
      return ProfileData(
        id: json['id'],
        username: json['username'],
        email: json['email'],
        createdAt: json['created_at'],
      );
    }
  Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = <String, dynamic>{};
      data['id'] = id;
      data['username'] = username;
      data['email'] = email;
      data['created_at'] = createdAt;
      return data;
    }
}