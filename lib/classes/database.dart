import 'package:gymplans/classes/workout.dart';
import 'package:hive/hive.dart';

class WorkoutDatabase{
  List<Workout> workoutsList=[];
  final _myBox = Hive.box('myBox');

  //run this method if first time opening the app
  void createInitialData(){
    workoutsList=[];
    //print(workoutsList.toString());
  }
  //load data from db
  void loadData(){
    workoutsList = _myBox.get("WORKOUTLIST").cast<Workout>();
    //print(workoutsList.toString());
  }
  void updateDatabase(){
    _myBox.put("WORKOUTLIST", workoutsList);
    //print(workoutsList.toString());

  }
  bool isDBEmpty(){
    return workoutsList.isEmpty;
  }
}