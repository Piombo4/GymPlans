
import 'package:hive/hive.dart';

@HiveType(typeId:2)
class Progress extends HiveObject{
  @HiveField(0)
  double kgs;
  @HiveField(1)
  int reps;
  @HiveField(2)
  DateTime date;

  Progress(this.kgs,this.reps,this.date);

  String toString() {
    return " $kgs $reps $date";
  }
}