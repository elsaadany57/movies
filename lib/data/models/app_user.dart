/// The profile stored alongside the Firebase Auth account, since Auth itself
/// has nowhere to keep a phone number or the chosen avatar.
class AppUser {
  const AppUser({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
  });

  final String uid;
  final String name;
  final String email;
  final String phone;

  /// Index into `AppAssets.avatars`.
  final int avatar;

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'] as String,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatar: (json['avatar'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'email': email,
        'phone': phone,
        'avatar': avatar,
      };
}
