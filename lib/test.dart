// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
//
// void main() {
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Dynamic Bar Graphs')),
//         body: Column(
//           children: const [
//             Expanded(child: DayGraph()), // Dynamic Day Graph
//             Expanded(child: WeeklyGraph()), // Dynamic Weekly Graph
//             Expanded(child: MonthGraph()), // Dynamic Month Graph
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _BarChart extends StatelessWidget {
//   final List<BarChartGroupData> barGroups;
//   final Widget Function(double, TitleMeta) getXTitles;
//   final double maxY;
//
//   const _BarChart({
//     required this.barGroups,
//     required this.getXTitles,
//     required this.maxY,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BarChart(
//       BarChartData(
//         barTouchData: barTouchData,
//         titlesData: FlTitlesData(
//           bottomTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               getTitlesWidget: getXTitles,
//             ),
//           ),
//           leftTitles: AxisTitles(
//             sideTitles: SideTitles(
//               showTitles: true,
//               reservedSize: 40,
//               getTitlesWidget: getYTitles,
//             ),
//           ),
//           topTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//           rightTitles: const AxisTitles(
//             sideTitles: SideTitles(showTitles: false),
//           ),
//         ),
//         borderData: borderData,
//         barGroups: barGroups,
//         alignment: BarChartAlignment.spaceAround,
//         maxY: maxY,
//         gridData: FlGridData(
//           show: true,
//           drawVerticalLine: false,
//           horizontalInterval: 10,
//           getDrawingHorizontalLine: (value) => FlLine(
//             color: Colors.grey.withOpacity(0.5),
//             strokeWidth: 1,
//           ),
//         ),
//       ),
//     );
//   }
//
//   BarTouchData get barTouchData => BarTouchData(
//     enabled: false,
//     touchTooltipData: BarTouchTooltipData(
//       tooltipPadding: EdgeInsets.zero,
//       tooltipMargin: 8,
//       getTooltipItem: (group, groupIndex, rod, rodIndex) {
//         return BarTooltipItem(
//           rod.toY.round().toString(),
//           const TextStyle(
//             color: Colors.cyan,
//             fontWeight: FontWeight.bold,
//           ),
//         );
//       },
//     ),
//   );
//
//   static Widget getYTitles(double value, TitleMeta meta) {
//     const style = TextStyle(
//       color: Colors.blueGrey,
//       fontWeight: FontWeight.bold,
//       fontSize: 12,
//     );
//     if (value % 20 == 0) {
//       return SideTitleWidget(
//         axisSide: meta.axisSide,
//         space: 6,
//         child: Text(value.toInt().toString(), style: style),
//       );
//     } else {
//       return Container();
//     }
//   }
//
//   static FlBorderData get borderData => FlBorderData(
//     show: false,
//   );
//
//   static LinearGradient get _barsGradient => const LinearGradient(
//     colors: [Color(0xFFC54239), Color(0xFF7A2AAE)],
//     begin: Alignment.topLeft,
//     end: Alignment.bottomRight,
//   );
//
//   static List<BarChartGroupData> generateBarGroups(List<double> values) {
//     return List.generate(values.length, (index) {
//       return BarChartGroupData(
//         x: index,
//         barRods: [
//           BarChartRodData(
//             toY: values[index],
//             gradient: _barsGradient,
//             width: 25,
//           )
//         ],
//       );
//     });
//   }
//
//   static Widget getDayXTitles(double value, TitleMeta meta) {
//     const style = TextStyle(color: Colors.black, fontSize: 12);
//     const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(days[value.toInt() % days.length], style: style),
//     );
//   }
//
//   static Widget getWeeklyXTitles(double value, TitleMeta meta) {
//     const style = TextStyle(color: Colors.black, fontSize: 12);
//     const weeks = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(weeks[value.toInt() % weeks.length], style: style),
//     );
//   }
//
//   static Widget getMonthXTitles(double value, TitleMeta meta) {
//     const style = TextStyle(color: Colors.black, fontSize: 12);
//     const months = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'May',
//       'Jun',
//       'Jul',
//       'Aug',
//       'Sep',
//       'Oct',
//       'Nov',
//       'Dec'
//     ];
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(months[value.toInt() % months.length], style: style),
//     );
//   }
// }
//
// class DayGraph extends StatelessWidget {
//   const DayGraph({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<double> dailyValues = [50, 70, 90, 40, 60, 30, 80]; // Example dynamic data
//     return _BarChart(
//       barGroups: _BarChart.generateBarGroups(dailyValues),
//       getXTitles: _BarChart.getDayXTitles,
//       maxY: 100,
//     );
//   }
// }
//
// class WeeklyGraph extends StatelessWidget {
//   const WeeklyGraph({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<double> weeklyValues = [30, 50, 70, 20, 90, 60, 40]; // Example dynamic data
//     return _BarChart(
//       barGroups: _BarChart.generateBarGroups(weeklyValues),
//       getXTitles: _BarChart.getWeeklyXTitles,
//       maxY: 100,
//     );
//   }
// }
//
// class MonthGraph extends StatelessWidget {
//   const MonthGraph({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     List<double> monthlyValues = [50, 70, 90, 30, 80, 60, 100, 40, 70, 90, 80, 60]; // Example dynamic data
//     return _BarChart(
//       barGroups: _BarChart.generateBarGroups(monthlyValues),
//       getXTitles: _BarChart.getMonthXTitles,
//       maxY: 120,
//     );
//   }
// }
