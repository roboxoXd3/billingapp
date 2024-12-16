import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/field_config.dart';
import '../../repositories/field_repository.dart';

@injectable
class SaveField implements UseCase<FieldConfig, FieldConfig> {
  final FieldRepository repository;

  SaveField(this.repository);

  @override
  Future<Either<Failure, FieldConfig>> call(FieldConfig field) {
    return repository.saveField(field);
  }
}
