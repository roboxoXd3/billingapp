import 'package:equatable/equatable.dart';

import '../../core/utils/constants.dart';
import 'bill_line_item.dart';
import 'eye_prescription.dart';

class BillItem extends Equatable {
  final int? id;
  final String billNumber;
  final String customerName;
  final String location;
  final List<BillLineItem> lineItems;
  final Map<String, dynamic> dynamicFields;
  final String? guardianName;
  final int? age;
  final String? gender;
  final EyePrescription? prescription;
  final String? templateType;

  const BillItem({
    this.id,
    required this.billNumber,
    required this.customerName,
    required this.location,
    required this.lineItems,
    this.dynamicFields = const {},
    this.guardianName,
    this.age,
    this.gender,
    this.prescription,
    this.templateType = 'default',
  });

  double get totalGross => lineItems.fold(
        0,
        (sum, item) => sum + item.gross * (item.type == 'Return' ? -1 : 1),
      );

  double get totalLess => lineItems.fold(
        0,
        (sum, item) => sum + item.less * (item.type == 'Return' ? -1 : 1),
      );

  double get totalNett => lineItems.fold(
        0,
        (sum, item) => sum + item.net * (item.type == 'Return' ? -1 : 1),
      );

  double get totalDiscountAmount => lineItems.fold(
        0,
        (sum, item) =>
            sum + item.discountAmount * (item.type == 'Return' ? -1 : 1),
      );

  double get totalSales => lineItems
      .where((item) => item.type == billTypeSale)
      .fold(0, (sum, item) => sum + item.total);

  double get totalReturns => lineItems
      .where((item) => item.type == billTypeReturn)
      .fold(0, (sum, item) => sum + item.total.abs());

  double get grandTotal => totalSales - totalReturns;

  @override
  List<Object?> get props => [
        id,
        billNumber,
        customerName,
        location,
        lineItems,
        dynamicFields,
        guardianName,
        age,
        gender,
        prescription,
        templateType,
      ];

  BillItem copyWith({
    int? id,
    String? billNumber,
    String? customerName,
    String? location,
    List<BillLineItem>? lineItems,
    Map<String, dynamic>? dynamicFields,
    String? guardianName,
    int? age,
    String? gender,
    EyePrescription? prescription,
    String? templateType,
  }) {
    return BillItem(
      id: id ?? this.id,
      billNumber: billNumber ?? this.billNumber,
      customerName: customerName ?? this.customerName,
      location: location ?? this.location,
      lineItems: lineItems ?? this.lineItems,
      dynamicFields: dynamicFields ?? this.dynamicFields,
      guardianName: guardianName ?? this.guardianName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      prescription: prescription ?? this.prescription,
      templateType: templateType ?? this.templateType,
    );
  }
}
