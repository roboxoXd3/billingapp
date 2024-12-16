import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/bill_repository.dart';

@injectable
class DeleteBill implements UseCase<void, int> {
  final BillRepository repository;

  DeleteBill(this.repository);

  @override
  Future<Either<Failure, void>> call(int id) {
    return repository.deleteBill(id);
  }
}
