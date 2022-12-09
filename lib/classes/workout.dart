import 'package:gymplans/classes/exercise.dart';
import 'package:hive/hive.dart';
part 'workout.g.dart';

@HiveType(typeId:0)
class Workout extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Exercise> exercises;
  Workout(this.name, this.exercises);

  String toString() {
    return "$name; $exercises";
  }


}