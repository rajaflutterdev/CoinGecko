import 'package:flutter/material.dart';

class PriceChange extends StatelessWidget {
  final double value;

  const PriceChange({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final positive = value >= 0;

    return Text(
      '${positive ? '+' : ''}${value.toStringAsFixed(2)}%',
      style: TextStyle(
        color: positive
            ? Colors.greenAccent
            : Colors.redAccent,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}