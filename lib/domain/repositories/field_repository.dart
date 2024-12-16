import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/field_config.dart';

abstract class FieldRepository {
  Future<Either<Failure, List<FieldConfig>>> getAllFields();
  Future<Either<Failure, FieldConfig>> saveField(FieldConfig field);
  Future<Either<Failure, void>> deleteField(int id);
  Future<Either<Failure, void>> updateFieldOrder(List<FieldConfig> fields);
  Future<Either<Failure, List<FieldConfig>>> getCalculatedFields();
}
