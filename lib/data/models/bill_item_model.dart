import '../../domain/entities/bill_item.dart';
import '../../domain/entities/bill_line_item.dart';
import '../../core/utils/constants.dart';

class BillItemModel {
  final int? id;
  final String billNumber;
  final String customerName;
  final String location;
  final List<BillLineItemModel> lineItems;
  final Map<String, dynamic> dynamicFields;

  BillItemModel({
    this.id,
    required this.billNumber,
    required this.customerName,
    required this.location,
    required this.lineItems,
    this.dynamicFields = const {},
  });

  // Convert Entity to Model
  factory BillItemModel.fromEntity(BillItem entity) {
    return BillItemModel(
      id: entity.id,
      billNumber: entity.billNumber,
      customerName: entity.customerName,
      location: entity.location,
      lineItems: entity.lineItems
          .map((item) => BillLineItemModel.fromEntity(item))
          .toList(),
      dynamicFields: Map<String, dynamic>.from(entity.dynamicFields),
    );
  }

  // Convert Model to Entity
  BillItem toEntity() {
    return BillItem(
      id: id,
      billNumber: billNumber,
      customerName: customerName,
      location: location,
      lineItems: lineItems.map((item) => item.toEntity()).toList(),
      dynamicFields: Map<String, dynamic>.from(dynamicFields),
    );
  }

  // Convert Model to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'billNumber': billNumber,
      'customerName': customerName,
      'location': location,
      'lineItems': lineItems.map((item) => item.toMap()).toList(),
      'dynamicFields': dynamicFields,
    };
  }

  // Create Model from Map (database)
  factory BillItemModel.fromMap(Map<String, dynamic> map) {
    return BillItemModel(
      id: map['id'] as int?,
      billNumber: map['billNumber'] as String,
      customerName: map['customerName'] as String,
      location: map['location'] as String,
      lineItems: (map['lineItems'] as List)
          .map(
              (item) => BillLineItemModel.fromMap(item as Map<String, dynamic>))
          .toList(),
      dynamicFields: Map<String, dynamic>.from(map['dynamicFields'] as Map),
    );
  }
}

// Also need to update BillLineItemModel
class BillLineItemModel {
  final String description;
  final double gross;
  final double less;
  final double rate;
  final double discount;
  final String type;
  final String templateId; // Add this
  final Map<String, dynamic> dynamicFields;

  BillLineItemModel({
    required this.description,
    required this.gross,
    required this.less,
    required this.rate,
    required this.type,
    this.discount = 0,
    this.templateId = 'defaultTemplate', // Add this with default value
    this.dynamicFields = const {},
  });

  factory BillLineItemModel.fromEntity(BillLineItem entity) {
    print('Converting entity to model - Type: ${entity.type}');
    return BillLineItemModel(
      description: entity.description,
      gross: entity.gross,
      less: entity.less,
      rate: entity.rate,
      type: entity.type,
      discount: entity.discount,
      dynamicFields: Map<String, dynamic>.from(entity.dynamicFields),
    );
  }

  BillLineItem toEntity() {
    print('Converting model to entity - Type: $type');
    return BillLineItem(
      description: description,
      gross: gross,
      less: less,
      rate: rate,
      type: type,
      discount: discount,
      dynamicFields: Map<String, dynamic>.from(dynamicFields),
      templateId: templateId,
    );
  }

  Map<String, dynamic> toMap() {
    print('Converting model to map - Type: $type');
    return {
      'description': description,
      'gross': gross,
      'less': less,
      'rate': rate,
      'type': type,
      'discount': discount,
      'dynamicFields': dynamicFields,
    };
  }

  factory BillLineItemModel.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String? ?? billTypeSale;
    print(
        'Converting map to model - Type in map: ${map['type']}, Final type: $type');

    return BillLineItemModel(
      description: map['description'] as String,
      gross: map['gross'] as double,
      less: map['less'] as double,
      rate: map['rate'] as double,
      type: type,
      discount: (map['discount'] as num?)?.toDouble() ?? 0,
      dynamicFields: Map<String, dynamic>.from(map['dynamicFields'] as Map),
    );
  }

  BillLineItemModel copyWith({
    String? description,
    double? gross,
    double? less,
    double? rate,
    double? discount,
    String? type,
    Map<String, dynamic>? dynamicFields,
  }) {
    return BillLineItemModel(
      description: description ?? this.description,
      gross: gross ?? this.gross,
      less: less ?? this.less,
      rate: rate ?? this.rate,
      type: type ?? this.type,
      discount: discount ?? this.discount,
      dynamicFields: dynamicFields ?? this.dynamicFields,
    );
  }
}
