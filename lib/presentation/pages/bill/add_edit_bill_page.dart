import 'package:billing_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/bill_number_generator.dart';
import '../../../domain/entities/bill_item.dart';
import '../../../domain/entities/bill_line_item.dart';
import '../../bloc/bill/bill_bloc.dart';
import '../../bloc/bill/bill_event.dart';
import '../../bloc/company/company_bloc.dart';
import '../../bloc/company/company_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../../core/services/pdf_service.dart';
import 'widgets/bill_form.dart';

class AddEditBillPage extends StatefulWidget {
  final BillItem? bill;

  const AddEditBillPage({super.key, this.bill});

  @override
  State<AddEditBillPage> createState() => _AddEditBillPageState();
}

class _AddEditBillPageState extends State<AddEditBillPage> {
  final _formKey = GlobalKey<FormState>();
  late String _billNumber;
  final _customerNameController = TextEditingController();
  final _locationController = TextEditingController();
  final List<BillLineItem> _lineItems = [];
  final Map<String, dynamic> _dynamicValues = {};
  final _pdfService = PdfService();

  @override
  void initState() {
    super.initState();
    _initializeBillData();
  }

  void _initializeBillData() {
    if (widget.bill != null) {
      _billNumber = widget.bill!.billNumber;
      _customerNameController.text = widget.bill!.customerName;
      _locationController.text = widget.bill!.location;
      _lineItems.addAll(widget.bill!.lineItems);
      _dynamicValues.addAll(widget.bill!.dynamicFields);
    } else {
      _billNumber = BillNumberGenerator.generate();
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedTemplate =
        context.watch<SettingsBloc>().state.selectedTemplate;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.bill == null ? context.l10n.addBill : context.l10n.editBill,
        ),
      ),
      body: BillForm(
        formKey: _formKey,
        billNumber: _billNumber,
        customerNameController: _customerNameController,
        locationController: _locationController,
        lineItems: _lineItems,
        dynamicValues: _dynamicValues,
        selectedTemplate: selectedTemplate,
        onDynamicValueChanged: _handleDynamicValueChange,
        onLineItemAdd: _handleLineItemAdd,
        onLineItemEdit: _handleLineItemEdit,
        onLineItemDelete: _handleLineItemDelete,
        onSave: _saveBill,
        onPrint: _printBill,
      ),
    );
  }

  void _handleDynamicValueChange(String key, dynamic value) {
    setState(() {
      _dynamicValues[key] = value;
    });
  }

  void _handleLineItemAdd(BillLineItem item) {
    setState(() {
      _lineItems.add(item);
    });
  }

  void _handleLineItemEdit(int index, BillLineItem item) {
    setState(() {
      _lineItems[index] = item;
    });
  }

  void _handleLineItemDelete(int index) {
    setState(() {
      _lineItems.removeAt(index);
    });
  }

  void _saveBill() {
    if (_formKey.currentState?.validate() ?? false) {
      final bill = BillItem(
        id: widget.bill?.id,
        billNumber: _billNumber,
        customerName: _customerNameController.text,
        location: _locationController.text,
        lineItems: _lineItems,
        dynamicFields: _dynamicValues,
      );

      context.read<BillBloc>().add(SaveBillEvent(bill));
      Navigator.pop(context);
    }
  }

  void _printBill() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        _showPrintingDialog();

        final bill = BillItem(
          id: widget.bill?.id,
          billNumber: _billNumber,
          customerName: _customerNameController.text,
          location: _locationController.text,
          lineItems: _lineItems,
          dynamicFields: _dynamicValues,
        );

        final companyState = context.read<CompanyBloc>().state;
        final companyDetails =
            companyState is CompanyLoaded ? companyState.details : null;

        await _pdfService.printBill(context, bill, companyDetails);

        if (mounted) {
          Navigator.pop(context); // Dismiss the printing dialog
        }
      } catch (e) {
        if (mounted) {
          Navigator.pop(context); // Dismiss the printing dialog
          _showPrintError(e.toString());
        }
      }
    }
  }

  void _showPrintingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: Text(context.l10n.preparingToPrint),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(context.l10n.pleaseWait),
          ],
        ),
      ),
    );
  }

  void _showPrintError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${context.l10n.errorPrinting}: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }
}
