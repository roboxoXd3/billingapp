import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/bill_item.dart';
import '../../repositories/bill_repository.dart';

@injectable
class GetBills implements UseCase<List<BillItem>, NoParams> {
  final BillRepository repository;

  GetBills(this.repository);

  @override
  Future<Either<Failure, List<BillItem>>> call(NoParams params) {
    return repository.getBills();
  }
}
