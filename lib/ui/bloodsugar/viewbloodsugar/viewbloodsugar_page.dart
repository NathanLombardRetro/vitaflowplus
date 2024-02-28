import 'package:flutter/material.dart';
import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:vitaflowplus/ui/testBluetooth/testBlue_page.dart';

class GraphPage extends StatelessWidget {
  final List<double> data = [0.0, 1.0, 1.5, 2.0, 0.5, 1.8, 2.5];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Graph"),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Line Graph",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            SizedBox(
              height: 300, // Specify the height here
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Sparkline(
                  data: data,
                  lineColor: Colors.blue,
                  lineWidth: 3.0,
                  fillMode: FillMode.below,
                  fillColor: Colors.lightBlue.withOpacity(0.5),
                  pointsMode: PointsMode.all,
                  pointColor: Colors.blue,
                  pointSize: 8.0,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeviceScannerPage()),
                );
              },
        child: Icon(Icons.add),
      ),
    );
  }
}