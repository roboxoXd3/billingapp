import '../../domain/entities/field_config.dart';

class FieldConfigModel extends FieldConfig {
  const FieldConfigModel({
    super.id,
    required super.fieldId,
    required super.label,
    required super.type,
    required super.required,
    super.defaultValue,
    required super.isCalculated,
    super.calculationFormula,
    required super.orderIndex,
  });

  factory FieldConfigModel.fromMap(Map<String, dynamic> map) {
    return FieldConfigModel(
      id: map['id'],
      fieldId: map['fieldId'],
      label: map['label'],
      type: map['type'],
      required: map['required'] == 1,
      defaultValue: map['defaultValue'],
      isCalculated: map['isCalculated'] == 1,
      calculationFormula: map['calculationFormula'],
      orderIndex: map['orderIndex'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fieldId': fieldId,
      'label': label,
      'type': type,
      'required': required ? 1 : 0,
      'defaultValue': defaultValue,
      'isCalculated': isCalculated ? 1 : 0,
      'calculationFormula': calculationFormula,
      'orderIndex': orderIndex,
    };
  }

  factory FieldConfigModel.fromEntity(FieldConfig entity) {
    return FieldConfigModel(
      id: entity.id,
      fieldId: entity.fieldId,
      label: entity.label,
      type: entity.type,
      required: entity.required,
      defaultValue: entity.defaultValue,
      isCalculated: entity.isCalculated,
      calculationFormula: entity.calculationFormula,
      orderIndex: entity.orderIndex,
    );
  }

  FieldConfigModel copyWith({
    int? id,
    String? fieldId,
    String? label,
    String? type,
    bool? required,
    String? defaultValue,
    bool? isCalculated,
    String? calculationFormula,
    int? orderIndex,
  }) {
    return FieldConfigModel(
      id: id ?? this.id,
      fieldId: fieldId ?? this.fieldId,
      label: label ?? this.label,
      type: type ?? this.type,
      required: required ?? this.required,
      defaultValue: defaultValue ?? this.defaultValue,
      isCalculated: isCalculated ?? this.isCalculated,
      calculationFormula: calculationFormula ?? this.calculationFormula,
      orderIndex: orderIndex ?? this.orderIndex,
    );
  }
}
