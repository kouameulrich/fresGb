// Importations
import 'package:appfres/models/dto/contract.dart';
import 'package:appfres/models/user.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrinterService {
  Future<pw.Document> printEncaissement(
      User agentConnected, Contract contract) async {
    final docPage = pw.Document();
    // Chargez l'image à l'aide de rootBundle.load() pour obtenir un Uint8List
    final Uint8List imageData =
        (await rootBundle.load("images/img.png")).buffer.asUint8List();
    final pw.MemoryImage logoImage = pw.MemoryImage(imageData);

    docPage.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a6,
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Divider(),
            pw.Text('INFORMACAO CLIENTE',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
            pw.Divider(),
            pw.SizedBox(
              height: 5,
            ),
            pw.Text('Recebido Cliente',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 15)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('CLIENTE: ${contract.clientName}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 12)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('NUMERO CONTADOR: ${contract.id}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 12)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('MONTANT',
                //     style:
                //         pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
                // pw.Text('${payment.}',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
            pw.SizedBox(
              height: 50,
            ),
            pw.Text(
                'Opérateur : ${agentConnected.firstname} ${agentConnected.lastname}'),
            pw.SizedBox(
              height: 40,
            ),
            pw.Container(
              alignment: pw.Alignment.center,
              height: 100,
              width: 100,
              child: pw.Image(
                  logoImage), // Utilisez pw.Image(logoImage) pour afficher l'image
            ),
          ],
        ),
      ),
    );
    return docPage;
  }
}
