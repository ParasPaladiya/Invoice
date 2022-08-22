import 'dart:io';
import 'dart:typed_data';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:sticker_editor/product.dart';

class CustomRow {
  final String description;
  final String quantity;
  final String unitPrice;
  final String total;
  CustomRow(this.description, this.quantity, this.unitPrice, this.total);
}

class GetInvoice {
  Future<Uint8List> getInvoice(List<Products> soldProducts) {
    final pdf = pw.Document();
    final List<CustomRow> elements = [
      CustomRow("Description", "Quantity", "UnitPrice", "Total"),
      for (var product in soldProducts)
        CustomRow(
          product.productName,
          product.productPrice.toString(),
          product.productQuantity.toString(),
          (product.productPrice * product.productQuantity).toString(),
        ),
      CustomRow(
        "Total Amount",
        "",
        '',
        "${getTotal(soldProducts)} Rs.",
      ),
    ];
    pw.Divider(thickness: 5, color: PdfColors.black);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Invoice',
                            style: pw.TextStyle(
                                fontSize: 30,
                                fontWeight: (pw.FontWeight.bold))),
                        pw.Text('Flutter Approach',
                            style: const pw.TextStyle(
                              fontSize: 15,
                              color: PdfColors.grey,
                            ))
                      ],
                    ),
                    pw.Spacer(),
                    pw.Column(
                      mainAxisSize: pw.MainAxisSize.min,
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text(
                          'Paras Paladiya',
                          style: pw.TextStyle(
                            fontSize: 15.5,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                        pw.Text(
                          'Paras@gmail.com',
                          style: const pw.TextStyle(
                            fontSize: 15.5,
                          ),
                        ),
                        pw.Text(
                          DateTime.now().toString(),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 30),
                pw.Divider(),
                pw.Text(
                    'Dear Customer,Thanks for buying from us,below are the list we sold at higher than usual price to you,visit again thank you',
                    style: const pw.TextStyle(fontSize: 16)),
                pw.SizedBox(height: 25),
                pw.Container(
                  height: 200,
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(8),
                  ),
                  child: itemList(elements),
                ),
                pw.SizedBox(height: 25),
              ]);
        },
      ),
    );
    return pdf.save();
  }

  pw.Expanded itemList(List<CustomRow> elements) {
    return pw.Expanded(
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          for (var element in elements)
            pw.Row(
              children: [
                pw.Expanded(
                    child: pw.Text(element.description,
                        textAlign: pw.TextAlign.left)),
                pw.Expanded(
                    child: pw.Text(element.quantity,
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                    child: pw.Text(element.unitPrice,
                        textAlign: pw.TextAlign.right)),
                pw.Expanded(
                  child: pw.Text(
                    element.total,
                    textAlign: pw.TextAlign.right,
                    style: const pw.TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          pw.Spacer(),
          pw.Divider(),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Flutter Approach',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Address: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '1 SaiRow House near City Heart amroli Surat',
              ),
            ],
          ),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.center,
            children: [
              pw.Text(
                'Email: ',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'Paras@gmail.com',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> openPDF(Uint8List data) async {
    final dir = await getExternalStorageDirectory();
    final filePath = '${dir?.path}/Invoice.pdf';
    final file = File(filePath);
    await file.writeAsBytes(data);
    OpenFile.open(filePath);
  }

  String getTotal(List<Products> products) {
    return products
        .fold(
            0,
            (int prev, element) =>
                prev + (element.productPrice * element.productQuantity))
        .toStringAsFixed(0);
  }
}
