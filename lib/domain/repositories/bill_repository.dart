import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/bill_item.dart';

abstract class BillRepository {
  Future<Either<Failure, List<BillItem>>> getBills();
  Future<Either<Failure, BillItem>> saveBill(BillItem bill);
  Future<Either<Failure, void>> deleteBill(int id);
  Future<Either<Failure, BillItem>> getBillById(int id);
  Future<Either<Failure, void>> shareBill(BillItem bill);
}
