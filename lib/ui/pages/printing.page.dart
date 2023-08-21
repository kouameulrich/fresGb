// ignore_for_file: must_be_immutable

import 'package:appfres/ui/pages/liste.payment.page.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PrintingPage extends StatelessWidget {
  pw.Document docPage;
  PrintingPage({Key? key, required this.docPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PaymentListPage(),
              )),
        ),
        centerTitle: true,
        title: const Text('Recibo de Pagamento'),
      ),
      body: PdfPreview(
        build: (format) => docPage.save(),
        allowPrinting: true,
        allowSharing: true,
        initialPageFormat: PdfPageFormat.a6,
        pdfFileName: 'Recu.pdf',
      ),
    );
  }
}
