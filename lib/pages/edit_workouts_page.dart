import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymplans/classes//exercise.dart';
import 'package:gymplans/classes/stopwatch.dart';
import 'package:gymplans/classes/workout.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:provider/provider.dart';
import 'package:gymplans/models/list_provider.dart';
import 'package:gymplans/models/model.dart';

import 'package:gymplans/classes/InputQtyModified.dart';
import 'package:gymplans/main.dart';

class editWorkoutsTemp extends StatefulWidget {
  const editWorkoutsTemp({super.key, required this.workout});

  final Workout workout;

  @override
  State<editWorkoutsTemp> createState() => _editWorkoutsTempState(w: workout);
}

class _editWorkoutsTempState extends State<editWorkoutsTemp> {
  Workout w;
  final myController = TextEditingController();
  List<Exercise> exercises = [];
  late TextEditingController _exerciseController;
  late TextEditingController _notesController;
  int sets = 0;
  int reps = 0;
  int rec = 0;
  int counter = 0;
  int m = 0, s = 0;
  int maxExercises = 100;
  String name = "";

  _editWorkoutsTempState({required this.w});

  @override
  void initState() {
    super.initState();
    exercises = w.exercises;
    _exerciseController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    myController.clear();
    _exerciseController.dispose();
    _notesController.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: TextField(
                controller: myController,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: w.name,
                    hintStyle: const TextStyle(color: Colors.black87)),
                cursorColor: Colors.black12,
                style: const TextStyle(fontSize: 20)),
            leading: const BackButton(),
            actions: [
              IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'New Exercise',
                  onPressed: () async {
                    _notesController.clear();
                    _exerciseController.clear();
                    sets = 0;
                    reps = 0;
                    await openDialog();

                  })
            ]),
        body: Column(children: <Widget>[
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),
          Expanded(
              child: ListView.builder(
                itemCount: exercises.length < maxExercises
                    ? exercises.length
                    : maxExercises,
                itemBuilder: exercise,
              ))
        ]),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(20),
            child: FloatingActionButton(
                elevation: 0,
                backgroundColor: myColor[600],
                heroTag: null,
                onPressed: () {
                  _sendDataBack(context);
                },
                child: const Icon(Icons.check))));
  }

  void _sendDataBack(BuildContext context) {
    Workout tempW = Workout(myController.text, exercises);
    if (tempW != null && myController.text.isNotEmpty) {
      Navigator.pop(context, tempW);
    } else {
      Navigator.pop(context, Workout(w.name, exercises));
    }
  }

  Future<void> openDialog() => showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: const Text('New Exercise', style: TextStyle(fontSize: 20)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          autofocus: true,
                          controller: _exerciseController,
                          decoration: const InputDecoration(
                            hintText: 'Exercise name ',
                            hintStyle: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Table(
                            columnWidths: {2: FlexColumnWidth(0.2)},
                            children: [
                              TableRow(children: [
                                const Text(
                                  'Sets',
                                  style: TextStyle(fontSize: 18),
                                ),
                                InputQtyModified(
                                  initVal: sets,
                                  minVal: 0,
                                  onQtyChanged: (val) {
                                    sets = val as int;
                                  },
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                              ]),
                              TableRow(children: [
                                SizedBox(height: 10,),
                                SizedBox(height: 10,),
                                SizedBox(height: 10,),
                              ]),
                              TableRow(children: [
                                const Text(
                                  'Reps',
                                  style: TextStyle(fontSize: 18),
                                ),
                                InputQtyModified(
                                  initVal: reps,
                                  minVal: 0,
                                  onQtyChanged: (val) {
                                    reps = val as int;
                                  },

                                ),
                                SizedBox(width: MediaQuery.of(context).size.width * 0.2),
                              ]),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Text(
                                'Rest',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.10,
                              ),
                              Flexible(
                                  child: NumberPicker(
                                      zeroPad: true,
                                      infiniteLoop: true,
                                      minValue: 0,
                                      maxValue: 59,
                                      value: m,
                                      onChanged: (value) =>
                                          setState(() => m = value))),
                              Flexible(
                                  child: NumberPicker(
                                      zeroPad: true,
                                      infiniteLoop: true,
                                      minValue: 0,
                                      maxValue: 59,
                                      value: s,
                                      onChanged: (value) =>
                                          setState(() => s = value)))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _notesController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Add Notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                                elevation: 0,
                                heroTag: null,
                                onPressed: () {
                                  submitCreateExercise(sets, reps);
                                },
                                child: const Icon(Icons.check)),
                          ),
                        )
                      ],
                    ),
                  );
                }));
      });

  void submitCreateExercise(int sets, int reps) {
    if (exercises.length >= maxExercises) return;
    Exercise e = Exercise(_exerciseController.text,_notesController.text.trim(),sets,reps,s,m);
    setState(() {
      exercises.add(e);
    });
    Navigator.of(context, rootNavigator: false).pop();
    s = 0;
    m = 0;
    _exerciseController.clear();
    _notesController.clear();
  }

  Widget exercise(BuildContext context, int index) {
    counter++;
    return Dismissible(
      key: Key(counter.toString()),
      child: ListTile(
          onTap: () async {
            await editExercise(index);
          },
          visualDensity: const VisualDensity(horizontal: 0, vertical: -3),
          subtitle: Column(
            children: [
              Align(
                  alignment: Alignment.topLeft,
                  child: RichText(
                    text: TextSpan(children: [
                      WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: Colors.amber,
                          )),
                      TextSpan(
                          text:
                          " \t${exercises.elementAt(index).name}: \t${exercises.elementAt(index).sets}x${exercises.elementAt(index).reps}     ",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                          )),
                      WidgetSpan(
                          alignment: PlaceholderAlignment.bottom,
                          child: Icon(
                            Icons.timer_outlined,
                            size: 28,
                            color: Colors.amber,
                          )),
                      TextSpan(
                          text:
                          " ${exercises.elementAt(index).min}'${exercises.elementAt(index).sec}''",
                          style: const TextStyle(
                            fontSize: 22,
                            color: Colors.black87,
                          ))
                    ]),
                  )),
              Align(
                alignment: Alignment.topLeft,
                child: Text(exercises.elementAt(index).notes,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black45,
                    )),
              )
            ],
          )),
      onDismissed: (direction) {
        setState(() {
          exercises.removeAt(index);
        });
      },
    );
  }

  Future<void> editExercise(int index) => showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: const Text('Edit Exercise', style: TextStyle(fontSize: 20)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(30),
                          ],
                          controller: _exerciseController,
                          decoration: InputDecoration(
                              hintText: exercises.elementAt(index).name,
                              hintStyle: const TextStyle(fontSize: 18)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Text(
                                'Sets',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.14,
                              ),
                              SizedBox(
                                width: 50,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (exercises.elementAt(index).sets >
                                          0) {
                                        exercises.elementAt(index).sets--;
                                      }
                                    });
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${exercises.elementAt(index).sets}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      exercises.elementAt(index).sets++;
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Text(
                                'Reps',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.12,
                              ),
                              SizedBox(
                                width: 50,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      if (exercises.elementAt(index).reps > 0) exercises.elementAt(index).reps--;
                                    });
                                  },
                                  child: const Icon(Icons.remove),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                '${exercises.elementAt(index).reps}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                width: 50,
                                child: RawMaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      exercises.elementAt(index).reps++;
                                    });
                                  },
                                  child: const Icon(Icons.add),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Row(
                            children: [
                              const Text(
                                'Rest',
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.10,
                              ),
                              Flexible(
                                  child: NumberPicker(
                                      infiniteLoop: true,
                                      zeroPad: true,
                                      minValue: 0,
                                      maxValue: 59,
                                      value: exercises.elementAt(index).min,
                                      onChanged: (value) =>
                                          setState(() =>exercises.elementAt(index).min=value))),
                              Flexible(
                                  child: NumberPicker(
                                      zeroPad: true,
                                      infiniteLoop: true,
                                      minValue: 0,
                                      maxValue: 59,
                                      value: exercises.elementAt(index).sec,
                                      onChanged: (value) =>
                                          setState(() => exercises.elementAt(index).sec=value))),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextField(
                          controller: _notesController,
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(100),
                          ],
                          decoration: const InputDecoration(
                            hintText: 'Add Notes',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: FloatingActionButton(
                                heroTag: null,
                                elevation: 0,
                                onPressed: () {
                                  submitEditExercise(index);
                                },
                                child: const Icon(Icons.check)),
                          ),
                        )
                      ],
                    ),
                  );
                }));
      });
  void submitEditExercise(int index) {
    setState(() {
      if (_notesController.text.isNotEmpty) {
        exercises.elementAt(index).notes = _notesController.text.trim();
      }
      if (_exerciseController.text.isNotEmpty) {
        exercises.elementAt(index).name=_exerciseController.text.trim();
      }
    });
    Navigator.of(context, rootNavigator: false).pop();
    s = 0;
    m = 0;
    _exerciseController.clear();
    _notesController.clear();

  }
}
