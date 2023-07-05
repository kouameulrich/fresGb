import 'package:appfres/models/agent.dart';
import 'package:appfres/models/encaissement.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PrinterService {
  printEncaissement(Agent agentConnected, Encaissement Encaissement) async {
    final docPage = pw.Document();
    final logoImage = pw.MemoryImage(
        (await rootBundle.load('images/img.png')).buffer.asUint8List());
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
            pw.Text(
                'CLIENTE: ${Encaissement.nomClient} ${Encaissement.prenomClient}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 12)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('NUMERO CONTADOR: ${Encaissement.numeroCompteur}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 12)),
            pw.SizedBox(
              height: 10,
            ),
            pw.Text('${Encaissement.montantClient}',
                style:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 25)),
            pw.Text('NUMERO CLIENTE: : ${Encaissement.telephoneClient}',
                style: pw.TextStyle(
                    fontWeight: pw.FontWeight.normal, fontSize: 12)),
            // pw.Text(
            //     'Opérateur : ${agentConnected!.nom} ${agentConnected!.prenom}'),
            pw.SizedBox(
              height: 50,
            ),
            pw.Text(
                'Opérateur : ${agentConnected.nom} ${agentConnected.prenom}'),
            pw.SizedBox(
              height: 40,
            ),
            pw.Image(
              alignment: pw.Alignment.center,
              height: 100,
              width: 100,
              logoImage,
            ),
          ],
        ),
      ),
    );
    return docPage;
  }
}
