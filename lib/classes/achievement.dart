import 'package:gymplans/classes/progress.dart';
import 'package:hive/hive.dart';

@HiveType(typeId:2)
class Achievement extends HiveObject{
  @HiveField(0)
  String name;
  @HiveField(1)
  List<Progress> progress;

  Achievement(this.name,this.progress);

  String toString() {
    return " $name $progress";
  }
}