import '../../domain/models/contract.dart';

class BusinessLogicService {
  static double calculateRemainingBalance(Contract c) {
    return c.payment.totalPrice - c.payment.paidAmount;
  }

  static double calculateTax(Contract c) {
    return c.payment.totalPrice * c.payment.taxRate;
  }

  static bool isPaymentComplete(Contract c) {
    return c.payment.paidAmount >= c.payment.totalPrice;
  }

  static double calculateBalancePercentage(Contract c) {
    if (c.payment.totalPrice == 0) return 0;
    return (c.payment.paidAmount / c.payment.totalPrice) * 100;
  }

  static int calculateContractComplexity(Contract c) {
    int score = 1;
    if (c.sellers.length > 1) score++;
    if (c.buyers.length > 1) score++;
    if (c.heirs.length > 2) score += 2;
    if (c.witnesses.length > 2) score++;
    if (c.customClauses.length > 3) score++;
    if (c.annexes.length > 1) score++;
    return score;
  }

  static String getComplexityLevel(int score) {
    if (score <= 2) return 'بسيط';
    if (score <= 5) return 'متوسط';
    if (score <= 8) return 'معقد';
    return 'معقد جداً';
  }
}