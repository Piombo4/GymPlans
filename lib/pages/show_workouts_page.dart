import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymplans/classes/database.dart';
import 'package:gymplans/pages/edit_workouts_page.dart';
import 'package:gymplans/classes/stopwatch.dart';
import 'package:gymplans/classes/workout.dart';
import 'package:hive/hive.dart';
import 'package:gymplans/models/model.dart';

import 'create_workout_page.dart';
import '../classes/custom_page_route.dart';
import 'package:gymplans/pages/edit_workouts_page.dart';
import '../main.dart';

class showWorkouts extends StatefulWidget {
  const showWorkouts({Key? key}) : super(key: key);

  @override
  State<showWorkouts> createState() => _showWorkoutsState();
}

class _showWorkoutsState extends State<showWorkouts> {
  final _myBox = Hive.box('myBox');
  late Workout? tempW;
  int _selectedIndex = 0;
  TextEditingController _controller = TextEditingController();
  int counter = 0;

  WorkoutDatabase wdb = WorkoutDatabase();

  @override
  void initState() {
    //if first time ever opening app => create default data
    if (_myBox.get("WORKOUTLIST") == null) {
      wdb.createInitialData();
    } else {
      //data already exists
      wdb.loadData();
    }
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AutoSizeText('GymPlans'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          _awaitFromWorkoutCreation(context);
        },
        heroTag: null,
        tooltip: 'New Workout',
        child: const Icon(Icons.add),
      ),
      body: Visibility(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min,children: [
            AutoSizeText("Workout list empty",
                style: TextStyle(
                  fontSize: 27,
                  color: Colors.grey[400],
                )),
            Icon(Icons.fitness_center_rounded,size: 60,color: Colors.grey[400],)
          ],),
        ),
        visible: wdb.isDBEmpty(),
        replacement: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8),
              child: Container(),
            ),
            //Consumer<ListProvider>(builder: (context, provider, listTile) {}
            Expanded(
              child: ListView.builder(
                itemCount: wdb.workoutsList.length,
                itemBuilder: buildList,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    counter++;
    return Dismissible(
        key: Key(counter.toString()),
        direction: DismissDirection.startToEnd,
        confirmDismiss: (DismissDirection direction) async {
          return await showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm'),
                  content: const Text("Delete workout?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      child: const Text("CANCEL"),
                    ),
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text("DELETE"))
                  ],
                );
              });
        },
        onDismissed: (direction) {
          setState(() {
            if (wdb.workoutsList.elementAt(index) != null) {
              wdb.workoutsList.removeAt(index);
            }
          });
          wdb.updateDatabase();
        },
        child: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: myColor[50],
              border: Border.all(
                color: myColor,
                width: 2,
              ),
              borderRadius: BorderRadius.circular(15)),
          child: ListTile(
            onTap: () {
              setState(() {
                _awaitFromWorkoutEdit(context, index);
              });
            },
            visualDensity: const VisualDensity(horizontal: 0, vertical: -2),
            title: Text(wdb.workoutsList[index].name,
                style: const TextStyle(color: Colors.black)),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ));
  }

  void _awaitFromWorkoutCreation(BuildContext context) async {
    // start the SecondScreen and wait for it to finish with a result
    /*tempW = await Navigator.push(
        context,
        CustomPageRoute(
          builder: (context) => createWorkout(),
        ));*/
    tempW = await Navigator.push(context,scaleIn(create_workout()));
    if (tempW == null) return;

    setState(() {
      if (tempW != null) {
        wdb.workoutsList.add(tempW!);
        //taskItems.addItem(tempW!.name);
      }
    });

    wdb.updateDatabase();
  }
  Route<Workout> scaleIn(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 100),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, page) {
        return new FadeTransition(opacity: animation, child: page);
      },
    );
  }
  void _awaitFromWorkoutEdit(BuildContext context, int index) async {
    // start the SecondScreen and wait for it to finish with a result
    tempW = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              editWorkoutsTemp(workout: wdb.workoutsList.elementAt(index)),
        ));
    if (tempW == null) return;
    // after the SecondScreen result comes back update the Text widget with it
    setState(() {
      if (tempW != null) {
        //taskItems.addItem(tempW!.name);
        wdb.workoutsList[index] = tempW!;
      }
    });
    wdb.updateDatabase();
  }
}
