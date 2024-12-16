import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/field_repository.dart';

@injectable
class DeleteField implements UseCase<void, int> {
  final FieldRepository repository;

  DeleteField(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) {
    return repository.deleteField(id);
  }
}
