import '../../domain/models/category.dart';
import '../../domain/models/transaction_type.dart';

abstract class DefaultCategories {
  DefaultCategories._();

  static const food = Category(
    id: 'cat_food',
    name: 'Food',
    icon: 'restaurant',
    colorValue: 0xFFFF7043,
    type: TransactionType.expense,
  );

  static const onlineShopping = Category(
    id: 'cat_online_shopping',
    name: 'Online Shopping',
    icon: 'shopping_bag',
    colorValue: 0xFF7C4DFF,
    type: TransactionType.expense,
  );

  static const hospital = Category(
    id: 'cat_hospital',
    name: 'Hospital',
    icon: 'local_hospital',
    colorValue: 0xFFE53935,
    type: TransactionType.expense,
  );

  static const mother = Category(
    id: 'cat_mother',
    name: 'Mother',
    icon: 'favorite',
    colorValue: 0xFFEC407A,
    type: TransactionType.expense,
  );

  static const ott = Category(
    id: 'cat_ott',
    name: 'OTT',
    icon: 'tv',
    colorValue: 0xFFAB47BC,
    type: TransactionType.expense,
  );

  static const subscriptions = Category(
    id: 'cat_subscriptions',
    name: 'Subscriptions',
    icon: 'subscriptions',
    colorValue: 0xFF42A5F5,
    type: TransactionType.expense,
  );

  static const creditCardBill = Category(
    id: 'cat_credit_card_bill',
    name: 'Credit Card Bill',
    icon: 'credit_card',
    colorValue: 0xFFEF5350,
    type: TransactionType.expense,
  );

  static const chitti = Category(
    id: 'cat_chitti',
    name: 'Chitti',
    icon: 'favorite',
    colorValue: 0xFFFF80AB,
    type: TransactionType.expense,
  );

  static const suby = Category(
    id: 'cat_suby',
    name: 'Suby',
    icon: 'favorite',
    colorValue: 0xFFF06292,
    type: TransactionType.expense,
  );

  static const fuels = Category(
    id: 'cat_fuels',
    name: 'Fuels',
    icon: 'local_gas_station',
    colorValue: 0xFFFFA726,
    type: TransactionType.expense,
  );

  static const movies = Category(
    id: 'cat_movies',
    name: 'Movies',
    icon: 'movie',
    colorValue: 0xFF26C6DA,
    type: TransactionType.expense,
  );

  static const phoneInternet = Category(
    id: 'cat_phone_internet',
    name: 'Phone & Internet',
    icon: 'smartphone',
    colorValue: 0xFF29B6F6,
    type: TransactionType.expense,
  );

  static const cash = Category(
    id: 'cat_cash',
    name: 'Cash',
    icon: 'payments',
    colorValue: 0xFF66BB6A,
    type: TransactionType.expense,
  );

  static const upi = Category(
    id: 'cat_upi',
    name: 'UPI',
    icon: 'account_balance_wallet',
    colorValue: 0xFF5C6BC0,
    type: TransactionType.expense,
  );

  static const salary = Category(
    id: 'cat_salary',
    name: 'Salary',
    icon: 'business_center',
    colorValue: 0xFFFFCA28,
    type: TransactionType.income,
  );

  static const wife = Category(
    id: 'cat_wife',
    name: 'Wife',
    icon: 'favorite',
    colorValue: 0xFFEC407A,
    type: TransactionType.income,
  );

  static const all = [
    food,
    onlineShopping,
    hospital,
    mother,
    ott,
    subscriptions,
    creditCardBill,
    chitti,
    suby,
    fuels,
    movies,
    phoneInternet,
    cash,
    upi,
    salary,
    wife,
  ];
}
