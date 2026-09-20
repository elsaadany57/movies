/// One entry of the details endpoint's `cast` array.
class CastMember {
  const CastMember({
    required this.name,
    required this.character,
    required this.imageUrl,
  });

  final String name;
  final String character;
  final String imageUrl;

  factory CastMember.fromJson(Map<String, dynamic> json) {
    return CastMember(
      name: (json['name'] as String?) ?? '',
      character: (json['character_name'] as String?) ?? '',
      imageUrl: (json['url_small_image'] as String?) ?? '',
    );
  }
}
