import 'dart:io';

import 'package:budget_intelli/core/constants/app_strings.dart';
import 'package:budget_intelli/features/settings/models/pdf_content_model.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfRepository {
  Future<Uint8List> generatePdf({
    required List<PdfContentModel> pdfContentList,
    required String period,
    required String language,
    required String summaryDescription,
    required String totalPlannedAmountIncome,
    required String totalActualAmountIncome,
    required String totalActualAmountExpense,
    required String totalPlannedAmountExpense,
  }) async {
    final pdf = pw.Document();
    final imageLogo = await rootBundle.load('assets/images/splash.png');
    final imageList = imageLogo.buffer.asUint8List();
    var incomeTitle = 'Income:';
    var expenseTitle = 'Expense:';
    var summaryTitle = 'Summary:';
    var budgetReportTitle = 'Budget Report';
    var categoryTitle = 'Category';
    var plannedTitle = 'Planned';
    var actualTitle = 'Actual';

    if (language == AppStrings.indonesia) {
      incomeTitle = 'Pendapatan:';
      expenseTitle = 'Pengeluaran:';
      summaryTitle = 'Ringkasan:';
      budgetReportTitle = 'Laporan Anggaran';
      categoryTitle = 'Kategori';
      plannedTitle = 'Direncanakan';
      actualTitle = 'Aktual';
    }

    final incomePdfContentList = pdfContentList.where((e) => e.type == 'income').toList();
    final expensePdfContentList = pdfContentList.where((e) => e.type == 'expense').toList();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  children: [
                    pw.Image(
                      pw.MemoryImage(imageList),
                      width: 60,
                      height: 60,
                      fit: pw.BoxFit.cover,
                    ),
                    pw.SizedBox(width: 10),
                    pw.Text(
                      budgetReportTitle,
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColor.fromHex('#000000'),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  period,
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  incomeTitle,
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          color: PdfColor.fromHex('#f0f0f0'),
                          child: pw.Text(
                            categoryTitle,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          color: PdfColor.fromHex('#f0f0f0'),
                          child: pw.Text(
                            plannedTitle,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          color: PdfColor.fromHex('#f0f0f0'),
                          child: pw.Text(
                            actualTitle,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ...List.generate(
                      incomePdfContentList.length,
                      (index) {
                        final item = incomePdfContentList[index];
                        return pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(item.categoryName),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(item.plannedAmount),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(item.actualAmount),
                            ),
                          ],
                        );
                      },
                    ),

                    //   total
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Total',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            totalPlannedAmountIncome,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            totalActualAmountIncome,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  expenseTitle,
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(),
                  children: [
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          color: PdfColor.fromHex('#f0f0f0'),
                          child: pw.Text(
                            categoryTitle,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          color: PdfColor.fromHex('#f0f0f0'),
                          child: pw.Text(
                            plannedTitle,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          color: PdfColor.fromHex('#f0f0f0'),
                          child: pw.Text(
                            actualTitle,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    ...List.generate(
                      expensePdfContentList.length,
                      (index) {
                        final item = expensePdfContentList[index];
                        return pw.TableRow(
                          children: [
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(item.categoryName),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(item.plannedAmount),
                            ),
                            pw.Container(
                              padding: const pw.EdgeInsets.all(5),
                              child: pw.Text(item.actualAmount),
                            ),
                          ],
                        );
                      },
                    ),

                    //   total
                    pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            'Total',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            totalPlannedAmountExpense,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            totalActualAmountExpense,
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Text(
                  summaryTitle,
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  summaryDescription,
                  style: pw.TextStyle(
                    fontSize: 16,
                    color: PdfColor.fromHex('#000000'),
                  ),
                ),
              ],
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  Future<void> savePdf(
    String fileName,
    Uint8List pdfBytes,
  ) async {
    final output = await getTemporaryDirectory();
    final filePath = '${output.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    await OpenFile.open(filePath);
  }
}
