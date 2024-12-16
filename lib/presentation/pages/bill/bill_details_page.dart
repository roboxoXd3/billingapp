import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../domain/entities/bill_item.dart';
import '../../../domain/entities/bill_line_item.dart';
import '../../../core/services/pdf_service.dart';
import '../../../core/utils/constants.dart';
import '../../bloc/company/company_bloc.dart';
import '../../bloc/company/company_state.dart';

class BillDetailsPage extends StatelessWidget {
  final BillItem bill;
  final _pdfService = PdfService();

  BillDetailsPage({super.key, required this.bill});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.billDetails),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/edit-bill',
                arguments: bill,
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _handleShare(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBillHeader(context),
            const Divider(),
            _buildCustomerDetails(context),
            const Divider(),
            _buildLineItems(context),
            const Divider(),
            _buildTotals(context),
            if (bill.dynamicFields.isNotEmpty) ...[
              const Divider(),
              _buildDynamicFields(context),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBillHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(context, l10n.billNumber, bill.billNumber),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerDetails(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.customerDetails,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(context, l10n.customerName, bill.customerName),
            _buildDetailRow(context, l10n.location, bill.location),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItems(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.items,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...bill.lineItems.map((item) => _buildLineItemCard(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItemCard(BuildContext context, BillLineItem item) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.type == billTypeSale
                        ? Colors.green[100]
                        : Colors.red[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item.type == billTypeSale ? l10n.sale : l10n.returnText,
                    style: TextStyle(
                      color: item.type == billTypeSale
                          ? Colors.green[900]
                          : Colors.red[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${l10n.gross}: ₹${item.gross.toStringAsFixed(2)}'),
                    Text('${l10n.less}: ₹${item.less.toStringAsFixed(2)}'),
                    Text('${l10n.net}: ₹${item.net.toStringAsFixed(2)}'),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${l10n.rate}: ${item.rate.toStringAsFixed(0)}%'),
                    if (item.discount > 0)
                      Text(
                          '${l10n.discount}: ${item.discount.toStringAsFixed(0)}%'),
                    Text(
                      '${l10n.total}: ₹${item.total.abs().toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item.type == billTypeReturn ? Colors.red : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotals(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.billSummary,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
                context, l10n.totalItems, bill.lineItems.length.toString()),
            _buildDetailRow(
                context, l10n.totalGross, bill.totalGross.toStringAsFixed(2)),
            _buildDetailRow(
                context, l10n.totalLess, bill.totalLess.toStringAsFixed(2)),
            _buildDetailRow(context, l10n.totalNet,
                '₹${bill.totalNett.toStringAsFixed(2)}'),
            if (bill.totalDiscountAmount > 0)
              _buildDetailRow(
                context,
                l10n.totalDiscount,
                '₹${bill.totalDiscountAmount.toStringAsFixed(2)}',
              ),
            const Divider(),
            _buildDetailRow(
              context,
              l10n.grandTotal,
              '₹${bill.grandTotal.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFields(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.additionalDetails,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...bill.dynamicFields.entries.map(
              (entry) =>
                  _buildDetailRow(context, entry.key, entry.value.toString()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value,
      {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? (bill.grandTotal < 0 ? Colors.red : Colors.green)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  void _handleShare(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          title: Text(l10n.generatingPdf),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(l10n.pleaseWait),
            ],
          ),
        ),
      );

      final companyState = context.read<CompanyBloc>().state;
      final companyDetails =
          companyState is CompanyLoaded ? companyState.details : null;

      await _pdfService.generateAndShareBill(bill, companyDetails);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${l10n.errorGeneratingPdf}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
