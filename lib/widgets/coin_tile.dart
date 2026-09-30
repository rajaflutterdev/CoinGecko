
import 'package:flutter/material.dart';
import 'package:stu/core/constant/constants.dart';
import '../data/model/coin_model.dart';

class CoinTile extends StatelessWidget {
  final CoinModel coin;
  final VoidCallback? onTap;

  const CoinTile({
    super.key,
    required this.coin,
    this.onTap,
  });



  @override
  Widget build(BuildContext context) {
    final isPositive = coin.priceChangePercentage24h >= 0;
    final changeColor = isPositive ? const Color(0xFF55F803) : const Color(0xFFEF5350);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12.0),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              child: Text(
                coin.marketCapRank.toInt().toString(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ),

            // Coin Image
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                coin.image,
                width: 24,
                height: 24,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const CircleAvatar(
                  radius: 12,
                  child: Icon(Icons.currency_bitcoin, size: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Coin Symbol/Name
            Expanded(
              flex: 3,
              child: Text(
                coin.symbol.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // Price Column
            Expanded(
              flex: 4,
              child: Text(
                AppConstants.formatPrice(coin.currentPrice),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),

            // 24H Change Column
            Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                    color: changeColor,
                    size: 16,
                  ),
                  Text(
                    '${coin.priceChangePercentage24h.abs().toStringAsFixed(1)}%',
                    style: TextStyle(
                      color: changeColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Market Cap Column
            Expanded(
              flex: 4,
              child: Text(
                AppConstants.formatMarketCap(coin.marketCap),
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

