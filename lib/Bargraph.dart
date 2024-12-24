import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gas_track_ui/Services/FirebaseSevice.dart';
import 'dart:developer' as developer;


class _BarChart extends StatelessWidget {
  final List<BarChartGroupData> barGroups;
  final Widget Function(double, TitleMeta) getXTitles;
  final double maxY;

  const _BarChart({
    required this.barGroups,
    required this.getXTitles,
    required this.maxY,
  });

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getXTitles,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: getYTitles,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: borderData,
        barGroups: barGroups,
        alignment: BarChartAlignment.spaceAround,
        maxY: maxY,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: maxY / 10, // Adjusted for dynamic scaling
          getDrawingHorizontalLine: (value) => FlLine(
            color: Colors.grey.withOpacity(0.5),
            strokeWidth: 1,
          ),
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  static Widget getYTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.blueGrey,
      fontWeight: FontWeight.bold,
      fontSize: 12,
    );
    return value % 10 == 0
        ? SideTitleWidget(
            axisSide: meta.axisSide,
            space: 6,
            child: Text(value.toInt().toString(), style: style),
          )
        : Container();
  }

  static FlBorderData get borderData => FlBorderData(show: false);

  static LinearGradient get _barsGradient => const LinearGradient(
        colors: [Color(0xFFC54239), Color(0xFF7A2AAE)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static List<BarChartGroupData> generateBarGroups(List<double> values) {
    return List.generate(values.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
            gradient: _barsGradient,
            width: 25,
          )
        ],
      );
    });
  }

  static SideTitleWidget Function(double value, TitleMeta meta)
      getDynamicXTitles(List<String> labels) {
    return (double value, TitleMeta meta) {
      const style = TextStyle(color: Colors.black, fontSize: 12);
      int index = value.toInt();
      return SideTitleWidget(
        axisSide: meta.axisSide,
        child: Text(labels[index % labels.length], style: style),
      );
    };
  }
}

class DayGraph extends StatefulWidget {
  final String customerId;

  const DayGraph({super.key, required this.customerId});

  @override
  _DayGraphState createState() => _DayGraphState();
}

class _DayGraphState extends State<DayGraph> {
  List<double> dailyValues = [];

  @override
  void initState() {
    super.initState();
    fetchDailyData();

  }

  List<double> calculateDailyAverages(List<Map<String, dynamic>> readings) {
    DateTime now = DateTime.now();

    // Group readings by 4-hour intervals
    Map<int, List<double>> intervalData =
        {}; // Key: Interval (0-5), Value: Gas readings

    for (var reading in readings) {
      DateTime date = (reading['reading_date'] as Timestamp).toDate();

      // Filter readings for today only
      if (date.year == now.year &&
          date.month == now.month &&
          date.day == now.day) {
        int hour = date.hour; // Hour of the day (0-23)

        // Determine 4-hour interval: 0-3, 4-7, 8-11, ..., 20-23
        int interval = hour ~/ 4;

        double remainGas = double.tryParse(reading['remainGas']) ?? 0;
        intervalData.putIfAbsent(interval, () => []).add(remainGas);
      }
    }

    // Calculate the average for each interval (0-5 for 6 intervals in a day)
    List<double> averages = List.generate(6, (index) {
      if (intervalData.containsKey(index)) {
        double sum = intervalData[index]!.reduce((a, b) => a + b);
        return sum / intervalData[index]!.length;
      }
      return 0; // No data for this interval
    });

    return averages;
  }

  Future<void> fetchDailyData() async {
    FirestoreService service = FirestoreService();
    List<Map<String, dynamic>> readings =
        await service.getGasReadings(widget.customerId);

    setState(() {
      dailyValues = calculateDailyAverages(readings);
      print("dailyValues");
      print(dailyValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return dailyValues.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _BarChart(
            barGroups: _BarChart.generateBarGroups(dailyValues),
            getXTitles: _BarChart.getDynamicXTitles(
              ['12-4 AM', '4-8 AM', '8-12 PM', '12-4 PM', '4-8 PM', '8-12 AM'],
            ),
            maxY: 100,
          );
  }
}

class WeeklyGraph extends StatefulWidget {
  final String customerId;

  const WeeklyGraph({super.key, required this.customerId});

  @override
  _WeeklyGraphState createState() => _WeeklyGraphState();
}

class _WeeklyGraphState extends State<WeeklyGraph> {
  List<double> weeklyValues = [];

  @override
  void initState() {
    super.initState();
    fetchWeeklyData();
  }

  List<double> calculatePastWeekAverages(List<Map<String, dynamic>> readings) {
    DateTime now = DateTime.now();
    DateTime weekAgo = now.subtract(const Duration(days: 7));

    Map<int, List<double>> dailyData = {}; // Maps weekday to readings

    for (var reading in readings) {
      DateTime date = (reading['reading_date'] as Timestamp).toDate();

      // Filter data within the last 7 days
      if (date.isAfter(weekAgo) && date.isBefore(now)) {
        int weekday = date.weekday; // Monday=1, ..., Sunday=7
        double remainGas = double.tryParse(reading['remainGas']) ?? 0;

        dailyData.putIfAbsent(weekday, () => []).add(remainGas);
      }
    }

    // Compute averages for each day (1 = Mon, ..., 7 = Sun)
    List<double> averages = List.generate(7, (index) {
      int weekday = index + 1; // 1-based weekday
      if (dailyData.containsKey(weekday)) {
        double sum = dailyData[weekday]!.reduce((a, b) => a + b);
        return sum / dailyData[weekday]!.length;
      }
      return 0; // No data for this day
    });

    return averages;
  }

  Future<void> fetchWeeklyData() async {
    FirestoreService service = FirestoreService();
    List<Map<String, dynamic>> readings =
        await service.getGasReadings(widget.customerId);
    // print("readings");
    //
    // int usageDays = UsageCalculator.calculateUsageDays(readings);
    // print('Total days of usage: $usageDays');

    developer.log(readings.toString());

    setState(() {
      weeklyValues = calculatePastWeekAverages(readings);
      print("weeklyValues");
      print(weeklyValues);
    });
  }

  @override
  Widget build(BuildContext context) {
    return weeklyValues.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _BarChart(
            barGroups: _BarChart.generateBarGroups(weeklyValues),
            getXTitles: _BarChart.getDynamicXTitles(
              ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            ),
            maxY: 100,
          );
  }
}

// class WeeklyGraph extends StatefulWidget {
//   final String customerId;
//
//   const WeeklyGraph({super.key, required this.customerId});
//
//   @override
//   _WeeklyGraphState createState() => _WeeklyGraphState();
// }
//
// class _WeeklyGraphState extends State<WeeklyGraph> {
//   List<double> weeklyValues = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWeeklyData();
//   }
//
//   List<double> calculateWeeklyAverages(List<Map<String, dynamic>> readings) {
//     Map<int, List<double>> dailyData = {};
//
//     for (var reading in readings) {
//       DateTime date = (reading['reading_date'] as Timestamp).toDate();
//       int weekday = date.weekday;
//       double remainGas = double.tryParse(reading['remainGas']) ?? 0;
//
//       dailyData.putIfAbsent(weekday, () => []).add(remainGas);
//     }
//
//     List<double> averages = [];
//     for (int i = 1; i <= 7; i++) {
//       if (dailyData.containsKey(i)) {
//         double sum = dailyData[i]!.reduce((a, b) => a + b);
//         averages.add(sum / dailyData[i]!.length);
//       } else {
//         averages.add(0);
//       }
//     }
//
//     return averages;
//   }
//
//   Future<void> fetchWeeklyData() async {
//     FirestoreService service = FirestoreService();
//     List<Map<String, dynamic>> readings = await service.getGasReadings(widget.customerId);
//     setState(() {
//       weeklyValues = calculateWeeklyAverages(readings);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return weeklyValues.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         : _BarChart(
//       barGroups: _BarChart.generateBarGroups(weeklyValues),
//       getXTitles: _BarChart.getDynamicXTitles(['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']),
//       maxY: 100,
//     );
//   }
// }

class MonthGraph extends StatefulWidget {
  final String customerId;

  const MonthGraph({super.key, required this.customerId});

  @override
  _MonthGraphState createState() => _MonthGraphState();
}

class _MonthGraphState extends State<MonthGraph> {
  List<double> monthlyAverages = [];

  @override
  void initState() {
    super.initState();
    fetchMonthlyData();
  }

  List<double> calculateMonthlyAverages(List<Map<String, dynamic>> readings) {
    Map<int, List<double>> monthlyData = {};

    for (var reading in readings) {
      DateTime date = (reading['reading_date'] as Timestamp).toDate();
      int month = date.month; // Month: 1 (Jan) to 12 (Dec)
      double remainGas = double.tryParse(reading['remainGas']) ?? 0;

      monthlyData.putIfAbsent(month, () => []).add(remainGas);
    }

    List<double> averages = List.generate(12, (index) {
      int month = index + 1; // Convert index to month (1-12)
      if (monthlyData.containsKey(month)) {
        double sum = monthlyData[month]!.reduce((a, b) => a + b);
        return sum / monthlyData[month]!.length;
      }
      return 0; // No data for that month
    });

    return averages;
  }

  Future<void> fetchMonthlyData() async {
    FirestoreService service = FirestoreService();
    List<Map<String, dynamic>> readings =
        await service.getGasReadings(widget.customerId);

    setState(() {
      monthlyAverages = calculateMonthlyAverages(readings);
    });
  }

  @override
  Widget build(BuildContext context) {
    return monthlyAverages.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : _BarChart(
            barGroups: _BarChart.generateBarGroups(monthlyAverages),
            getXTitles: _BarChart.getDynamicXTitles(
              [
                'Jan',
                'Feb',
                'Mar',
                'Apr',
                'May',
                'Jun',
                'Jul',
                'Aug',
                'Sep',
                'Oct',
                'Nov',
                'Dec'
              ],
            ),
            maxY: 100,
          );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:gas_track_ui/Services/FirebaseSevice.dart';
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
//         enabled: false,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipPadding: EdgeInsets.zero,
//           tooltipMargin: 8,
//           getTooltipItem: (group, groupIndex, rod, rodIndex) {
//             return BarTooltipItem(
//               rod.toY.round().toString(),
//               const TextStyle(
//                 color: Colors.cyan,
//                 fontWeight: FontWeight.bold,
//               ),
//             );
//           },
//         ),
//       );
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
//         show: false,
//       );
//
//   static LinearGradient get _barsGradient => const LinearGradient(
//         colors: [Color(0xFFC54239), Color(0xFF7A2AAE)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       );
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
//     const days = ['12-4', '4-8', '8-12', '12-16', '16-20', '20-24'];
//     return SideTitleWidget(
//       axisSide: meta.axisSide,
//       child: Text(days[value.toInt() % days.length], style: style),
//     );
//   }
//
//   static Widget getWeeklyXTitles(double value, TitleMeta meta) {
//     const style = TextStyle(color: Colors.black, fontSize: 12);
//     const weeks = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
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
// class DayGraph extends StatefulWidget {
//   final String customerId;
//
//   const DayGraph({super.key, required this.customerId});
//
//   @override
//   _DayGraphState createState() => _DayGraphState();
// }
//
// class _DayGraphState extends State<DayGraph> {
//   List<double> dailyValues = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchDailyData();
//   }
//
//   List<double> calculateDailyAverages(List<Map<String, dynamic>> readings) {
//     Map<int, List<double>> hourlyData = {};
//
//     for (var reading in readings) {
//       DateTime date = (reading['reading_date'] as Timestamp).toDate();
//       int hour = date.hour;
//       double remainGas = double.tryParse(reading['remainGas']) ?? 0;
//
//       if (!hourlyData.containsKey(hour)) {
//         hourlyData[hour] = [];
//       }
//       hourlyData[hour]!.add(remainGas);
//     }
//
//     List<double> averages = [];
//     for (int i = 0; i < 24; i += 4) {
//       double sum = 0;
//       int count = 0;
//
//       for (int j = i; j < i + 4; j++) {
//         if (hourlyData[j] != null) {
//           sum += hourlyData[j]!.reduce((a, b) => a + b);
//           count += hourlyData[j]!.length;
//         }
//       }
//
//       averages.add(count > 0 ? sum / count : 0);
//     }
//
//     return averages;
//   }
//
//   Future<void> fetchDailyData() async {
//     FirestoreService service = FirestoreService();
//     List<Map<String, dynamic>> readings =
//         await service.getGasReadings(widget.customerId);
//
//     setState(() {
//       dailyValues = calculateDailyAverages(readings);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print(dailyValues);
//     return dailyValues.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         : _BarChart(
//             barGroups: _BarChart.generateBarGroups(dailyValues),
//             getXTitles: _BarChart.getDayXTitles,
//             maxY: 100, // Adjust maxY based on your data
//           );
//   }
// }
//
// class WeeklyGraph extends StatefulWidget {
//   final String customerId;
//
//   const WeeklyGraph({super.key, required this.customerId});
//
//   @override
//   _WeeklyGraphState createState() => _WeeklyGraphState();
// }
//
// class _WeeklyGraphState extends State<WeeklyGraph> {
//   List<double> weeklyValues = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchWeeklyData();
//   }
//
//   List<double> calculateWeeklyAverages(List<Map<String, dynamic>> readings) {
//     Map<int, List<double>> dailyData = {};
//
//     for (var reading in readings) {
//       DateTime date = (reading['reading_date'] as Timestamp).toDate();
//       int weekday = date.weekday; // Monday = 1, Sunday = 7
//       double remainGas = double.tryParse(reading['remainGas']) ?? 0;
//
//       if (!dailyData.containsKey(weekday)) {
//         dailyData[weekday] = [];
//       }
//       dailyData[weekday]!.add(remainGas);
//     }
//
//     List<double> averages = [];
//     for (int i = 1; i <= 7; i++) {
//       // Days of the week
//       if (dailyData.containsKey(i)) {
//         double sum = dailyData[i]!.reduce((a, b) => a + b);
//         averages.add(sum / dailyData[i]!.length);
//       } else {
//         averages.add(0); // No data for that day
//       }
//     }
//
//     return averages;
//   }
//
//   Future<void> fetchWeeklyData() async {
//     FirestoreService service = FirestoreService();
//     List<Map<String, dynamic>> readings =
//         await service.getGasReadings(widget.customerId);
//
//     setState(() {
//       weeklyValues = calculateWeeklyAverages(readings);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return weeklyValues.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         : _BarChart(
//             barGroups: _BarChart.generateBarGroups(weeklyValues),
//             getXTitles: _BarChart.getWeeklyXTitles,
//             maxY: 100,
//           );
//   }
// }
//
// class MonthGraph extends StatefulWidget {
//   final String customerId;
//
//   const MonthGraph({super.key, required this.customerId});
//
//   @override
//   _MonthGraphState createState() => _MonthGraphState();
// }
//
// class _MonthGraphState extends State<MonthGraph> {
//   List<double> monthlyValues = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchMonthlyData();
//   }
//
//   List<double> calculateMonthlyAverages(List<Map<String, dynamic>> readings) {
//     Map<int, List<double>> monthlyData = {};
//
//     for (var reading in readings) {
//       DateTime date = (reading['reading_date'] as Timestamp).toDate();
//       int day = date.day; // Day of the month
//       double remainGas = double.tryParse(reading['remainGas']) ?? 0;
//
//       if (!monthlyData.containsKey(day)) {
//         monthlyData[day] = [];
//       }
//       monthlyData[day]!.add(remainGas);
//     }
//
//     List<double> averages = [];
//     for (int i = 1; i <= 31; i++) {
//       // Days of the month
//       if (monthlyData.containsKey(i)) {
//         double sum = monthlyData[i]!.reduce((a, b) => a + b);
//         averages.add(sum / monthlyData[i]!.length);
//       } else {
//         averages.add(0); // No data for that day
//       }
//     }
//
//     return averages;
//   }
//
//   Future<void> fetchMonthlyData() async {
//     FirestoreService service = FirestoreService();
//     List<Map<String, dynamic>> readings =
//         await service.getGasReadings(widget.customerId);
//
//     setState(() {
//       monthlyValues = calculateMonthlyAverages(readings);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return monthlyValues.isEmpty
//         ? const Center(child: CircularProgressIndicator())
//         : _BarChart(
//             barGroups: _BarChart.generateBarGroups(monthlyValues),
//             getXTitles: _BarChart.getMonthXTitles,
//             maxY: 100,
//           );
//   }
// }
