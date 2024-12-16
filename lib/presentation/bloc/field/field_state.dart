import 'package:equatable/equatable.dart';
import '../../../domain/entities/field_config.dart';

abstract class FieldState extends Equatable {
  const FieldState();

  @override
  List<Object?> get props => [];
}

class FieldInitial extends FieldState {}

class FieldLoading extends FieldState {}

class FieldsLoaded extends FieldState {
  final List<FieldConfig> fields;

  const FieldsLoaded(this.fields);

  @override
  List<Object> get props => [fields];
}

class FieldError extends FieldState {
  final String message;

  const FieldError(this.message);

  @override
  List<Object> get props => [message];
}

class FieldSaved extends FieldState {
  final FieldConfig field;

  const FieldSaved(this.field);

  @override
  List<Object> get props => [field];
}

class FieldDeleted extends FieldState {}
