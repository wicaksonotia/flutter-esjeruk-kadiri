import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PdfViewerPage extends StatefulWidget {
  final String url;

  const PdfViewerPage({super.key, required this.url});

  @override
  State<PdfViewerPage> createState() => _PdfViewerPageState();
}

class _PdfViewerPageState extends State<PdfViewerPage> {
  String? localPath;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    downloadAndLoadPdf();
  }

  Future<void> downloadAndLoadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/temp.pdf';
      await Dio().download(widget.url, filePath);

      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      // print("Error: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD32F2F),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("PDF Viewer", style: TextStyle(color: Colors.white)),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : localPath == null
              ? const Center(child: Text("Gagal memuat PDF"))
              : PDFView(
                filePath: localPath!,
                enableSwipe: true,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
                onError: (error) {
                  // print(error.toString());
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error loading PDF: $error')),
                    );
                  }
                  setState(() {
                    isLoading = false;
                    localPath = null;
                  });
                },
                onRender: (pages) {
                  print("PDF rendered with $pages pages");
                },
              ),
    );
  }
}
