import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vitaflowplus/models/sugar_model.dart';
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

      // Round off to 2 decimals
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
      List<Workout> lastFourWorkouts =
          fetchedWorkouts.sublist(fetchedWorkouts.length - 4);

      return lastFourWorkouts;
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
}
