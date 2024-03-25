import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:vitaflowplus/components/top_navigation.dart';
import 'package:vitaflowplus/models/sleep_model.dart';
import 'package:vitaflowplus/services/firebaseFunctions.dart';

class SleepTrendsPage extends StatefulWidget {
  @override
  _SleepTrendsPageState createState() => _SleepTrendsPageState();
}

class _SleepTrendsPageState extends State<SleepTrendsPage> {
  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: FutureBuilder<List<Sleep>>(
          future: FirebaseFunctions.fetchSleepData(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              List<Sleep> sleepData = snapshot.data ?? [];
              List<ChartData> chartData = sleepData
                  .asMap()
                  .entries
                  .map((entry) => ChartData(
                      entry.key.toString(), entry.value.duration.toDouble()))
                  .toList();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FloatingActionButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          backgroundColor: Color.fromARGB(255, 253, 253, 252),
                          foregroundColor: Color(0xFF26547C),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side:
                                BorderSide(color: Color.fromARGB(255, 253, 253, 252), width: 0),
                          ),
                          child: Icon(Icons.arrow_back),
                        ),
                        Text(
                          "Sleep Trend",
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    flex: 1,
                    child: SfCartesianChart(
                      backgroundColor: Colors.white, // Set background color
                      primaryXAxis: CategoryAxis(
                        title: AxisTitle(text: 'Day'),
                        majorGridLines: MajorGridLines(color: Colors.white),
                        labelStyle: TextStyle(
                            color: Colors.black), // Set label text color
                      ),
                      primaryYAxis: NumericAxis(
                        title: AxisTitle(text: 'Sleep Duration (min)'),
                        majorGridLines: MajorGridLines(color: Colors.white),
                        labelStyle: TextStyle(
                            color: Colors.black), // Set label text color
                        edgeLabelPlacement: EdgeLabelPlacement.shift,
                      ),
                      series: <CartesianSeries>[
                        ScatterSeries<ChartData, String>(
                          dataSource: chartData,
                          xValueMapper: (ChartData data, _) => data.x,
                          yValueMapper: (ChartData data, _) => data.y,
                          color: Color(0xFF26547C), // Set series color
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
    );
  }
}

class ChartData {
  final String x;
  final double y;

  ChartData(this.x, this.y);
}
