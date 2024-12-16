import 'package:flutter/material.dart';
import '../../../../core/utils/constants.dart';
import '../../../../domain/entities/bill_line_item.dart';
import 'bill_header.dart';
import 'customer_details.dart';
import 'optical_customer_details.dart';
import 'prescription_details.dart';
import 'line_items_section.dart';
import 'bottom_bar.dart';
import 'dynamic_fields_section.dart';

class BillForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String billNumber;
  final TextEditingController customerNameController;
  final TextEditingController locationController;
  final List<BillLineItem> lineItems;
  final Map<String, dynamic> dynamicValues;
  final String selectedTemplate;
  final Function(String, dynamic) onDynamicValueChanged;
  final Function(BillLineItem) onLineItemAdd;
  final Function(int, BillLineItem) onLineItemEdit;
  final Function(int) onLineItemDelete;
  final VoidCallback onSave;
  final VoidCallback onPrint;

  const BillForm({
    super.key,
    required this.formKey,
    required this.billNumber,
    required this.customerNameController,
    required this.locationController,
    required this.lineItems,
    required this.dynamicValues,
    required this.selectedTemplate,
    required this.onDynamicValueChanged,
    required this.onLineItemAdd,
    required this.onLineItemEdit,
    required this.onLineItemDelete,
    required this.onSave,
    required this.onPrint,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BillHeader(billNumber: billNumber),
                if (selectedTemplate == opticalTemplate)
                  OpticalCustomerDetails(
                    nameController: customerNameController,
                    locationController: locationController,
                    onDynamicValueChanged: onDynamicValueChanged,
                  )
                else
                  CustomerDetails(
                    nameController: customerNameController,
                    locationController: locationController,
                  ),
                if (selectedTemplate == opticalTemplate)
                  PrescriptionDetails(
                    onDynamicValueChanged: onDynamicValueChanged,
                    medicalHistory: dynamicValues['medicalHistory'] ?? {},
                  ),
                LineItemsSection(
                  lineItems: lineItems,
                  onAdd: onLineItemAdd,
                  onEdit: onLineItemEdit,
                  onDelete: onLineItemDelete,
                ),
                DynamicFieldsSection(
                  dynamicValues: dynamicValues,
                  onValueChanged: onDynamicValueChanged,
                ),
              ],
            ),
          ),
          BottomBar(
            itemCount: lineItems.length,
            total: _calculateTotal(),
            onSave: onSave,
            onPrint: onPrint,
          ),
        ],
      ),
    );
  }

  String _calculateTotal() {
    final total = lineItems.fold<double>(
      0,
      (sum, item) => sum + item.total,
    );
    return total.toStringAsFixed(2);
  }
}
