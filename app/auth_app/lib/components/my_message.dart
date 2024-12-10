import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyMessage extends StatelessWidget {
  const MyMessage({super.key, required this.timestamp});

  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    const datePattern = 'dd MMM yyyy, HH:mm';
    final timesTampFormatted = DateFormat(datePattern).format(timestamp);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        timesTampFormatted,
        style: const TextStyle(color: Colors.blue, fontSize: 12, fontStyle: FontStyle.italic),
      ),
    );
  }
}