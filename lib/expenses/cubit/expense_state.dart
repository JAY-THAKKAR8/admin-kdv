part of 'expense_cubit.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();

  @override
  List<Object> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseSuccess extends ExpenseState {}

class ExpenseFailure extends ExpenseState {
  final String error;

  const ExpenseFailure(this.error);

  @override
  List<Object> get props => [error];
}
