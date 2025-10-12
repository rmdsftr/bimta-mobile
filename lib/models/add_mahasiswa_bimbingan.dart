class AddMahasiswaBimbinganDto {
  final String dosenId;
  final List<String> mahasiswaId;

  AddMahasiswaBimbinganDto({
    required this.dosenId,
    required this.mahasiswaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'dosen_id': dosenId,
      'mahasiswa_id': mahasiswaId,
    };
  }

  factory AddMahasiswaBimbinganDto.fromJson(Map<String, dynamic> json) {
    return AddMahasiswaBimbinganDto(
      dosenId: json['dosen_id'] as String,
      mahasiswaId: List<String>.from(json['mahasiswa_id']),
    );
  }
}