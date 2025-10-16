import 'package:bimta/widgets/action_buttons_accepted.dart';
import 'package:bimta/widgets/action_buttons_jadwal.dart';
import 'package:flutter/material.dart';

class CardBimbinganOffline extends StatelessWidget {
  final String nama;
  final String nim;
  final String? photoUrl;
  final String tanggal;
  final String waktu;
  final String lokasi;
  final String judul;
  final String pesan;
  final String status;
  final String? pesanDosen;
  final Future<void> Function(String? message)? onAccept;
  final Future<void> Function(String? message)? onReject;
  final Future<void> Function(String? message)? onCancel;
  final Future<void> Function(String? message)? onDone;

  const CardBimbinganOffline({
    super.key,
    required this.nama,
    required this.nim,
    this.photoUrl,
    required this.tanggal,
    required this.waktu,
    required this.lokasi,
    required this.judul,
    required this.pesan,
    required this.status,
    this.pesanDosen,
    this.onAccept,
    this.onReject,
    this.onCancel,
    this.onDone,
  });

  Color getStatusColor(String status) {
    switch (status) {
      case 'waiting':
        return const Color(0xFF5B6AE3);
      case 'accepted':
        return const Color(0xFF4CAF50);
      case 'declined':
        return const Color(0xFFFF6B6B);
      default:
        return Colors.grey;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'waiting':
        return 'Waiting';
      case 'accepted':
        return 'Accepted';
      case 'declined':
        return 'Declined';
      default:
        return 'Unknown';
    }
  }

  Future<void> _handleAction(BuildContext context, int index, String? message) async {
    if (index == 0) {
      // Accept
      if (onAccept != null) {
        await onAccept!(message);
      }
    } else if (index == 1) {
      // Reject
      if (onReject != null) {
        await onReject!(message);
      }
    }
  }

  Future<void> _handleAccepted(BuildContext context, int index, String? message) async {
    if (index == 0) {
      // Accept
      if (onDone != null) {
        await onDone!(message);
      }
    } else if (index == 1) {
      // Reject
      if (onCancel != null) {
        await onCancel!(message);
      }
    }
  }

  Widget _buildAvatar() {
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      return Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: getStatusColor(status).withOpacity(0.3),
              blurRadius: 8,
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
              // Fallback ke avatar dengan inisial jika gagal load gambar
              return _buildInitialAvatar();
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
      return _buildInitialAvatar();
    }
  }

  Widget _buildInitialAvatar() {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            getStatusColor(status),
            getStatusColor(status).withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(100),
        boxShadow: [
          BoxShadow(
            color: getStatusColor(status).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          nama.substring(0, 1).toUpperCase(),
          style: const TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
        border: Border.all(
          color: Colors.grey.withOpacity(0.08),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan avatar dan status
          Row(
            children: [
              _buildAvatar(),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Color(0xFF1F2937),
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      nim,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(status).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: getStatusColor(status).withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  getStatusLabel(status),
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: getStatusColor(status),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Divider
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.grey.withOpacity(0.0),
                  Colors.grey.withOpacity(0.15),
                  Colors.grey.withOpacity(0.0),
                ],
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Tanggal dan Waktu
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.calendar_today_rounded,
                  "Tanggal",
                  tanggal,
                  const Color(0xFF3B82F6),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoItem(
                  Icons.access_time_rounded,
                  "Waktu",
                  waktu,
                  const Color(0xFF8B5CF6),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Lokasi
          _buildInfoItem(
            Icons.location_on_rounded,
            "Lokasi",
            lokasi,
            const Color(0xFFEF4444),
          ),

          const SizedBox(height: 16),

          // Topik Pembahasan
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.grey.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.topic_rounded,
                      size: 16,
                      color: Colors.grey[700],
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Topik Pembahasan",
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  judul,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    color: Color(0xFF1F2937),
                    height: 1.5,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                if (pesan.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    pesan,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          if(pesanDosen != null && pesanDosen!.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.orange[50],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.topic_rounded,
                        size: 16,
                        color: Colors.grey[700],
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Balasan Anda",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pesanDosen ?? "",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 12,
                      color: Colors.grey[700],
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],

          // Action Buttons
          if (status != 'accepted' && status != 'declined') ...[
            const SizedBox(height: 18),
            JadwalActionButtons(
              selectedIndex: -1,
              onChanged: (index, message) async {
                await _handleAction(context, index, message);
              },
              items: const [
                Text("Terima"),
                Text("Tolak"),
              ],
            ),
          ],

          if (status == 'accepted') ...[
            const SizedBox(height: 18),
            JadwalActionAccepted(
              selectedIndex: -1,
              onChanged: (index, message) async {
                await _handleAccepted(context, index, message);
              },
              items: const [
                Text("Selesai"),
                Text("Batalkan"),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value, Color color) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: color,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Color(0xFF1F2937),
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}