import 'dart:io';

import 'package:billing_app/presentation/widgets/language_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/bill_item.dart';
import '../../bloc/bill/bill_bloc.dart';
import '../../bloc/bill/bill_state.dart';
import 'widgets/bill_list.dart';
import 'widgets/company_header.dart';
import 'widgets/add_bill_fab.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import '../../widgets/bill_search_delegate.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _exportMonthlyBills(
      BuildContext context, List<BillItem> bills) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      // Create Excel workbook
      var excel = Excel.createExcel();
      excel.delete('Sheet1'); // Delete the default sheet
      var sheet = excel['Bills']; // Use direct assignment instead of copy
      if (excel.sheets.containsKey('Sheet1')) {
        excel.delete('Sheet1');
      }

      // Add headers
      sheet.appendRow([
        TextCellValue('Bill Number'),
        TextCellValue('Customer Name'),
        TextCellValue('Location'),
        TextCellValue('Date'),
        TextCellValue('Total Items'),
        TextCellValue('Total Amount'),
        TextCellValue('Type')
      ]);

      // Add data
      for (var bill in bills) {
        sheet.appendRow([
          TextCellValue(bill.billNumber),
          TextCellValue(bill.customerName),
          TextCellValue(bill.location),
          TextCellValue(DateFormat('dd/MM/yyyy').format(DateTime.now())),
          TextCellValue(bill.lineItems.length.toString()),
          TextCellValue(bill.grandTotal.toString()),
          TextCellValue(bill.lineItems.any((item) => item.type == 'return')
              ? 'Return'
              : 'Sale')
        ]);
      }

      // Save file
      final directory = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final fileName = 'bills_${now.year}_${now.month}.xlsx';
      final file = File('${directory.path}/$fileName');

      await file.writeAsBytes(excel.encode()!);

      // Show options dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.exportOptions),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.share),
                title: Text(l10n.share),
                onTap: () async {
                  Navigator.pop(context);
                  await Share.shareXFiles(
                    [XFile(file.path)],
                    text: 'Monthly Bills Export',
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.download),
                title: Text(l10n.saveToDevice),
                onTap: () async {
                  Navigator.pop(context);
                  final downloadsDir =
                      Directory('/storage/emulated/0/Download');
                  final savedFile =
                      await file.copy('${downloadsDir.path}/$fileName');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(l10n.fileSaved),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.errorExporting),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: BillSearchDelegate(
                  context.read<BillBloc>().state is BillsLoaded
                      ? (context.read<BillBloc>().state as BillsLoaded).bills
                      : [],
                ),
              );
            },
          ),
          const LanguageSelector(),
        ],
      ),
      body: BlocListener<BillBloc, BillState>(
        listener: (context, state) {
          if (state is BillSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.billCreatedSuccess),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BillError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          } else if (state is BillDeleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(l10n.billDeletedSuccess),
                backgroundColor: Colors.orange,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        child: Column(
          children: [
            const CompanyHeader(),
            Expanded(
              child: BlocBuilder<BillBloc, BillState>(
                builder: (context, state) {
                  if (state is BillLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is BillsLoaded) {
                    return BillList(bills: state.bills);
                  } else if (state is BillError) {
                    return Center(child: Text(state.message));
                  }
                  return Center(child: Text(l10n.noBillsFound));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const AddBillFAB(),
          const SizedBox(height: 16),
          BlocBuilder<BillBloc, BillState>(
            builder: (context, state) {
              if (state is BillsLoaded) {
                return ActionChip(
                  avatar: const Icon(Icons.file_download),
                  label: Text(l10n.exportMonthly),
                  onPressed: () => _exportMonthlyBills(context, state.bills),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
