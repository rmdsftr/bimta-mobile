class ProfilePhoto {
  final String? photoUrl;

  ProfilePhoto({this.photoUrl});

  factory ProfilePhoto.fromJson(String? json) {
    return ProfilePhoto(
      photoUrl: json,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_url': photoUrl,
    };
  }

  bool get hasPhoto => photoUrl != null && photoUrl!.isNotEmpty;
}