// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
//
// class DaysOfUseCalculator {
//   /// Calculates days of use based on critical_flag and reading_date
//   ///
//   /// Returns a Map with dates as keys and days of use as values
//   static Future<Map<DateTime, int>> calculateDaysOfUse(String collectionPath) async {
//     // Get data from Firestore
//     final QuerySnapshot snapshot = await FirebaseFirestore.instance
//         .collection(collectionPath)
//         .orderBy('reading_date')
//         .get();
//
//     // Convert the snapshot to a list of maps
//     final List<Map<String, dynamic>> data = snapshot.docs
//         .map((doc) => doc.data() as Map<String, dynamic>)
//         .toList();
//
//     // Sort the data by reading_date
//     data.sort((a, b) {
//       final DateTime dateA = _parseDate(a['reading_date']);
//       final DateTime dateB = _parseDate(b['reading_date']);
//       return dateA.compareTo(dateB);
//     });
//
//     // Calculate days of use
//     final Map<DateTime, int> daysOfUse = {};
//     int currentDaysCount = 0;
//     DateTime? previousDate;
//     bool previousWasCritical = false;
//
//     for (var entry in data) {
//       final bool isCritical = entry['critical_flag'] == true;
//       final DateTime currentDate = _parseDate(entry['reading_date']);
//
//       // If this is the first entry
//       if (previousDate == null) {
//         currentDaysCount = 1;
//       }
//       // If this is a consecutive day (one day after the previous)
//       else if (_isConsecutiveDay(previousDate, currentDate)) {
//         // If current entry is critical and previous was not critical, reset counter
//         if (isCritical && !previousWasCritical) {
//           currentDaysCount = 1;
//         }
//         // Otherwise, if it's a consecutive day and not resetting, increment the counter
//         else if (!isCritical) {
//           currentDaysCount++;
//         }
//         // If both current and previous are critical, counter remains the same
//       }
//       // If date gap is more than 1 day
//       else {
//         // Reset the counter for non-consecutive days
//         currentDaysCount = 1;
//       }
//
//       // Store the days of use for this date
//       daysOfUse[currentDate] = currentDaysCount;
//
//       // Update previous values for next iteration
//       previousDate = currentDate;
//       previousWasCritical = isCritical;
//     }
//
//     return daysOfUse;
//   }
//
//   /// Parses date string (e.g., "2-Mar") into a DateTime object
//   /// Assumes current year if not specified
//   static DateTime _parseDate(String dateStr) {
//     // Add current year if not present
//     if (!dateStr.contains('-')) {
//       dateStr = "$dateStr-${DateTime.now().year}";
//     } else if (dateStr.split('-').length == 2) {
//       dateStr = "$dateStr-${DateTime.now().year}";
//     }
//
//     // Try parsing with different formats
//     try {
//       return DateFormat("d-MMM-yyyy").parse(dateStr);
//     } catch (e) {
//       try {
//         return DateFormat("dd-MMM-yyyy").parse(dateStr);
//       } catch (e) {
//         throw FormatException("Unable to parse date: $dateStr");
//       }
//     }
//   }
//
//   /// Checks if two dates are consecutive (one day apart)
//   static bool _isConsecutiveDay(DateTime date1, DateTime date2) {
//     final difference = date2.difference(date1).inDays;
//     return difference == 1;
//   }
//
//   /// Helper method to format results for UI display
//   static String formatDaysOfUseResult(Map<DateTime, int> daysOfUse) {
//     final buffer = StringBuffer();
//     final dateFormat = DateFormat("d-MMM");
//
//     daysOfUse.forEach((date, days) {
//       buffer.writeln('on ${dateFormat.format(date)}, days of use = $days');
//     });
//
//     return buffer.toString();
//   }
// }
//
// // Example usage in a Flutter widget
// class DaysOfUseDisplay extends StatefulWidget {
//   final String collectionPath;
//
//   const DaysOfUseDisplay({Key? key, required this.collectionPath}) : super(key: key);
//
//   @override
//   _DaysOfUseDisplayState createState() => _DaysOfUseDisplayState();
// }
//
// class _DaysOfUseDisplayState extends State<DaysOfUseDisplay> {
//   late Future<Map<DateTime, int>> _daysOfUseFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     _daysOfUseFuture = DaysOfUseCalculator.calculateDaysOfUse(widget.collectionPath);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<DateTime, int>>(
//       future: _daysOfUseFuture,
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//
//         if (snapshot.hasError) {
//           return Center(child: Text('Error: ${snapshot.error}'));
//         }
//
//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(child: Text('No data available'));
//         }
//
//         // Display results
//         final daysOfUse = snapshot.data!;
//         final formattedResults = DaysOfUseCalculator.formatDaysOfUseResult(daysOfUse);
//
//         return SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'Days of Use Results',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   formattedResults,
//                   style: const TextStyle(fontSize: 16, height: 1.5),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }