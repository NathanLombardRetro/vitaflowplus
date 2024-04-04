import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:theme_provider/theme_provider.dart';
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
    ThemeData currentTheme = ThemeProvider.themeOf(context).data;
    return Scaffold(
      backgroundColor: currentTheme.primaryColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Sugar Level Trends",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: currentTheme.primaryColorLight),
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Sugar>>(
                future: FirebaseFunctions.fetchSugarLevels(user.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    List<Sugar> sugarData = snapshot.data ?? [];
                    List<ChartData> chartData = sugarData
                        .asMap()
                        .entries
                        .map((entry) => ChartData(entry.key.toString(),
                            double.parse(entry.value.bloodSugar)))
                        .toList();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: SfCartesianChart(
                            primaryXAxis: CategoryAxis(
                              title: AxisTitle(text: 'Times tested',textStyle: TextStyle(color: currentTheme.primaryColorLight),),
                              majorGridLines: MajorGridLines(
                                  width: 0),
                                  labelStyle: TextStyle(color: currentTheme.primaryColorLight),
                            ),
                            primaryYAxis: NumericAxis(
                              title: AxisTitle(text: 'Blood Sugar Level',textStyle: TextStyle(color: currentTheme.primaryColorLight),),
                              majorGridLines: MajorGridLines(
                                  width: 0),
                                  labelStyle: TextStyle(color: currentTheme.primaryColorLight),
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
                        FutureBuilder<Map<String, dynamic>>(
                          future:
                              FirebaseFunctions.calculateSugarMetrics(user.uid),
                          builder: (context, metricsSnapshot) {
                            if (metricsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              Map<String, dynamic>? metrics =
                                  metricsSnapshot.data;
                              if (metrics != null && metrics.isNotEmpty) {
                                return Column(
                                  children: metrics.entries.map((entry) {
                                    return Padding(
                                      padding: EdgeInsets.only(bottom: 16.0),
                                      child: MetricTile(
                                        label: entry.key,
                                        value: entry.value.toString(),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return Center(child: Text('No data available', style: TextStyle(color: currentTheme.primaryColorLight),));
                              }
                            }
                          },
                        ),
                        SizedBox(height: 20)
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 0.0, right: 5.0),
        child: SizedBox(
          width: 100,
          height: 30,
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
