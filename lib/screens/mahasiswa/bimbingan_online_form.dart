import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class BimbinganForm extends StatefulWidget {
  const BimbinganForm({super.key});

  @override
  State<BimbinganForm> createState() => _BimbinganFormState();
}

class _BimbinganFormState extends State<BimbinganForm> {
  final _formkey = GlobalKey<FormState>();

  final TextEditingController _tanggalController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  String? _selectedFile; // untuk simpan file pdf yang dipilih

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Bimbingan Online",
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),


          Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                //Input tanggal dari sini ya Tegar
                const Text(
                  "Tanggal",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _tanggalController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    hintText: "mm/dd/yyyy",
                    border: OutlineInputBorder(),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _tanggalController.text =
                        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                // Sampe sini input tanggal yaa Tegar


                //Upload pdf dari sini ya Tegar
                const Text(
                  "Lampiran PDF",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () async {
                    FilePickerResult? result = await FilePicker.platform.pickFiles(
                    type: FileType.custom,
                    allowedExtensions: ['pdf'],
                    );
                    if (result != null) {
                      setState(() {
                        _selectedFile = result.files.single.name;
                      });
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey,
                        style: BorderStyle.solid
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          _selectedFile ?? "Pilih File PDF",
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "max 10 MB",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                //Sampe sini Upload pdf dari sini ya Tegar


                //Input pesan/note dari sini ya Tegar
                const Text(
                  "Pesan/Note",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _noteController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    hintText: "Agenda pembahasan atau catatan lainnya...",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                //Sampe sini input pesan/note dari sini ya Tegar


                // Tombol submit dari sini ya Tegar
                GestureDetector(
                  onTap: () {
                    if (_formkey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Jadwal Bimbingan berhasil diajukan!"),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                          colors: [
                            Color(0xFF677BE6),
                            Color(0xFF754EA6),
                          ],
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Center(
                      child: Text(
                          "Ajukan Jadwal",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Tombol submit sampe sini ya Tegar


              ],
            ),
          ),
        ],
      ),
    );
  }
}
