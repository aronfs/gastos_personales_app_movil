import 'package:flutter/material.dart';

/// Representa una transacción individual (gasto o ingreso) para
/// mostrarse en una lista.
class TransactionEntry {
  final String? id;
  final IconData icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String title;
  final String subtitle;
  final String amountLabel;
  final bool isPositive;

  const TransactionEntry({
    this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.amountLabel,
    this.iconBackgroundColor,
    this.iconColor,
    this.isPositive = false,
  });
}
