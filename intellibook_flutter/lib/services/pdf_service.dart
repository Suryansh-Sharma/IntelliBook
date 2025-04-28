import 'package:flutter/services.dart';
import 'package:intellibook_test/api/dto/MonthlyTransactionReportDto.dart';
import 'package:intellibook_test/api/dto/TransactionByDateDto.dart';
import 'package:intellibook_test/flutter_flow/flutter_flow_util.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

// The rest of the code remains the same

class PdfService {
  Future<Uint8List> generateTransactionPdf(TransactionByDateDto report) async {
    final pdf = pw.Document();

    // Load the custom font
    final fontData =
        await rootBundle.load('assets/fonts/Roboto-VariableFont.ttf');
    final ttf = pw.Font.ttf(fontData);
    final now = DateTime.now();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Expense Report Of ${DateFormat('dd-MM-yyyy').format(
                  DateTime.parse(report.date),
                )}',
                style: pw.TextStyle(font: ttf, fontSize: 24),
              ),
            ),
            pw.Text(
                'Report Generated On : ${DateFormat('dd-MM-yyyy HH:mm:ss').format(now)}',
                style: pw.TextStyle(font: ttf)),
            pw.Text(
              'Total Categories: ${report.totalCategories}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.Text(
              'Total Expenditure: Rs ${report.totalExpendature}',
              style: pw.TextStyle(font: ttf),
            ),
            pw.SizedBox(height: 20),
            ...report.categories.map<pw.Widget>((category) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Category: ${category.name}',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold),
                  ),
                  pw.Text(
                    'Total Expenditure: Rs ${category.totalAmount}',
                    style: pw.TextStyle(font: ttf),
                  ),
                  pw.Text(
                    'Total Transactions: ${category.transactions.length}',
                    style: pw.TextStyle(font: ttf),
                  ),
                  pw.SizedBox(height: 10),
                  ...category.transactions.map<pw.Widget>((transaction) {
                    return pw.Container(
                      margin: pw.EdgeInsets.only(bottom: 10),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            '${transaction.description} - Rs ${transaction.amount}',
                            style: pw.TextStyle(
                                font: ttf, fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            'Time: ${transaction.time}',
                            style: pw.TextStyle(font: ttf),
                          ),
                          pw.Text(
                            'Tags: ${transaction.tags.map((tag) => tag.name).join(", ")}',
                            style: pw.TextStyle(font: ttf),
                          ),
                          pw.Divider(),
                        ],
                      ),
                    );
                  }),
                  pw.Divider(thickness: 1),
                ],
              );
            }),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<Uint8List> generateReportPagePdf(
      MonthlyTransactionReportDto report) async {
    final pdf = pw.Document();

    // Load the custom font
    final fontData =
        await rootBundle.load('assets/fonts/Roboto-VariableFont.ttf');
    final ttf = pw.Font.ttf(fontData);
    final now = DateTime.now();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            // Title
            pw.Text(
              report.title,
              style: pw.TextStyle(
                  font: ttf, fontSize: 22, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 10),

            // Report Details
            pw.Text("From: ${report.fromDate}  |  To: ${report.toDate}"),
            pw.Text("Total Transactions: ${report.totalTransactions}"),
            pw.Text("Total Amount: Rs ${report.totalTransactionAmount}"),
            pw.Text("Most Frequent Month: ${report.mostFrequentMonth}"),
            pw.Text("Highest Paid Month: ${report.highestPaidMonth}"),
            pw.SizedBox(height: 20),

            // Monthly Summary Table
            pw.Table.fromTextArray(
              border: pw.TableBorder.all(),
              cellAlignment: pw.Alignment.center,
              headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              headerHeight: 30,
              cellHeight: 25,
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(1),
              },
              headers: ['Month', 'Amount (Rs)'],
              data: (report.monthlySummary ?? []).map((month) {
                return [month.name, month.amount.toString()];
              }).toList(),
            ),
            pw.SizedBox(height: 20),

            // Footer with Timestamp
            pw.Align(
              alignment: pw.Alignment.centerRight,
              child: pw.Text(
                "Generated on: ${now.toLocal()}",
                style: pw.TextStyle(fontSize: 10),
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }
}
