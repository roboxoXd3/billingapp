import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failures.dart';
import '../../../core/usecases/usecase.dart';
import '../../entities/bill_item.dart';
import '../../repositories/bill_repository.dart';

@injectable
class SaveBill implements UseCase<BillItem, BillItem> {
  final BillRepository repository;

  SaveBill(this.repository);

  @override
  Future<Either<Failure, BillItem>> call(BillItem bill) {
    return repository.saveBill(bill);
  }
}
