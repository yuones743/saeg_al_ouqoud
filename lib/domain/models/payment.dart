enum PaymentMethod { cash, bankTransfer, check, installments }
enum ExpenseAllocation { buyer, seller, halved, custom }
enum Currency { syp, usd, eur, sar, gbp, aed }

class Installment {
  final double amount;
  final String dueDate;
  final String note;

  const Installment({required this.amount, required this.dueDate, this.note = ''});

  Map<String, dynamic> toMap() => {'amount': amount, 'due_date': dueDate, 'note': note};
}

class Payment {
  final double totalPrice;
  final double paidAmount;
  final double balance;
  final String balanceDueDate;
  final Currency currency;
  final PaymentMethod method;
  final List<Installment> installments;
  final ExpenseAllocation expenseAllocation;
  final double penaltyAmount;
  final double taxRate;
  final bool taxExemptOnNkoul;
  final String customExpenseNote;

  const Payment({
    this.totalPrice = 0, this.paidAmount = 0, this.balance = 0,
    this.balanceDueDate = '', this.currency = Currency.syp,
    this.method = PaymentMethod.cash, this.installments = const [],
    this.expenseAllocation = ExpenseAllocation.buyer, this.penaltyAmount = 0,
    this.taxRate = 0.03, this.taxExemptOnNkoul = true, this.customExpenseNote = '',
  });

  Map<String, dynamic> toMap() => {
    'total_price': totalPrice, 'paid_amount': paidAmount, 'balance': balance,
    'balance_due_date': balanceDueDate, 'currency': currency.index, 'method': method.index,
    'installments': installments.map((i) => i.toMap()).toList(),
    'expense_allocation': expenseAllocation.index, 'penalty_amount': penaltyAmount,
    'tax_rate': taxRate, 'tax_exempt_on_nkoul': taxExemptOnNkoul ? 1 : 0,
    'custom_expense_note': customExpenseNote,
  };
}