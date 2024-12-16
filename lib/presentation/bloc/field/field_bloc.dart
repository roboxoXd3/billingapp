import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../core/usecases/usecase.dart';
import '../../../domain/usecases/field/delete_field.dart';
import '../../../domain/usecases/field/get_fields.dart';
import '../../../domain/usecases/field/save_field.dart';
import 'field_event.dart';
import 'field_state.dart';

@injectable
class FieldBloc extends Bloc<FieldEvent, FieldState> {
  final GetFields _getFields;
  final SaveField _saveField;
  final DeleteField _deleteField;

  FieldBloc(
    this._getFields,
    this._saveField,
    this._deleteField,
  ) : super(FieldInitial()) {
    on<LoadFields>(_onLoadFields);
    on<SaveFieldEvent>(_onSaveField);
    on<DeleteFieldEvent>(_onDeleteField);
  }

  Future<void> _onLoadFields(LoadFields event, Emitter<FieldState> emit) async {
    emit(FieldLoading());
    final result = await _getFields(NoParams());
    result.fold(
      (failure) => emit(FieldError(failure.message)),
      (fields) => emit(FieldsLoaded(fields)),
    );
  }

  Future<void> _onSaveField(
      SaveFieldEvent event, Emitter<FieldState> emit) async {
    emit(FieldLoading());
    final result = await _saveField(event.field);
    result.fold(
      (failure) => emit(FieldError(failure.message)),
      (savedField) => emit(FieldSaved(savedField)),
    );
  }

  Future<void> _onDeleteField(
      DeleteFieldEvent event, Emitter<FieldState> emit) async {
    emit(FieldLoading());
    final result = await _deleteField(event.id);
    result.fold(
      (failure) => emit(FieldError(failure.message)),
      (_) => emit(FieldDeleted()),
    );
  }
}
