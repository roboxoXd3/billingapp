import 'package:equatable/equatable.dart';

class FieldConfig extends Equatable {
  final int? id;
  final String fieldId;
  final String label;
  final String type;
  final bool required;
  final String? defaultValue;
  final bool isCalculated;
  final String? calculationFormula;
  final int orderIndex;

  const FieldConfig({
    this.id,
    required this.fieldId,
    required this.label,
    required this.type,
    required this.required,
    this.defaultValue,
    required this.isCalculated,
    this.calculationFormula,
    required this.orderIndex,
  });

  @override
  List<Object?> get props => [
        id,
        fieldId,
        label,
        type,
        required,
        defaultValue,
        isCalculated,
        calculationFormula,
        orderIndex,
      ];
}
