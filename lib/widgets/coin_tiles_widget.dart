import 'package:flutter/material.dart';
import '../core/constant/string_varibles.dart';
import '../data/model/coin_model.dart';
import '../screens/coin_details_screen.dart';
import 'coin_tile.dart';

enum SortType { marketCap, price, priceChange24h }

class CoinListScreen extends StatefulWidget {
  final List<CoinModel> initialCoins;

  const CoinListScreen({super.key, required this.initialCoins});

  @override
  State<CoinListScreen> createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  SortType activeSort = SortType.marketCap;
  bool isAscending = false;

  @override
  void initState() {
    super.initState();
    _sortCoins(SortType.marketCap);
  }

  void _sortCoins(SortType sortType) {
    setState(() {
      if (activeSort == sortType) {
        isAscending = !isAscending;
      } else {
        activeSort = sortType;
        isAscending = false;
      }

      widget.initialCoins.sort((a, b) {
        int comparison = 0;
        switch (activeSort) {
          case SortType.marketCap:
            comparison = (b.marketCap).compareTo(a.marketCap);
            break;
          case SortType.price:
            comparison = a.currentPrice.compareTo(b.currentPrice);
            break;
          case SortType.priceChange24h:
            comparison = a.priceChangePercentage24h.compareTo(
              b.priceChangePercentage24h,
            );
            break;
        }
        return isAscending ? comparison : -comparison;
      });
    });
  }

  Widget _buildHeaderTitle({
    required String title,
    required SortType sortType,
    required Alignment alignment,
  }) {
    final isSelected = activeSort == sortType;

    return Align(
      alignment: alignment,
      child: InkWell(
        onTap: () => _sortCoins(sortType),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            Icon(
              (isSelected && isAscending
                  ? Icons.arrow_drop_up
                  : Icons.arrow_drop_down),
              size: 16,
              color: isSelected ? Colors.white : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
             SizedBox(
              width: 24,
              child: Center(
                child: Text(
                  symbol,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 32),
             Expanded(
              flex: 5,
              child: Text(
                coin,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            Expanded(
              flex: 2,
              child: _buildHeaderTitle(
                title: price,
                sortType: SortType.price,
                alignment: Alignment.centerRight,
              ),
            ),
            Expanded(
              flex: 3,
              child: _buildHeaderTitle(
                title: hour24,
                sortType: SortType.priceChange24h,
                alignment: Alignment.centerRight,
              ),
            ),
            Expanded(
              flex: 4,
              child: _buildHeaderTitle(
                title: marketCap,
                sortType: SortType.marketCap,
                alignment: Alignment.centerRight,
              ),
            ),
          ],
        ),

        widget.initialCoins.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 300),
                  child: Text("No data"),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: widget.initialCoins.length,
                itemBuilder: (context, index) {
                  return CoinTile(
                    coin: widget.initialCoins[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoinDetailsScreen(
                            coin: widget.initialCoins[index],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ],
    );
  }
}
