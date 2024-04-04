import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitaflowplus/models/sleep_model.dart';
import 'package:vitaflowplus/models/sugar_model.dart';
import 'package:vitaflowplus/models/water_model.dart';
import 'package:vitaflowplus/models/workout_model.dart';

class FirebaseFunctions {
  static Future<List<Sugar>> fetchSugarLevels(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sugarLevels')
          .where('userId', isEqualTo: userId)
          .get();

      List<Sugar> fetchedSugarLevels = querySnapshot.docs.map((doc) {
        return Sugar(
          date: doc['date'].toDate(),
          bloodSugar: doc['bloodSugar'],
          insulinDose: doc['insulinDose'],
          userId: doc['userId'],
          insulinType: doc['insulinType'],
          mood: doc['mood'],
          lastMeal: doc['lastMeal'],
        );
      }).toList();
      fetchedSugarLevels.sort((a, b) => a.date.compareTo(b.date));
      return fetchedSugarLevels;
    } catch (error) {
      print("Error fetching sugar levels: $error");
      throw error;
    }
  }

  static Future<List<Sugar>> fetchLatestSugarLevels(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sugarLevels')
          .where('userId', isEqualTo: userId)
          .get();

      List<Sugar> fetchedSugarLevels = querySnapshot.docs.map((doc) {
        return Sugar(
          date: doc['date'].toDate(),
          bloodSugar: doc['bloodSugar'],
          insulinDose: doc['insulinDose'],
          userId: doc['userId'],
          insulinType: doc['insulinType'],
          mood: doc['mood'],
          lastMeal: doc['lastMeal'],
        );
      }).toList();
      fetchedSugarLevels.sort((a, b) => a.date.compareTo(b.date));
      fetchedSugarLevels = fetchedSugarLevels.take(15).toList();

      return fetchedSugarLevels;
    } catch (error) {
      print("Error fetching sugar levels: $error");
      throw error;
    }
  }

  static Future<Uint8List?> getUserProfileImageData(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('userPictures')
        .where('userId', isEqualTo: userId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      querySnapshot.docs.sort((a, b) => a['date'].compareTo(b['date']));

      List<int> imageData = List<int>.from(querySnapshot.docs.first['imageData']);
      Uint8List imageBytes = Uint8List.fromList(imageData);
      return imageBytes;
    } else {
      return null;
    }
  } catch (e) {
    print('Error fetching user profile picture: $e');
    return null;
  }
}

  static Future<Map<String, dynamic>> calculateSugarMetrics(
      String userId) async {
    try {
      List<Sugar> fetchedSugarLevels = await fetchSugarLevels(userId);

      double totalSugar = fetchedSugarLevels
          .map((sugar) => double.parse(sugar.bloodSugar))
          .fold(0, (prev, curr) => prev + curr);
      double averageSugar = totalSugar / fetchedSugarLevels.length;

      Map<String, int> moodCount = {};
      fetchedSugarLevels.forEach((sugar) {
        if (sugar.mood != null) {
          if (moodCount.containsKey(sugar.mood)) {
            moodCount[sugar.mood] = moodCount[sugar.mood]! + 1;
          } else {
            moodCount[sugar.mood] = 1;
          }
        }
      });
      String mostCommonMood =
          moodCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;

      double totalInsulin = fetchedSugarLevels
          .map((sugar) => double.parse(sugar.insulinDose))
          .fold(0, (prev, curr) => prev + curr);
      double averageInsulin = totalInsulin / fetchedSugarLevels.length;

      averageSugar = double.parse(averageSugar.toStringAsFixed(2));
      averageInsulin = double.parse(averageInsulin.toStringAsFixed(2));

      return {
        'Average Sugar Level (mmol/L)': averageSugar,
        'Most Common Mood': mostCommonMood,
        'Average Insulin Dosage (Units)': averageInsulin,
      };
    } catch (error) {
      print("Error calculating sugar metrics: $error");
      throw error;
    }
  }

  static Future<Sugar?> fetchLastSugarLevel(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sugarLevels')
          .where('userId', isEqualTo: userId)
          .get();

      List<Sugar> fetchedSugarLevels = querySnapshot.docs.map((doc) {
        return Sugar(
          date: doc['date'].toDate(),
          bloodSugar: doc['bloodSugar'],
          insulinDose: doc['insulinDose'],
          userId: doc['userId'],
          insulinType: doc['insulinType'],
          mood: doc['mood'],
          lastMeal: doc['lastMeal'],
        );
      }).toList();
      fetchedSugarLevels.sort((a, b) => a.date.compareTo(b.date));
      if (fetchedSugarLevels.isNotEmpty) {
        return fetchedSugarLevels.last;
      } else {
        return null;
      }
    } catch (error) {
      print("Error fetching sugar levels: $error");
      throw error;
    }
  }

  static Future<List<Workout>> fetchLatestWorkouts(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('workouts')
        .where('userId', isEqualTo: userId)
        .get();

    List<Workout> fetchedWorkouts = querySnapshot.docs.map((doc) {
      return Workout(
        workoutName: doc['workoutName'],
        workoutDescription: doc['workoutDescription'],
        timeTrained: doc['timeTrained'],
        exercises: List<String>.from(doc['exercises']),
        userId: doc['userId'],
        date: doc['date'].toDate(),
      );
    }).toList();
    fetchedWorkouts.sort((a, b) => a.date.compareTo(b.date));

    // Ensure that there are at least four workouts available
    if (fetchedWorkouts.length <= 4) {
      return fetchedWorkouts;
    } else {
      // If there are more than four workouts, get the last four
      return fetchedWorkouts.sublist(fetchedWorkouts.length - 4);
    }
  } catch (error) {
    print("Error fetching workouts: $error");
    throw error;
  }
}

  static Future<List<Workout>> fetchWorkouts(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .where('userId', isEqualTo: userId)
          .get();

      List<Workout> fetchedWorkouts = querySnapshot.docs.map((doc) {
        return Workout(
          workoutName: doc['workoutName'],
          workoutDescription: doc['workoutDescription'],
          timeTrained: doc['timeTrained'],
          exercises: List<String>.from(doc['exercises']),
          userId: doc['userId'],
          date: doc['date'].toDate(),
        );
      }).toList();

      return fetchedWorkouts;
    } catch (error) {
      print("Error fetching workouts: $error");
      throw error;
    }
  }

  static Future<List<Workout>> fetchLatestWorkout(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('workouts')
          .where('userId', isEqualTo: userId)
          .get();

      List<Workout> fetchedWorkouts = querySnapshot.docs.map((doc) {
        return Workout(
          workoutName: doc['workoutName'],
          workoutDescription: doc['workoutDescription'],
          timeTrained: doc['timeTrained'],
          exercises: List<String>.from(doc['exercises']),
          userId: doc['userId'],
          date: doc['date'].toDate(),
        );
      }).toList();
      fetchedWorkouts.sort((a, b) => a.date.compareTo(b.date));
      List<Workout> lastFourWorkouts =
          fetchedWorkouts.sublist(fetchedWorkouts.length - 1);

      return lastFourWorkouts;
    } catch (error) {
      print("Error fetching workouts: $error");
      throw error;
    }
  }

  static Future<double> fetchAverageWaterIntake(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('waterIntakes')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return 0.0;
      }

      double sum = querySnapshot.docs
          .fold(0.0, (previous, current) => previous + current['amount']);

      double average = sum / querySnapshot.docs.length;

      return average;
    } catch (error) {
      print("Error fetching water intakes: $error");
      throw error;
    }
  }

  static Future<double> fetchWaterIntakeSumLastWeek(String userId) async {
    try {
      DateTime now = DateTime.now();
      DateTime lastWeek = now.subtract(Duration(days: 7));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('waterIntakes')
          .where('userId', isEqualTo: userId)
          .get();

      double sum = 0.0;

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        DateTime documentDate = (document['date'] as Timestamp).toDate();
        if (documentDate.isAfter(lastWeek)) {
          sum += document['amount'] ?? 0.0;
        }
      });

      return sum;
    } catch (error) {
      print("Error fetching water intake sum for last week: $error");
      throw error;
    }
  }

  static Future<String> fetchAverageSleep(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sleepData')
          .where('userId', isEqualTo: userId)
          .get();

      if (querySnapshot.docs.isEmpty) {
        return '0h 0m';
      }

      int totalMinutes = querySnapshot.docs.fold(
          0, (previous, current) => previous + (current['duration'] as int));
      int numberOfEntries = querySnapshot.docs.length;
      int averageTotalMinutes = totalMinutes ~/ numberOfEntries;

      int hours = averageTotalMinutes ~/ 60;
      int minutes = averageTotalMinutes % 60;

      return '$hours h $minutes m';
    } catch (error) {
      print("Error fetching sleep data: $error");
      throw error;
    }
  }

  static Future<List<Sleep>> fetchSleepData(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sleepData')
          .where('userId', isEqualTo: userId)
          .get();

      List<Sleep> fetchedSleep = querySnapshot.docs.map((doc) {
        return Sleep(
          duration: (doc['duration'] as num).toDouble(),
          userId: doc['userId'],
          date: doc['date'].toDate(),
        );
      }).toList();

      fetchedSleep.sort((a, b) => a.date.compareTo(b.date));

      return fetchedSleep;
    } catch (error) {
      print("Error fetching sleep data: $error");
      throw error;
    }
  }

  static Future<String> fetchSleepSumLastWeek(String userId) async {
    try {
      DateTime now = DateTime.now();
      DateTime lastWeek = now.subtract(Duration(days: 7));

      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sleepData')
          .where('userId', isEqualTo: userId)
          .get();

      int totalMinutes = 0;

      querySnapshot.docs.forEach((DocumentSnapshot document) {
        Timestamp timestamp = document['date'] as Timestamp;
        DateTime documentDate = timestamp.toDate();
        int duration = document['duration'] as int;

        if (documentDate.isAfter(lastWeek) && duration != null) {
          totalMinutes += duration;
        }
      });

      int hours = totalMinutes ~/ 60;
      int minutes = totalMinutes % 60;

      return '$hours h $minutes m';
    } catch (error) {
      print("Error fetching sleep data for the last week: $error");
      throw error;
    }
  }

  static Future<String?> fetchLastSleep(String userId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('sleepData')
          .where('userId', isEqualTo: userId)
          .get();

      List<Sleep> fetchedSleep = querySnapshot.docs.map((doc) {
        return Sleep(
          duration: (doc['duration'] as num).toDouble(),
          userId: doc['userId'],
          date: doc['date'].toDate(),
        );
      }).toList();

      fetchedSleep.sort((a, b) => a.date.compareTo(b.date));
      if (fetchedSleep.isNotEmpty) {
        double totalMinutes = fetchedSleep.last.duration;

        int hours = totalMinutes ~/ 60;
        int minutes = (totalMinutes % 60).toInt();

        return '$hours h $minutes m';
      } else {
        return "None";
      }
    } catch (error) {
      print("Error lastest sleep time: $error");
      throw error;
    }
  }

  static Future<waterIntake?> fetchLastWater(String userId) async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('waterIntakes')
        .where('userId', isEqualTo: userId)
        .get();

    List<waterIntake> fetchedWater = querySnapshot.docs.map((doc) {
      return waterIntake(
        amount: (doc['amount'] as num).toDouble(),
        userId: doc['userId'],
        date: doc['date'].toDate(),
      );
    }).toList();

    fetchedWater.sort((a, b) => a.date.compareTo(b.date));
    
    if (fetchedWater.isNotEmpty) {
      return fetchedWater.last;
    } else {
      return null;
    }
  } catch (error) {
    print("Error fetching latest water intake: $error");
    throw error;
  }
}
}
