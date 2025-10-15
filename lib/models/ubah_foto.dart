class ProfilePhotoResponse {
  final bool success;
  final String? photoUrl;
  final String message;

  ProfilePhotoResponse({
    required this.success,
    this.photoUrl,
    required this.message,
  });

  factory ProfilePhotoResponse.fromJson(Map<String, dynamic> json) {
    return ProfilePhotoResponse(
      success: true,
      photoUrl: json as String?,
      message: 'Foto profil berhasil diubah',
    );
  }

  factory ProfilePhotoResponse.error(String message) {
    return ProfilePhotoResponse(
      success: false,
      photoUrl: null,
      message: message,
    );
  }
}