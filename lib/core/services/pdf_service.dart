import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:printing/printing.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/bill_item.dart';
import '../../domain/entities/company_details.dart';
import '../../presentation/bloc/bill/bill_bloc.dart';
import '../../presentation/bloc/bill/bill_event.dart';
import '../utils/constants.dart';

class PdfService {
  Future<void> generateAndShareBill(
    BillItem bill,
    CompanyDetails? companyDetails,
  ) async {
    print('Starting PDF generation...');
    final pdf = pw.Document();

    print('Creating PDF content...');
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with purple background
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#4A148C'),
              ),
              child: pw.Text(
                'Neeraj Shop Bill',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            // Company and Invoice Details
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left side - Company Details
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (companyDetails != null) ...[
                        pw.Text('Shop Name: ${companyDetails.name}'),
                        pw.Text('Address: ${companyDetails.address}'),
                        pw.Text('Phone Number: ${companyDetails.phone}'),
                      ],
                    ],
                  ),
                ),
                // Right side - Invoice Details
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Bill Number: ${bill.billNumber}'),
                      pw.Text(
                          'Date: ${DateTime.now().toString().split(' ')[0]}'),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Customer Details Section with purple background
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#4A148C'),
              ),
              child: pw.Text(
                'Bill To:',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            // Customer Details Grid
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name: ${bill.customerName}'),
                      pw.Text('Address: ${bill.location}'),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          'Type: ${bill.grandTotal < 0 ? 'Return' : 'Sale'}'),
                      // Add more customer-related fields here
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Items Table
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(1), // S.No
                1: const pw.FlexColumnWidth(3), // Description
                2: const pw.FlexColumnWidth(1.5), // Type - increased width
                3: const pw.FlexColumnWidth(2), // Quantity
                4: const pw.FlexColumnWidth(2), // Rate
                5: const pw.FlexColumnWidth(2), // Amount
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#4A148C'),
                  ),
                  children: [
                    _buildTableHeader('S.No'),
                    _buildTableHeader('Description'),
                    _buildTableHeader('Type'),
                    _buildTableHeader('Quantity'),
                    _buildTableHeader('Rate'),
                    _buildTableHeader('Amount'),
                  ],
                ),
                // Items
                ...bill.lineItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return pw.TableRow(
                    children: [
                      _buildTableCell((index + 1).toString()),
                      _buildTableCell(item.description),
                      _buildTableCell(
                          item.type == billTypeSale ? 'Sale' : 'Return'),
                      _buildTableCell(item.net.toStringAsFixed(2)),
                      _buildTableCell(item.rate.toStringAsFixed(2)),
                      _buildTableCell(item.total.abs().toStringAsFixed(2)),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 20),

            // Totals and Payment Details
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Bank Details
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Bank Details',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        // Add your bank details here
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                // Total Amount
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Sales Total: Rs. ${_calculateSalesTotal(bill)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'Returns Total: Rs. ${_calculateReturnsTotal(bill)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Divider(),
                        pw.Text(
                          'Net Amount: Rs. ${_calculateTotal(bill)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Dynamic Fields
            if (bill.dynamicFields.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Additional Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    ...bill.dynamicFields.entries.map(
                      (entry) => pw.Text('${entry.key}: ${entry.value}'),
                    ),
                  ],
                ),
              ),
            ],

            // Terms and Conditions
            pw.SizedBox(height: 20),
            pw.Text(
              'Terms and conditions:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Text('1. All disputes are subject to local jurisdiction'),
          ],
        ),
      ),
    );

    print('Saving PDF...');
    final output = await getTemporaryDirectory();
    final file = File('${output.path}/Bill_${bill.billNumber}.pdf');
    await file.writeAsBytes(await pdf.save());

    print('Sharing PDF...');
    await Share.shareXFiles(
      [XFile(file.path)],
      subject: 'Bill ${bill.billNumber}',
    );
    print('PDF shared successfully!');
  }

  Future<void> printBill(
    BuildContext context,
    BillItem bill,
    CompanyDetails? companyDetails,
  ) async {
    context.read<BillBloc>().add(SaveBillEvent(bill));

    print('Starting PDF generation for printing...');
    final pdf = pw.Document();

    print('Creating PDF content...');
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header with purple background
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#4A148C'),
              ),
              child: pw.Text(
                'Neeraj Shop Bill',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            // Company and Invoice Details
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Left side - Company Details
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      if (companyDetails != null) ...[
                        pw.Text('Shop Name: ${companyDetails.name}'),
                        pw.Text('Address: ${companyDetails.address}'),
                        pw.Text('Phone Number: ${companyDetails.phone}'),
                      ],
                    ],
                  ),
                ),
                // Right side - Invoice Details
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Bill Number: ${bill.billNumber}'),
                      pw.Text(
                          'Date: ${DateTime.now().toString().split(' ')[0]}'),
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Customer Details Section with purple background
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex('#4A148C'),
              ),
              child: pw.Text(
                'Bill To:',
                style: pw.TextStyle(
                  color: PdfColors.white,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),

            pw.SizedBox(height: 10),

            // Customer Details Grid
            pw.Row(
              children: [
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Name: ${bill.customerName}'),
                      pw.Text('Address: ${bill.location}'),
                    ],
                  ),
                ),
                pw.Expanded(
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          'Type: ${bill.grandTotal < 0 ? 'Return' : 'Sale'}'),
                      // Add more customer-related fields here
                    ],
                  ),
                ),
              ],
            ),

            pw.SizedBox(height: 20),

            // Items Table
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(1), // S.No
                1: const pw.FlexColumnWidth(3), // Description
                2: const pw.FlexColumnWidth(1.5), // Type - increased width
                3: const pw.FlexColumnWidth(2), // Quantity
                4: const pw.FlexColumnWidth(2), // Rate
                5: const pw.FlexColumnWidth(2), // Amount
              },
              children: [
                // Header
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColor.fromHex('#4A148C'),
                  ),
                  children: [
                    _buildTableHeader('S.No'),
                    _buildTableHeader('Description'),
                    _buildTableHeader('Type'),
                    _buildTableHeader('Quantity'),
                    _buildTableHeader('Rate'),
                    _buildTableHeader('Amount'),
                  ],
                ),
                // Items
                ...bill.lineItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  return pw.TableRow(
                    children: [
                      _buildTableCell((index + 1).toString()),
                      _buildTableCell(item.description),
                      _buildTableCell(
                          item.type == billTypeSale ? 'Sale' : 'Return'),
                      _buildTableCell(item.net.toStringAsFixed(2)),
                      _buildTableCell(item.rate.toStringAsFixed(2)),
                      _buildTableCell(item.total.abs().toStringAsFixed(2)),
                    ],
                  );
                }),
              ],
            ),

            pw.SizedBox(height: 20),

            // Totals and Payment Details
            pw.Row(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Bank Details
                pw.Expanded(
                  flex: 2,
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Bank Details',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        // Add your bank details here
                      ],
                    ),
                  ),
                ),
                pw.SizedBox(width: 20),
                // Total Amount
                pw.Expanded(
                  child: pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'Sales Total: Rs. ${_calculateSalesTotal(bill)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Text(
                          'Returns Total: Rs. ${_calculateReturnsTotal(bill)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                        pw.Divider(),
                        pw.Text(
                          'Net Amount: Rs. ${_calculateTotal(bill)}',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Dynamic Fields
            if (bill.dynamicFields.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Additional Details',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    ...bill.dynamicFields.entries.map(
                      (entry) => pw.Text('${entry.key}: ${entry.value}'),
                    ),
                  ],
                ),
              ),
            ],

            // Terms and Conditions
            pw.SizedBox(height: 20),
            pw.Text(
              'Terms and conditions:',
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 5),
            pw.Text('1. All disputes are subject to local jurisdiction'),
          ],
        ),
      ),
    );

    // Print the document
    await Printing.layoutPdf(
      onLayout: (format) async => await pdf.save(),
    );
  }

  pw.Widget _buildTableHeader(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          color: PdfColors.white,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    );
  }

  pw.Widget _buildTableCell(String text) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(text),
    );
  }

  String _calculateTotal(BillItem bill) {
    final total = bill.lineItems.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    return total.toStringAsFixed(2);
  }

  String _calculateSalesTotal(BillItem bill) {
    final total = bill.lineItems
        .where((item) => item.type == billTypeSale)
        .fold<double>(0, (sum, item) => sum + item.total);
    return total.toStringAsFixed(2);
  }

  String _calculateReturnsTotal(BillItem bill) {
    final total = bill.lineItems
        .where((item) => item.type == billTypeReturn)
        .fold<double>(0, (sum, item) => sum + item.total.abs());
    return total.toStringAsFixed(2);
  }
}
