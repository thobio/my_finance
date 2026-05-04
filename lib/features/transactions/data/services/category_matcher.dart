import '../../domain/models/transaction_type.dart';

abstract class CategoryMatcher {
  CategoryMatcher._();

  static String? matchCategoryId(
    String description, [
    TransactionType type = TransactionType.expense,
  ]) {
    final lower = description.toLowerCase();

    if (type == TransactionType.income) {
      if (lower.contains('web network') || lower.contains('webnetwork')) {
        return 'cat_salary';
      }
      if (lower.contains('suby sojan')) {
        return 'cat_wife';
      }
      return null;
    }

    // Expense matching
    if (lower.contains('swiggy') || lower.contains('zomato')) {
      return 'cat_food';
    }
    if (lower.contains('flipkart') || lower.contains('amazon')) {
      return 'cat_online_shopping';
    }
    if (lower.contains('dewan') || lower.contains('st thomas')) {
      return 'cat_hospital';
    }
    if (lower.contains('salilamm') || lower.contains('salilam')) {
      return 'cat_mother';
    }
    if (lower.contains('netflix') || lower.contains('pangea') ||
        lower.contains('crunchyroll') || lower.contains('zee')) {
      return 'cat_ott';
    }
    if (lower.contains('claude') || lower.contains('anthropic')) {
      return 'cat_subscriptions';
    }
    if (lower.contains('credit card') || lower.contains('creditcard') ||
        lower.contains('ccbill') || lower.contains('credit')) {
      return 'cat_credit_card_bill';
    }
    if (lower.contains('omana baby') || lower.contains('omanababy')) {
      return 'cat_chitti';
    }
    if (lower.contains('atm')) {
      return 'cat_cash';
    }
    if (lower.contains('upi')) {
      return 'cat_upi';
    }
    if (lower.contains('suby')) {
      return 'cat_suby';
    }
    if (lower.contains('fuel') || lower.contains('petrol') ||
        lower.contains('diesel') || lower.contains('j and j') ||
        lower.contains('j&j')) {
      return 'cat_fuels';
    }
    if (lower.contains('bookmyshow')) {
      return 'cat_movies';
    }
    if (lower.contains('bsnl') || lower.contains('airtel') ||
        lower.contains('jio') || lower.contains('vi ') ||
        lower.contains('vodafone') || lower.contains('recharge') ||
        lower.contains('broadband') || lower.contains('internet')) {
      return 'cat_phone_internet';
    }
    return null;
  }
}
