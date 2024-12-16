import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/field_config.dart';
import '../../domain/repositories/field_repository.dart';
import '../datasources/local/database_helper.dart';
import '../models/field_config_model.dart';

@Injectable(as: FieldRepository)
class FieldRepositoryImpl implements FieldRepository {
  final DatabaseHelper databaseHelper;

  FieldRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<FieldConfig>>> getAllFields() async {
    try {
      final fields = await databaseHelper.getAllFields();
      return Right(fields);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, FieldConfig>> saveField(FieldConfig field) async {
    try {
      final fieldModel = FieldConfigModel.fromEntity(field);
      final savedField = await databaseHelper.saveField(fieldModel);
      return Right(savedField);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteField(int id) async {
    try {
      await databaseHelper.deleteField(id);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> updateFieldOrder(
      List<FieldConfig> fields) async {
    try {
      // Implement field order update logic
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<FieldConfig>>> getCalculatedFields() async {
    try {
      final fields = await databaseHelper.getAllFields();
      final calculatedFields =
          fields.where((field) => field.isCalculated).toList();
      return Right(calculatedFields);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(e.message));
    }
  }
}
