import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/field_config.dart';
import '../../repositories/field_repository.dart';

@injectable
class GetFields implements UseCase<List<FieldConfig>, NoParams> {
  final FieldRepository repository;

  GetFields(this.repository);

  @override
  Future<Either<Failure, List<FieldConfig>>> call(NoParams params) {
    return repository.getAllFields();
  }
}
