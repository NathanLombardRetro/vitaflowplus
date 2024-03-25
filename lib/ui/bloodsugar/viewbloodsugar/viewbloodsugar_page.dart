import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vitaflowplus/components/bottom_navigation.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/sugar_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';
import 'package:vitaflowplus/ui/dashboard/dashboard_page.dart';
import 'package:vitaflowplus/ui/healthpage/viewhealth/viewhealth_page.dart';
import 'package:vitaflowplus/ui/testBluetooth/testBlue_page.dart';
import 'package:vitaflowplus/ui/workouts/workout/workouts.dart';
import 'package:vitaflowplus/widgets/metric-tile-widget.dart';

class GraphPage extends StatefulWidget {
  @override
  _GraphPageState createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Color.fromARGB(255, 253, 253, 252),
    appBar: PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: CustomAppBar(),
    ),
    body: Padding(
      padding: EdgeInsets.all(20.0),
      child: FutureBuilder<List<Sugar>>(
        future: FirebaseFunctions.fetchSugarLevels(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<Sugar> sugarData = snapshot.data ?? [];

            Map<String, dynamic> metrics = {
              'Average Insulin Dosage': 15.0,
              'Most Common Mood': 'Happy',
              'Average Sugar Level': 5.5,
              'Last Meal': 'Chicken salad',
            };

            List<ChartData> chartData = sugarData
                .asMap()
                .entries
                .map((entry) => ChartData(
                    entry.key.toString(),
                    double.parse(entry.value.bloodSugar)))
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "Sugar Level Trends",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: SfCartesianChart(
                          primaryXAxis: CategoryAxis(
                            title: AxisTitle(text: 'Day'),
                            majorGridLines:
                                MajorGridLines(width: 0), // Hide major grid lines
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Blood Sugar Level'),
                            majorGridLines:
                                MajorGridLines(width: 0), // Show major grid lines
                          ),
                          series: <CartesianSeries>[
                            LineSeries<ChartData, String>(
                              dataSource: chartData,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              color: Color(0xFF26547C),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: metrics.entries.map((entry) {
                          return Padding(
                            padding:
                                EdgeInsets.only(bottom: 16.0),
                            child: MetricTile(
                              label: entry.key,
                              value: entry.value.toString(),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    ),
    floatingActionButton: Padding(
      padding: EdgeInsets.only(bottom: 5.0, right: 5.0),
      child: SizedBox(
        width: 100,
        height: 25,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DeviceScannerPage()),
            );
          },
          backgroundColor: Color.fromARGB(255, 253, 253, 252),
          foregroundColor: Color(0xFF26547C),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: Color(0xFF26547C), width: 1),
          ),
          child: Text(
            "Add sugar",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    ),
    bottomNavigationBar: CustomBottomNavigationBar(
      selectedIndex: 2,
      onTabSelected: (index) {
        if (index == 0) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Dashboard()));
        } else if (index == 1) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WorkoutsPage()));
        } else if (index == 3) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => SleepWaterPage()));
        }
      },
    ),
  );
}
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
