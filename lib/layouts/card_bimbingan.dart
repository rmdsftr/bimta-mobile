import 'package:flutter/material.dart';

class CardBimbingan extends StatelessWidget {
  final String nama;
  final String nim;
  final String judul;
  final String? photoUrl;

  const CardBimbingan({
    required this.nama,
    required this.nim,
    required this.judul,
    this.photoUrl,
    super.key,
  });

  Widget _buildAvatar() {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Container(
        height: 35,
        width: 35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(100),
          child: Image.network(
            photoUrl!,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback ke avatar default jika gagal load
              return _buildDefaultAvatar();
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.grey[200],
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return _buildDefaultAvatar();
    }
  }

  Widget _buildDefaultAvatar() {
    return Container(
      height: 35,
      width: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        image: const DecorationImage(
          image: AssetImage("assets/images/avatar.png"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            offset: const Offset(0, 2),
            color: Colors.black.withOpacity(0.1),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      nim,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              judul,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
              ),
            ),
          )
        ],
      ),
    );
  }
}