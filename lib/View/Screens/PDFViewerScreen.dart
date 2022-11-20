import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PDFViewerScreen extends StatefulWidget {
  PDFDocument document;

  PDFViewerScreen(this.document);

  @override
  _PDFViewerScreenState createState() => _PDFViewerScreenState();
}

class _PDFViewerScreenState extends State<PDFViewerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffF9C303),
        title: Text("PDF View"),
      ),
      body: Center(
        child: PDFViewer(
          document: widget.document,
          enableSwipeNavigation: true,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}
