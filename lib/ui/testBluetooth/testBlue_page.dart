import 'package:flutter/material.dart';

class DeviceScannerPage extends StatefulWidget {
  @override
  _DeviceScannerPageState createState() => _DeviceScannerPageState();
}

class _DeviceScannerPageState extends State<DeviceScannerPage> {
  TextEditingController bloodSugarController = TextEditingController();
  TextEditingController lastMealController = TextEditingController();
  TextEditingController insulinDoseController = TextEditingController();
  TextEditingController insulinTypeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Sugar Input'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Blood Sugar:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextFormField(
              controller: bloodSugarController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter blood sugar'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Last Meal:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextFormField(
              controller: lastMealController,
              decoration: InputDecoration(hintText: 'Enter last meal'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Insulin Dose:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextFormField(
              controller: insulinDoseController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter insulin dose'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Insulin Type:',
              style: TextStyle(fontSize: 18.0),
            ),
            TextFormField(
              controller: insulinTypeController,
              decoration: InputDecoration(hintText: 'Enter insulin type'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle form submission here
                // You can access the values using the controllers
                String bloodSugar = bloodSugarController.text;
                String lastMeal = lastMealController.text;
                String insulinDose = insulinDoseController.text;
                String insulinType = insulinTypeController.text;

                // Do something with the input data
                print('Blood Sugar: $bloodSugar');
                print('Last Meal: $lastMeal');
                print('Insulin Dose: $insulinDose');
                print('Insulin Type: $insulinType');

                // Clear the form fields
                bloodSugarController.clear();
                lastMealController.clear();
                insulinDoseController.clear();
                insulinTypeController.clear();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}