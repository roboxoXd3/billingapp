import 'package:equatable/equatable.dart';
import '../../../domain/entities/bill_item.dart';

abstract class BillEvent extends Equatable {
  const BillEvent();

  @override
  List<Object?> get props => [];
}

class LoadBills extends BillEvent {}

class SaveBillEvent extends BillEvent {
  final BillItem bill;

  const SaveBillEvent(this.bill);

  @override
  List<Object> get props => [bill];
}

class DeleteBillEvent extends BillEvent {
  final int id;

  const DeleteBillEvent(this.id);

  @override
  List<Object> get props => [id];
}
