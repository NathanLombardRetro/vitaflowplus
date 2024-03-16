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