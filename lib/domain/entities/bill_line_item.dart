import 'package:equatable/equatable.dart';
import '../../core/utils/constants.dart';

class BillLineItem extends Equatable {
  final String description;
  final double gross;
  final double less;
  final double rate;
  final double discount;
  final String type;
  final String templateId; // Add this field
  final Map<String, dynamic> dynamicFields;
  final Map<String, dynamic>? additionalInfo;

  const BillLineItem({
    required this.description,
    required this.gross,
    required this.less,
    required this.rate,
    required this.type,
    required this.templateId, // Add to constructor
    this.discount = 0,
    this.additionalInfo,
    this.dynamicFields = const {},
  });

  double get net => gross - less;

  double get subtotal {
    final baseNet = net; // Calculate net as gross - less
    print(
        'Calculating subtotal - Template: $templateId, Net: $baseNet, Rate: $rate'); // Debug print

    if (templateId == 'defaultTemplate') {
      // Default Template Logic
      return baseNet * rate;
    } else if (templateId == 'opticalTemplate') {
      // Optical Shop Template Logic
      // Example: Add a flat fee of 50
      return (baseNet * rate) +
          (dynamicFields['flatFee'] ?? 50); // Adjust logic as needed
    } else {
      // Fallback Logic
      return baseNet * rate;
    }
  }

  double get discountAmount => subtotal * (discount / 100);

  double get total {
    final baseTotal = subtotal - discountAmount;
    print(
        'Calculating total - Type: $type, Template: $templateId'); // Debug print
    return type == billTypeReturn ? -baseTotal : baseTotal;
  }

  @override
  List<Object?> get props => [
        description,
        gross,
        less,
        rate,
        discount,
        type,
        templateId, // Add to props
        dynamicFields,
      ];

  BillLineItem copyWith({
    String? description,
    double? gross,
    double? less,
    double? rate,
    double? discount,
    String? type,
    String? templateId, // Add to copyWith
    Map<String, dynamic>? dynamicFields,
  }) {
    return BillLineItem(
      description: description ?? this.description,
      gross: gross ?? this.gross,
      less: less ?? this.less,
      rate: rate ?? this.rate,
      type: type ?? this.type,
      discount: discount ?? this.discount,
      templateId: templateId ?? this.templateId, // Add to copyWith
      dynamicFields: dynamicFields ?? this.dynamicFields,
    );
  }
}
