import 'package:flutter/material.dart';

class JadwalActionAccepted extends StatelessWidget {
  final List<Widget> items;
  final int selectedIndex;
  final Future<void> Function(int index, String? message) onChanged;

  const JadwalActionAccepted({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged
  });

  Future<String?> showInputDialog(BuildContext context, int index) async {
    final TextEditingController controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog<String>(
      context: context,
      barrierDismissible: false, // Prevent dismiss by tapping outside
      builder: (context) {
        return AlertDialog(
          title: Text(
            index == 0 ? 'Selesaikan Bimbingan' : 'Batalkan Bimbingan',
            style: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Form(
            key: formKey,
            child: TextFormField(
              controller: controller,
              maxLines: 8,
              minLines: 5,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 13,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                hintText: index == 0
                    ? "Tulis pesan konfirmasi untuk mahasiswa"
                    : "Tulis alasan penolakan untuk mahasiswa",
                hintStyle: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: Colors.black38,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.black12,
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF74ADDF),
                    width: 1.5,
                  ),
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1,
                  ),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Colors.red,
                    width: 1.5,
                  ),
                ),
              ),
              validator: (value) {
                // Hanya wajib diisi untuk penolakan (index == 1)
                if (index == 1 && (value == null || value.trim().isEmpty)) {
                  return 'Alasan pembatalan harus diisi';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(null),
              child: const Text(
                'Batal',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  String message = controller.text.trim();
                  // Return special marker untuk indicate user clicked confirm button
                  Navigator.of(context).pop(message.isEmpty ? '' : message);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: index == 0
                    ? const Color(0xFF3BAB5A)
                    : const Color(0xFFA92E3D) ,
              ),
              child: Text(
                index == 0 ? 'Selesai' : 'Batalkan',
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bgColors = [
      const Color(0xFFDAEFDD),
      const Color(0xFFF5D2D5),
    ];

    final textColors = [
      const Color(0xFF3BAB5A),
      const Color(0xFFA92E3D),
    ];

    return Row(
      children: List.generate(items.length, (index) {
        // Balikkan index untuk urutan yang berlawanan
        final reversedIndex = items.length - 1 - index;
        bool isSelected = selectedIndex == reversedIndex;

        return Expanded(
          child: GestureDetector(
            onTap: () async {
              final message = await showInputDialog(context, reversedIndex);
              // Hanya panggil onChanged jika user tidak cancel
              // message == null berarti user klik 'Batal' atau dismiss dialog
              if (message != null) {
                await onChanged(reversedIndex, message.isEmpty ? null : message);
              }
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: bgColors[reversedIndex % bgColors.length],
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected
                    ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  )
                ]
                    : [],
              ),
              child: Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: textColors[reversedIndex % textColors.length],
                  ),
                  child: items[reversedIndex],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}