import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class PdfUploadField extends StatefulWidget {
  final String label;
  final void Function(String? path)? onFileSelected;

  const PdfUploadField({Key? key, required this.label, this.onFileSelected})
      : super(key: key);

  @override
  _PdfUploadFieldState createState() => _PdfUploadFieldState();
}

class _PdfUploadFieldState extends State<PdfUploadField> {
  String? fileName;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });

      if (widget.onFileSelected != null) {
        widget.onFileSelected!(result.files.single.path);
      }
    }
  }

  void _removeFile() {
    setState(() {
      fileName = null;
    });

    if (widget.onFileSelected != null) {
      widget.onFileSelected!(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: fileName == null ? _pickFile : null,
      child: AbsorbPointer(
        child: TextFormField(
          decoration: InputDecoration(
            labelText: fileName == null ? widget.label : null,
            labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 13
            ),
            prefixIcon: const Icon(Icons.upload_file, color: Color(0xFF754EA6)),
            suffixIcon: fileName != null
                ? IconButton(
              icon: const Icon(Icons.close, color: Colors.grey, size: 15),
              onPressed: _removeFile,
            )
                : null,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Colors.black12,
                  width: 1
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFF74ADDF),
                width: 1.5,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13
          ),
          controller: TextEditingController(text: fileName ?? ""),
        ),
      ),
    );
  }
}