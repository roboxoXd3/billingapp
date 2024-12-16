import 'package:equatable/equatable.dart';
import '../../../domain/entities/field_config.dart';

abstract class FieldEvent extends Equatable {
  const FieldEvent();

  @override
  List<Object?> get props => [];
}

class LoadFields extends FieldEvent {}

class SaveFieldEvent extends FieldEvent {
  final FieldConfig field;

  const SaveFieldEvent(this.field);

  @override
  List<Object> get props => [field];
}

class DeleteFieldEvent extends FieldEvent {
  final int id;

  const DeleteFieldEvent(this.id);

  @override
  List<Object> get props => [id];
}
