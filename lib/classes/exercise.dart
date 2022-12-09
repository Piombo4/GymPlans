import 'package:hive/hive.dart';
part 'exercise.g.dart';

@HiveType(typeId:1)
class Exercise extends HiveObject{
  @HiveField(0)
   String name;
  @HiveField(1)
  String notes;
  @HiveField(2)
  int sets;
  @HiveField(3)
  int reps;
  @HiveField(4)
  int sec;
  @HiveField(5)
  int min;


  Exercise(this.name, this.notes, this.sets, this.reps, this.sec, this.min);

  String toString() {
    return "$name $sets $reps $sec $min $notes";
  }
}