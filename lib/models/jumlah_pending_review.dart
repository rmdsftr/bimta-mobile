class JumlahPendingReview {
  final int jumlah;

  JumlahPendingReview({
    required this.jumlah,
  });

  factory JumlahPendingReview.fromJson(Map<String, dynamic> json) {
    return JumlahPendingReview(
      jumlah: json['jumlah'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jumlah': jumlah,
    };
  }
}