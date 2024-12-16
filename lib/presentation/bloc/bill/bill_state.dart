import 'package:equatable/equatable.dart';
import '../../../domain/entities/bill_item.dart';

abstract class BillState extends Equatable {
  const BillState();

  @override
  List<Object?> get props => [];
}

class BillInitial extends BillState {}

class BillLoading extends BillState {}

class BillsLoaded extends BillState {
  final List<BillItem> bills;

  const BillsLoaded(this.bills);

  @override
  List<Object> get props => [bills];
}

class BillError extends BillState {
  final String message;

  const BillError(this.message);

  @override
  List<Object> get props => [message];
}

class BillSaved extends BillState {
  final BillItem bill;

  const BillSaved(this.bill);

  @override
  List<Object> get props => [bill];
}

class BillDeleted extends BillState {}
