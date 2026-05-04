import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../domain/models/category.dart';

class CategoryIcon extends StatelessWidget {
  const CategoryIcon({super.key, required this.category});

  final Category? category;

  @override
  Widget build(BuildContext context) {
    final color = category != null
        ? Color(category!.colorValue)
        : AppColors.darkTextSecondary;

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconDataFor(category?.icon),
        color: color,
        size: 22,
      ),
    );
  }

  static IconData iconDataFor(String? name) {
    switch (name) {
      case 'restaurant':         return Icons.restaurant;
      case 'directions_car':     return Icons.directions_car;
      case 'shopping_bag':       return Icons.shopping_bag;
      case 'movie':              return Icons.movie;
      case 'local_hospital':     return Icons.local_hospital;
      case 'bolt':               return Icons.bolt;
      case 'home':               return Icons.home;
      case 'local_grocery_store':return Icons.local_grocery_store;
      case 'school':             return Icons.school;
      case 'flight':             return Icons.flight;
      case 'security':           return Icons.security;
      case 'work':               return Icons.work;
      case 'laptop_mac':         return Icons.laptop_mac;
      case 'trending_up':        return Icons.trending_up;
      case 'add_circle':         return Icons.add_circle;
      case 'favorite':           return Icons.favorite;
      case 'tv':                 return Icons.tv;
      case 'subscriptions':      return Icons.subscriptions;
      case 'credit_card':        return Icons.credit_card;
      case 'local_gas_station':  return Icons.local_gas_station;
      case 'smartphone':         return Icons.smartphone;
      case 'payments':           return Icons.payments;
      case 'account_balance_wallet': return Icons.account_balance_wallet;
      case 'business_center':    return Icons.business_center;
      case 'account_balance':    return Icons.account_balance;
      case 'monetization_on':    return Icons.monetization_on;
      case 'fitness_center':     return Icons.fitness_center;
      case 'local_cafe':         return Icons.local_cafe;
      case 'child_care':         return Icons.child_care;
      case 'pets':               return Icons.pets;
      case 'sports_esports':     return Icons.sports_esports;
      case 'medical_services':   return Icons.medical_services;
      case 'savings':            return Icons.savings;
      case 'card_giftcard':      return Icons.card_giftcard;
      case 'celebration':        return Icons.celebration;
      default:                   return Icons.receipt_long;
    }
  }

  // Canonical list for the icon picker (name → display label)
  static const List<(String, String)> pickerIcons = [
    ('restaurant',          'Food'),
    ('local_grocery_store', 'Grocery'),
    ('local_cafe',          'Cafe'),
    ('shopping_bag',        'Shopping'),
    ('directions_car',      'Transport'),
    ('flight',              'Travel'),
    ('local_hospital',      'Hospital'),
    ('medical_services',    'Medical'),
    ('local_gas_station',   'Fuel'),
    ('home',                'Home'),
    ('bolt',                'Utilities'),
    ('smartphone',          'Phone'),
    ('tv',                  'OTT'),
    ('subscriptions',       'Subscriptions'),
    ('laptop_mac',          'Tech'),
    ('sports_esports',      'Gaming'),
    ('fitness_center',      'Fitness'),
    ('movie',               'Movies'),
    ('credit_card',         'Card'),
    ('account_balance_wallet', 'Wallet'),
    ('payments',            'Cash'),
    ('school',              'Education'),
    ('child_care',          'Child'),
    ('pets',                'Pets'),
    ('card_giftcard',       'Gift'),
    ('celebration',         'Events'),
    ('security',            'Insurance'),
    ('savings',             'Savings'),
    ('business_center',     'Business'),
    ('work',                'Salary'),
    ('trending_up',         'Investment'),
    ('account_balance',     'Bank'),
    ('monetization_on',     'Income'),
    ('favorite',            'Personal'),
  ];
}
