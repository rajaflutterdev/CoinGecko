import 'package:flutter/material.dart';

import '../core/constant/string_varibles.dart';
import '../data/model/coinfilter_model.dart';

class FilterBottomSheet extends StatefulWidget {
  final CoinFilterModel currentFilter;
  final Function(CoinFilterModel) onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentFilter,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late CoinFilterModel tempFilter;

  @override
  void initState() {
    super.initState();
    tempFilter = widget.currentFilter.copyWith();
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0, bottom: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2E6930) : const Color(0xFF1E2633),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? const Color(0xFF76EC40) : Colors.white70,
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildChipGroup({
    required List<String> options,
    required String selectedValue,
    required Function(String) onSelect,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 10,
      children: options.map((option) {
        return _buildChip(
          label: option,
          isSelected: selectedValue == option,
          onTap: () => onSelect(option),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(marketCap),
          _buildChipGroup(
            options: [
              all,
              'Large: >\$1B',
              'Mid: \$100M to \$1B',
              'Small: \$10M to \$100M',
              'Micro: <\$10M',
              custom,
            ],
            selectedValue: tempFilter.marketCap,
            onSelect: (val) => setState(() => tempFilter.marketCap = val),
          ),

          _buildSectionTitle(hour24Volume),
          _buildChipGroup(
            options: [all, '>\$100K', '>\$1M', '>\$10M', '>\$50M', '>\$100M', custom],
            selectedValue: tempFilter.volume24h,
            onSelect: (val) => setState(() => tempFilter.volume24h = val),
          ),

          _buildSectionTitle(hour24PriceChange),
          _buildChipGroup(
            options: [all, '>10%', '>20%', '>50%', '<-10%', '<-20%', '<-50%', custom],
            selectedValue: tempFilter.priceChange24h,
            onSelect: (val) => setState(() => tempFilter.priceChange24h = val),
          ),

          _buildSectionTitle(fullyDilutedValuation),
          _buildChipGroup(
            options: [all, '>\$10M', '>\$100M', '>\$1B', custom],
            selectedValue: tempFilter.fdv,
            onSelect: (val) => setState(() => tempFilter.fdv = val),
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      tempFilter.reset();
                    });
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF2E3B4E)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    reset,
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(tempFilter);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF61C429),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child:  Text(
                    applyFilter,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}