class UserLogin {
  final String userId;
  final String username;
  final String fullName;
  final String phoneNumber;

  UserLogin({
    required this.userId,
    required this.username,
    required this.fullName,
    required this.phoneNumber,
  });

  // Method untuk konversi dari JSON ke UserLogin model
  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      userId: json['user_id'],
      username: json['username'],
      fullName: json['full_name'],
      phoneNumber: json['phone_number'],
    );
  }

  // Method untuk konversi dari UserLogin model ke JSON
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'full_name': fullName,
      'phone_number': phoneNumber,
    };
  }
}
