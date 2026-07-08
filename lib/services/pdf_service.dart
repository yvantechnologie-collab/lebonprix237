import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/client.dart';
import '../models/devis.dart';
import '../models/facture.dart';

/// Couleurs utilisées dans les PDF (mêmes que la charte graphique)
const PdfColor _rouge = PdfColor.fromInt(0xFFE30613);
const PdfColor _noir = PdfColor.fromInt(0xFF111111);

class PdfService {
  static pw.Widget _entete(String titre, String numero, String date) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('LEBONPRIX 237',
                    style: pw.TextStyle(
                        fontSize: 22,
                        fontWeight: pw.FontWeight.bold,
                        color: _rouge)),
                pw.Text('by Elite Empire SARL',
                    style: const pw.TextStyle(fontSize: 10, color: _noir)),
                pw.SizedBox(height: 4),
                pw.Text('Douala Bepanda, Commissariat 7ème',
                    style: const pw.TextStyle(fontSize: 9)),
                pw.Text('Tél: 6 56 04 78 42 / 6 77 52 80 33',
                    style: const pw.TextStyle(fontSize: 9)),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(titre,
                    style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: _noir)),
                pw.Text('N° $numero'),
                pw.Text('Date: $date'),
              ],
            ),
          ],
        ),
        pw.Divider(color: _rouge, thickness: 2),
      ],
    );
  }

  static pw.Widget _infosClient(Client client) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey400),
        borderRadius: pw.BorderRadius.circular(6),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Client', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: _rouge)),
          pw.Text(client.nom),
          if (client.telephone.isNotEmpty) pw.Text('Tél: ${client.telephone}'),
          if (client.adresse.isNotEmpty) pw.Text('Adresse: ${client.adresse}'),
        ],
      ),
    );
  }

  static Future<void> genererDevisPdf(Devis devis, Client client) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _entete('DEVIS', devis.numero, devis.date),
              pw.SizedBox(height: 16),
              _infosClient(client),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                },
                children: [
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Description', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Montant (FCFA)', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  pw.TableRow(children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(devis.description),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(8),
                      child: pw.Text(devis.montant.toStringAsFixed(0)),
                    ),
                  ]),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'TOTAL: ${devis.montant.toStringAsFixed(0)} FCFA',
                  style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: _rouge),
                ),
              ),
              pw.SizedBox(height: 40),
              pw.Text('Statut: ${devis.statutLabel}'),
              pw.SizedBox(height: 60),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(children: [
                    pw.Text('Signature client'),
                    pw.SizedBox(height: 30),
                    pw.Container(width: 120, height: 1, color: PdfColors.grey600),
                  ]),
                  pw.Column(children: [
                    pw.Text('Lebonprix 237'),
                    pw.SizedBox(height: 30),
                    pw.Container(width: 120, height: 1, color: PdfColors.grey600),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static Future<void> genererFacturePdf(Facture facture, Client client) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _entete('FACTURE', facture.numero, facture.date),
              pw.SizedBox(height: 16),
              _infosClient(client),
              if (facture.devisRef.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 6),
                  child: pw.Text('Référence devis: ${facture.devisRef}'),
                ),
              pw.SizedBox(height: 20),
              pw.Text(facture.description),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey400),
                children: [
                  _ligneMontant('Montant total', facture.montantTotal),
                  _ligneMontant('Montant payé', facture.montantPaye),
                  _ligneMontant('Solde restant', facture.soldeRestant, accent: true),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(8),
                decoration: pw.BoxDecoration(
                  color: facture.estSoldee ? PdfColors.green50 : PdfColors.orange50,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Text(
                  facture.estSoldee ? 'FACTURE SOLDÉE' : 'PAIEMENT PARTIEL - Solde dû',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) async => pdf.save());
  }

  static pw.TableRow _ligneMontant(String label, double montant, {bool accent = false}) {
    return pw.TableRow(children: [
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
      ),
      pw.Padding(
        padding: const pw.EdgeInsets.all(8),
        child: pw.Text(
          '${montant.toStringAsFixed(0)} FCFA',
          style: pw.TextStyle(color: accent ? _rouge : _noir, fontWeight: accent ? pw.FontWeight.bold : null),
        ),
      ),
    ]);
  }
}
