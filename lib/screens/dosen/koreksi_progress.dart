import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:ui' as ui;
import 'package:path_provider/path_provider.dart';
import 'package:bimta/widgets/background.dart';

class PdfAnnotationScreen extends StatefulWidget {
  final String fileUrl;
  final String fileName;

  const PdfAnnotationScreen({
    super.key,
    required this.fileUrl,
    required this.fileName,
  });

  @override
  State<PdfAnnotationScreen> createState() => _PdfAnnotationScreenState();
}

class _PdfAnnotationScreenState extends State<PdfAnnotationScreen> {
  final PdfViewerController _pdfViewerController = PdfViewerController();

  String? localPath;
  bool isLoading = true;
  String? errorMessage;
  int currentPage = 1;
  int totalPages = 0;

  // Annotation tools
  String selectedTool = 'none'; // none, highlight, comment, strikethrough, underline
  List<AnnotationData> annotations = [];
  bool showToolbar = false;

  // For text selection
  PdfTextSelectionChangedDetails? _textSelectionDetails;

  @override
  void initState() {
    super.initState();
    _downloadAndSavePdf();
  }

  @override
  void dispose() {
    _pdfViewerController.dispose();
    super.dispose();
  }

  Future<void> _downloadAndSavePdf() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await http.get(Uri.parse(widget.fileUrl));

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final fileName = widget.fileName.endsWith('.pdf')
            ? widget.fileName
            : '${widget.fileName}.pdf';
        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(response.bodyBytes);

        setState(() {
          localPath = file.path;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Gagal mengunduh file PDF (Status: ${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  void _showCommentDialog() {
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Tambah Komentar',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: TextField(
          controller: commentController,
          maxLines: 3,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Tulis komentar...',
            hintStyle: const TextStyle(fontFamily: 'Poppins'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () {
              if (commentController.text.isNotEmpty) {
                setState(() {
                  annotations.add(AnnotationData(
                    type: 'comment',
                    page: currentPage,
                    comment: commentController.text,
                    selectedText: _textSelectionDetails?.selectedText,
                    timestamp: DateTime.now(),
                  ));
                  selectedTool = 'none';
                });

                // Clear text selection
                _pdfViewerController.clearSelection();
                _textSelectionDetails = null;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Komentar ditambahkan pada halaman $currentPage',
                      style: const TextStyle(fontFamily: 'Poppins'),
                    ),
                    backgroundColor: Colors.blue,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Simpan',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTextAnnotation(String type, Color color, String label) {
    if (_textSelectionDetails != null &&
        _textSelectionDetails!.selectedText != null &&
        _textSelectionDetails!.selectedText!.isNotEmpty) {

      setState(() {
        annotations.add(AnnotationData(
          type: type,
          page: currentPage,
          selectedText: _textSelectionDetails!.selectedText,
          comment: '$label: "${_textSelectionDetails!.selectedText}"',
          timestamp: DateTime.now(),
        ));
        selectedTool = 'none';
      });

      // Clear selection
      _pdfViewerController.clearSelection();
      _textSelectionDetails = null;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$label ditambahkan pada halaman $currentPage',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: color,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Silakan pilih teks terlebih dahulu',
            style: const TextStyle(fontFamily: 'Poppins'),
          ),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  void _handleAction(String action) async {
    String message = '';
    String detail = '';

    switch (action) {
      case 'Draft':
        message = 'Simpan sebagai Draft';
        detail = 'Dokumen akan disimpan sebagai draft dan dapat diedit kembali nanti.';
        break;
      case 'Koreksi':
        message = 'Kirim untuk Koreksi';
        detail = 'Dokumen akan dikirim kembali untuk dilakukan koreksi.';
        break;
      case 'Approved':
        message = 'Setujui Dokumen';
        detail = 'Dokumen akan disetujui dan tidak dapat diubah lagi.';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          message,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              detail,
              style: const TextStyle(fontFamily: 'Poppins', fontSize: 13),
            ),
            if (annotations.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${annotations.length} anotasi akan disimpan',
                        style: const TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 11,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(fontFamily: 'Poppins')),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);

              // TODO: Send annotations to API
              final annotationsJson = annotations.map((a) => a.toJson()).toList();
              print('Saving annotations: $annotationsJson');
              print('Action: $action');
              print('File URL: ${widget.fileUrl}');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Dokumen disimpan sebagai $action dengan ${annotations.length} anotasi',
                    style: const TextStyle(fontFamily: 'Poppins'),
                  ),
                  backgroundColor: action == 'Draft'
                      ? Colors.grey
                      : action == 'Koreksi'
                      ? Colors.orange
                      : Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );

              Future.delayed(const Duration(milliseconds: 500), () {
                Navigator.pop(context);
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: action == 'Draft'
                  ? Colors.grey
                  : action == 'Koreksi'
                  ? Colors.orange
                  : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Ya, Lanjutkan',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.fileName,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (!isLoading && errorMessage == null)
              Text(
                totalPages > 0
                    ? 'Halaman $currentPage dari $totalPages'
                    : 'Memuat...',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 10,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          if (!isLoading && errorMessage == null)
            IconButton(
              icon: Icon(
                showToolbar ? Icons.close : Icons.edit,
                color: showToolbar ? Colors.blue : Colors.black,
              ),
              onPressed: () {
                setState(() {
                  showToolbar = !showToolbar;
                  if (!showToolbar) {
                    selectedTool = 'none';
                    _pdfViewerController.clearSelection();
                    _textSelectionDetails = null;
                  }
                });
              },
            ),
        ],
      ),
      body: Stack(
        children: [
          const BackgroundWidget(),
          Column(
            children: [
              const SizedBox(height: 90),

              // Annotation Toolbar
              if (showToolbar)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Instruction text
                      if (_textSelectionDetails == null ||
                          _textSelectionDetails?.selectedText == null)
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Pilih teks pada PDF untuk menambahkan anotasi',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Selected text preview
                      if (_textSelectionDetails?.selectedText != null &&
                          _textSelectionDetails!.selectedText!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle, size: 16, color: Colors.green.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Terpilih: "${_textSelectionDetails!.selectedText}"',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 11,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Tool buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildToolButton(
                            icon: Icons.highlight,
                            label: 'Highlight',
                            tool: 'highlight',
                            color: Colors.yellow.shade700,
                          ),
                          _buildToolButton(
                            icon: Icons.comment,
                            label: 'Komentar',
                            tool: 'comment',
                            color: Colors.blue,
                          ),
                          _buildToolButton(
                            icon: Icons.strikethrough_s,
                            label: 'Coret',
                            tool: 'strikethrough',
                            color: Colors.red,
                          ),
                          _buildToolButton(
                            icon: Icons.border_color,
                            label: 'Underline',
                            tool: 'underline',
                            color: Colors.green,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

              // PDF Viewer
              Expanded(
                child: isLoading
                    ? Center(
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        const Text(
                          'Mengunduh PDF...',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : errorMessage != null
                    ? Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 60,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _downloadAndSavePdf,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    : Container(
                  margin: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 16,
                    top: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SfPdfViewer.file(
                      File(localPath!),
                      controller: _pdfViewerController,
                      canShowScrollHead: true,
                      canShowScrollStatus: true,
                      enableDoubleTapZooming: true,
                      onDocumentLoaded: (details) {
                        setState(() {
                          totalPages = details.document.pages.count;
                        });
                      },
                      onPageChanged: (details) {
                        setState(() {
                          currentPage = details.newPageNumber;
                        });
                      },
                      onTextSelectionChanged: (details) {
                        setState(() {
                          _textSelectionDetails = details;
                        });
                      },
                    ),
                  ),
                ),
              ),

              // Annotation List
              if (annotations.isNotEmpty)
                Container(
                  constraints: const BoxConstraints(maxHeight: 150),
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.edit_note, size: 16, color: Colors.blue),
                            const SizedBox(width: 8),
                            Text(
                              'Anotasi (${annotations.length})',
                              style: const TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: annotations.length,
                          itemBuilder: (context, index) {
                            final annotation = annotations[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 6),
                              elevation: 0,
                              color: Colors.grey.shade50,
                              child: ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                leading: Icon(
                                  annotation.type == 'comment'
                                      ? Icons.comment
                                      : annotation.type == 'highlight'
                                      ? Icons.highlight
                                      : annotation.type == 'strikethrough'
                                      ? Icons.strikethrough_s
                                      : Icons.border_color,
                                  size: 20,
                                  color: annotation.type == 'comment'
                                      ? Colors.blue
                                      : annotation.type == 'highlight'
                                      ? Colors.yellow.shade700
                                      : annotation.type == 'strikethrough'
                                      ? Colors.red
                                      : Colors.green,
                                ),
                                title: Text(
                                  annotation.comment ?? annotation.type.toUpperCase(),
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 12,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  'Hal. ${annotation.page}',
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 10,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18),
                                  color: Colors.red.shade400,
                                  onPressed: () {
                                    setState(() {
                                      annotations.removeAt(index);
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

              // Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleAction('Draft'),
                        icon: const Icon(Icons.drafts_outlined, size: 18),
                        label: const Text(
                          'Draft',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade400,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleAction('Koreksi'),
                        icon: const Icon(Icons.edit_note, size: 18),
                        label: const Text(
                          'Koreksi',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => _handleAction('Approved'),
                        icon: const Icon(Icons.check_circle_outline, size: 18),
                        label: const Text(
                          'Approved',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required String tool,
    required Color color,
  }) {
    final isSelected = selectedTool == tool;

    return InkWell(
      onTap: () {
        setState(() {
          selectedTool = tool;
        });

        if (tool == 'comment') {
          _showCommentDialog();
        } else {
          // For highlight, strikethrough, and underline
          _handleTextAnnotation(tool, color, label);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 10,
                color: isSelected ? color : Colors.black87,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Annotation Data Model
class AnnotationData {
  final String type;
  final int page;
  final String? comment;
  final String? selectedText;
  final DateTime timestamp;

  AnnotationData({
    required this.type,
    required this.page,
    this.comment,
    this.selectedText,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'page': page,
      'comment': comment,
      'selected_text': selectedText,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}