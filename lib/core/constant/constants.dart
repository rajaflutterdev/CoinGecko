import 'package:intl/intl.dart';

class AppConstants{
  static String formatCurrency(double value) {
    return '\$${NumberFormat('#,##0').format(value)}';
  }

  static String formatSupply(double value) {
    if (value >= 1e6) {
      return '${(value / 1e6).toStringAsFixed(1)} Million';
    }
    return NumberFormat('#,##0').format(value);
  }

  static String formatDate(String isoDate) {
    try {
      final dateTime = DateTime.parse(isoDate);
      return DateFormat('MMMM dd, yyyy').format(dateTime);
    } catch (_) {
      return isoDate;
    }
  }

  static String money(double amount) {
    return '\$${NumberFormat('#,##0.00').format(amount)}';
  }

  static String formatPrice(double price) {
    if (price >= 1) {
      return '\$${NumberFormat('#,##0.00').format(price)}';
    }
    return '\$${price.toStringAsFixed(6)}';
  }

   static String formatMarketCap(double marketCap) {
    if (marketCap >= 1e12) {
      return '\$${(marketCap / 1e12).toStringAsFixed(2)}T';
    } else if (marketCap >= 1e9) {
      return '\$${(marketCap / 1e9).toStringAsFixed(2)}B';
    } else if (marketCap >= 1e6) {
      return '\$${(marketCap / 1e6).toStringAsFixed(2)}M';
    }
    return '\$${NumberFormat('#,##0').format(marketCap)}';
  }


}