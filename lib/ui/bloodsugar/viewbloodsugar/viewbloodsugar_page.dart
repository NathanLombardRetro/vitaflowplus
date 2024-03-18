import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
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
        child: FutureBuilder<Map<String, dynamic>>(
          future: FirebaseFunctions.calculateSugarMetrics(user.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              Map<String, dynamic> metrics = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.0),
                    child: Text(
                      "Diabetic trends",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: MetricTile(
                      label: "Sugar level graph",
                      value: "",
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color.fromARGB(255, 253, 253, 252)),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: FutureBuilder<List<Sugar>>(
                        future: FirebaseFunctions.fetchSugarLevels(user.uid),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else {
                            List<double> data = snapshot.data!
                                .map((sugar) => double.parse(sugar.bloodSugar))
                                .toList();
                            return Sparkline(
                              data: data,
                              lineColor: Color(0xFF26547C),
                              lineWidth: 3.0,
                              fillMode: FillMode.below,
                              fillColor: Color(0xFF26547C).withOpacity(0.1),
                              pointsMode: PointsMode.all,
                              pointColor: Color(0xFF26547C),
                              pointSize: 8.0,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  Column(
                    children: metrics.entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: MetricTile(
                          label: entry.key,
                          value: entry.value.toString(),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 25),
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
              "Add info",
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
