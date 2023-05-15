import 'package:flutter/material.dart';
import 'package:octopus/module/historical_data/interfaces/widgets/historical_screen_template.dart';

class DailyTimeRecordScreen extends StatelessWidget {
  const DailyTimeRecordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HistoricalScreenTemplate(
      generateBtnText: 'Generate Daily Time Record',
      title: 'Daily Time Record',
    );
  }
}
