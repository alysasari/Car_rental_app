import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:car_rental_project/models/order_model.dart';
import 'package:car_rental_project/database/database_helper.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class ReceiptGenerator {
  static Future<void> generatePDF(Order order) async {
    final pdf = pw.Document();

    final robotoData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final robotoBoldData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');
    final roboto = pw.Font.ttf(robotoData);
    final robotoBold = pw.Font.ttf(robotoBoldData);

    // Tambahkan halaman utama
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Center(
                  child: pw.Text(
                    "Car Rental Booking Receipt",
                    style: pw.TextStyle(
                      fontSize: 22,
                      font: robotoBold,
                      color: PdfColors.blue900,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Divider(),
                pw.SizedBox(height: 10),

                // Detail order
                _row("Car", order.carName, roboto, robotoBold),
                _row("Start Date", order.startDate.split('T').first, roboto, robotoBold),
                _row("End Date", order.endDate.split('T').first, roboto, robotoBold),
                _row("Pickup Time", order.pickupTime, roboto, robotoBold),
                _row("Status", order.status, roboto, robotoBold),
                _row("Currency", order.currency, roboto, robotoBold),
                _row("Total", "${order.currency} ${(order.amount).toStringAsFixed(2)}", roboto, robotoBold),

                pw.SizedBox(height: 30),
                pw.Divider(),

                pw.Center(
                  child: pw.Text(
                    "Thank you for choosing RentSmart!",
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700, font: roboto),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );

    //  Minta izin akses penyimpanan
    var status = await Permission.storage.request();
    if (!status.isGranted) {
      throw Exception('Storage permission not granted');
    }

    // Tentukan folder Download yang aman
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = (await getExternalStorageDirectory())!;
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final filePath = "${directory.path}/Booking_Receipt_${order.id}.pdf";

    //  Simpan PDF
    final pdfBytes = await pdf.save();
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);

    // Simpan path struk ke database
    try {
      await DatabaseHelper.instance.insertReceipt({
        'order_id': order.id,
        'pdf_path': filePath,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Failed to insert receipt record: $e');
    }

    print("✅ Receipt saved at: $filePath");

    // 🔹 Buka PDF secara otomatis
    final result = await OpenFile.open(filePath);
    print("Open PDF result: $result");
  }

  static pw.Widget _row(String label, String value, pw.Font font, pw.Font boldFont) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 6),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 12,
              font: font,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 12,
              font: boldFont,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }
}
