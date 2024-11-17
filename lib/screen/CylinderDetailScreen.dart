import 'package:flutter/material.dart';
import 'package:gas_track_ui/screen/OtpScreen.dart';
import 'package:gas_track_ui/Bargraph.dart';
import 'package:gas_track_ui/utils/utils.dart';

class CylinderDetailScreen extends StatefulWidget {
  const CylinderDetailScreen({super.key});

  @override
  State<CylinderDetailScreen> createState() => _CylinderDetailScreenState();
}

class _CylinderDetailScreenState extends State<CylinderDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: 3, vsync: this, initialIndex: _selectedIndex);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchInitialData() async {
    // Add logic to fetch data here, e.g., fetch gas readings.
    setState(() {
      // Update state if necessary after fetching data
    });
  }

  Future<void> _refreshData() async {
    // Refresh the data when the user pulls down
    await _fetchInitialData();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cylinder Details",
          style: AppStyles.appBarTextStyle,
        ),
        backgroundColor: Colors.transparent, // Makes the background transparent
        elevation: 0, // Removes the shadow below the AppBar
        centerTitle: true, // Optional: centers the title
        iconTheme: const IconThemeData(
            color: Colors.white), // Makes the back arrow white
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      extendBodyBehindAppBar: true, // Ensures the body goes behind the AppBar
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // Gradient with Custom Clip Path at the top of the screen
              ClipPath(
                clipper:
                    TopRoundedRectangleClipper(), // Custom clipper for the top curve
                child: Container(
                  height: height * 0.30, // Adjust height of the effect
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFA7365),
                        Color(0xFF9A4DFF)
                      ], // Gradient colors
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),

              Padding(
                padding:
                    EdgeInsets.only(top: height / 9.5), // Adjust for gradient
                child: Container(
                  height: height,
                  width: width,
                  decoration: BoxDecoration(
                    color: Colors.white54.withOpacity(0.30),
                    borderRadius: BorderRadius.circular(45.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Container(
                      width: width,
                      height: height,
                      decoration: BoxDecoration(
                        color: Colors.white54.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(45.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          child: Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Card(
                                          elevation: 2,
                                          child: Container(
                                            width: width / 2.5,
                                            height: height / 10,
                                            padding: const EdgeInsets.all(
                                                12), // Padding inside the container
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(
                                                  12), // Rounded edges for the container
                                            ),
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment
                                                  .center, // Center contents inside the container
                                              children: [
                                                Text(
                                                  "Total Remaining",
                                                  style:
                                                      AppStyles.customTextStyle(
                                                          fontSize: 14.0,
                                                          fontWeight:
                                                              FontWeight.w400),
                                                ),
                                                Text(
                                                  "${Utils.remainGas} %",
                                                  style:
                                                      AppStyles.customTextStyle(
                                                          fontSize: 25.0,
                                                          fontWeight:
                                                              FontWeight.w700),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 400,
                                    // color: Colors.cyan,
                                    child: Center(
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 20.0, left: 20),
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    spreadRadius: 2,
                                                    blurRadius: 5,
                                                  ),
                                                ],
                                              ),
                                              child: TabBar(
                                                dividerHeight:0,
                                                controller: _tabController,
                                                onTap: (index) {
                                                  setState(() {
                                                    _selectedIndex = index;
                                                  });
                                                },
                                                indicator: BoxDecoration(
                                                  color: AppStyles.cutstomIconColor,
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                labelColor: Colors.white,
                                                unselectedLabelColor: Colors.white,
                                                tabs: [

                                                  Tab(
                                                    child: Text(
                                                      '       Day        ',
                                                      style: TextStyle(
                                                          color:
                                                              _selectedIndex == 0
                                                                  ? Colors.white
                                                                  : Colors.grey),
                                                    ),
                                                  ),
                                                  Tab(
                                                    child: Text(
                                                      '       Week        ',
                                                      style: TextStyle(
                                                          color:
                                                              _selectedIndex == 1
                                                                  ? Colors.white
                                                                  : Colors.grey),
                                                    ),
                                                  ),
                                                  Tab(
                                                    child: Text(
                                                      '       Month        ',
                                                      style: TextStyle(
                                                          color:
                                                              _selectedIndex == 2
                                                                  ? Colors.white
                                                                  : Colors.grey),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          Expanded(
                                            child: TabBarView(
                                              controller: _tabController,
                                              children: [
                                                Center(
                                                  child: Container(
                                                    width: width -
                                                        20, // Set the width of the container
                                                    height:
                                                    300, // Set the height of the container
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .white, // Optional: background color
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          16), // Optional: rounded corners
                                                      boxShadow: [
                                                        // BoxShadow(
                                                        //   color: Colors.grey
                                                        //       .withOpacity(0.5),
                                                        //   spreadRadius: 5,
                                                        //   blurRadius: 7,
                                                        //   offset: Offset(0,
                                                        //       3), // Optional: shadow offset
                                                        // ),
                                                      ],
                                                    ),
                                                    child:
                                                     DayGraph(customerId: Utils.cusUuid,), // Call the BarChartSample3 widget here
                                                  ),
                                                ),
                                                Center(
                                                  child: Container(
                                                    width: width -
                                                        20, // Set the width of the container
                                                    height:
                                                    300, // Set the height of the container
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .white, // Optional: background color
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          16), // Optional: rounded corners
                                                      boxShadow: [
                                                        // BoxShadow(
                                                        //   color: Colors.grey
                                                        //       .withOpacity(0.5),
                                                        //   spreadRadius: 5,
                                                        //   blurRadius: 7,
                                                        //   offset: Offset(0,
                                                        //       3), // Optional: shadow offset
                                                        // ),
                                                      ],
                                                    ),
                                                    child:
                                                     WeeklyGraph(customerId: Utils.cusUuid,), // Call the BarChartSample3 widget here
                                                  ),
                                                ),
                                                // Center(child: Text("Day View")),
                                                Center(
                                                  child: Container(
                                                    width: width -
                                                        20, // Set the width of the container
                                                    height:
                                                        300, // Set the height of the container
                                                    padding:
                                                        const EdgeInsets.all(8.0),
                                                    decoration: BoxDecoration(
                                                      color: Colors
                                                          .white, // Optional: background color
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              16), // Optional: rounded corners
                                                      boxShadow: [
                                                        // BoxShadow(
                                                        //   color: Colors.grey
                                                        //       .withOpacity(0.5),
                                                        //   spreadRadius: 5,
                                                        //   blurRadius: 7,
                                                        //   offset: Offset(0,
                                                        //       3), // Optional: shadow offset
                                                        // ),
                                                      ],
                                                    ),
                                                    child:
                                                         MonthGraph( customerId: Utils.cusUuid,), // Call the BarChartSample3 widget here
                                                  ),
                                                ),
                                                // Center(child: Text("Month View")),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    alignment: Alignment
                                        .topCenter, // Aligns children in the center of the stack
                                    children: [
                                      const SizedBox(height: 40),
                                      // Background image
                                      Image.asset(
                                        "assets/images/Splashscreen/building.png",
                                        width: width,
                                        color: Colors.grey,
                                        fit: BoxFit.fitWidth,
                                      ),

                                      // Centered button
                                    ],
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom clipper for creating a curved top
class TopRoundedRectangleClipper extends CustomClipper<Path> {
  final double radius; // Controls the corner radius
  final double heightFactor; // Controls the height to clip

  // Default radius is 30, and heightFactor is 0.25 (i.e., 25% of the container height)
  TopRoundedRectangleClipper({this.radius = 00.0, this.heightFactor = 0.60});

  @override
  Path getClip(Size size) {
    var clippedHeight = size.height *
        heightFactor; // Calculate clipped height based on the heightFactor
    var path = Path();

    // Start from bottom-left corner
    path.moveTo(0, clippedHeight);

    // Bottom line to the right
    path.lineTo(size.width, clippedHeight);

    // Line to the top-right corner but we will start curving for the top corners
    path.lineTo(size.width, radius);

    // Create a rounded corner on the top-right
    path.arcToPoint(
      Offset(size.width - radius, 0),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Line to the top-left with rounded corner
    path.lineTo(radius, 0);
    path.arcToPoint(
      Offset(0, radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // Close the path back to the bottom-left corner
    path.lineTo(0, clippedHeight);
    path.close(); // Close the path to form the shape

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
