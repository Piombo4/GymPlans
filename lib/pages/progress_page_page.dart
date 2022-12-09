import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gymplans/classes/InputQtyModified.dart';
import 'package:gymplans/classes/database.dart';
import 'package:gymplans/pages/edit_workouts_page.dart';
import 'package:gymplans/classes/progress.dart';
import 'package:gymplans/classes/stopwatch.dart';
import 'package:gymplans/classes/workout.dart';
import 'package:hive/hive.dart';
import 'package:gymplans/models/model.dart';
import 'package:gymplans/classes/DateTextFormatter.dart';
import 'package:intl/intl.dart';
import '../classes/achievement.dart';
import 'create_workout_page.dart';
import '../classes/custom_page_route.dart';
import 'package:gymplans/pages/edit_workouts_page.dart';
import '../main.dart';

class progress_page extends StatefulWidget {
  const progress_page({Key? key}) : super(key: key);

  @override
  State<progress_page> createState() => _progress_pageState();
}

class _progress_pageState extends State<progress_page> {
  Progress p1 = Progress(30, 2, DateFormat("dd/MM/yyyy").parse("03/12/2001"));
  Progress p2 = Progress(35, 5, DateFormat("dd/MM/yyyy").parse("14/04/2001"));
  final ScrollController _scrollController = ScrollController();

  late Achievement a, b;
  List<Achievement> achievements = [];

  int counter = 0;
  int counter1 = 0;
  double weight = 0.0;
  int reps = 0;
  DateTime date = DateTime.now();

  late int dd, mm, yyyy;
  late TextEditingController dateController;
  late TextEditingController nameController;

  @override
  void initState() {
    List<Progress> ps = [p1, p2];
    a = Achievement("Bench Press", ps);
    b = Achievement("Chest Press", ps);
    achievements.add(a);
    achievements.add(b);
    super.initState();
    dateController = TextEditingController();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    dateController.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText("Progress"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        onPressed: () async {
          nameController.clear();
          await createAchievement();
        },
        heroTag: null,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0.0),
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: achievements.length,
            itemBuilder: achievement),
      ),
    );
  }

  Widget achievement(BuildContext context, int index) {
    counter++;
    return Dismissible(
      key: Key(counter.toString()),
      child: Card(
        child: ExpansionTile(
          key: PageStorageKey<Achievement>(achievements.elementAt(index)),
          title: Text(achievements[index].name),
          children: [
            ListView.builder(
              key: PageStorageKey('myList'),
              shrinkWrap: true,
              controller: _scrollController,
              physics: NeverScrollableScrollPhysics(),
              itemCount: achievements.elementAt(index).progress.length,
              itemBuilder: (context, index2) {
                counter1++;
                return Dismissible(
                    dragStartBehavior: DragStartBehavior.start,
                    key: Key(counter1.toString()),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "${DateFormat("dd-MM-yyyy").format(achievements.elementAt(index).progress[index2].date)}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Table(
                            columnWidths: {2: FlexColumnWidth(0.2)},
                            children: [
                              TableRow(children: [
                                Text(
                                    overflow: TextOverflow.ellipsis,
                                    "${achievements.elementAt(index).progress[index2].kgs} Kgs"),
                                Text(
                                    overflow: TextOverflow.ellipsis,
                                    "${achievements.elementAt(index).progress[index2].reps} Reps"),
                              ])
                            ],
                          ),
                          Divider(),
                        ],
                      ),
                    ),
                    onDismissed: (direction) {
                      setState(() {
                        achievements.elementAt(index).progress.removeAt(index2);
                      });
                    });
              },
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: OutlinedButton(
                  onPressed: () async {
                    dateController.clear();
                    weight = 0.0;
                    reps = 1;
                    await createProgress(index);
                  },
                  child: Icon(Icons.add),
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<CircleBorder>(
                          CircleBorder(
                              side: BorderSide(color: Colors.black87))))),
            )
          ],
        ),
      ),
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Confirm'),
                content: const Text("Delete achievement?"),
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
          achievements.removeAt(index);
        });
      },
    );
  }

  Widget progress(BuildContext context, int index) {
    return ListTile(
        subtitle: Card(
      child: Text("ciao"),
    ));
  }

  Future<Progress?> createProgress(int index) => showDialog<Progress>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title: const Text('New Progress', style: TextStyle(fontSize: 20)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                        hintText:
                            "${DateFormat("dd/MM/yyyy").format(DateTime.now())}"),
                    keyboardType: TextInputType.number,
                    controller: dateController,
                    inputFormatters: [
                      DateTextFormatter(),
                      FilteringTextInputFormatter.deny(
                          new RegExp('[\\ |\\, | \\, | \\- | \\.]'))
                    ],
                  ),
                  SizedBox(height: 20),
                  Table(
                    columnWidths: {2: FlexColumnWidth(0.2)},
                    children: [
                      TableRow(children: [
                        const Text("Kgs", style: TextStyle(fontSize: 18)),
                        InputQtyModified(
                          initVal: weight,
                          minVal: 0,
                          onQtyChanged: (val) {
                            weight = double.parse(val.toString());
                          },
                        ),
                      ]),
                      TableRow(children: [
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                      ]),
                      TableRow(children: [
                        const Text("Reps", style: TextStyle(fontSize: 18)),
                        InputQtyModified(
                          initVal: reps,
                          minVal: 0,
                          onQtyChanged: (val) {
                            if (val is int) {
                              reps = val;
                            }
                          },
                        ),
                      ]),
                      TableRow(children: [
                        SizedBox(height: 20),
                        SizedBox(height: 20),
                      ])
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: OutlinedButton(
                        onPressed: () {
                          submitProgress(index);
                        },
                        child: Icon(Icons.check_rounded),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(
                                    side: BorderSide(color: Colors.black87))))),
                  )
                ],
              ));
            }));
      });

  void submitProgress(int index) {
    Progress p;
    DateTime date = DateTime.now();

    if (!dateController.text.isEmpty) {
      List<String> tokens = dateController.text.split("/");
      if (int.parse(tokens[0]) > 31 ||
          int.parse(tokens[1]) > 12 ||
          dateController.text.length != 10) {
        return;
      }
      date = DateFormat("dd/MM/yyyy").parse(dateController.text);
      setState(() {
        weight = double.parse(weight.toStringAsFixed(2));
        p = new Progress(weight, reps, date);
        achievements[index].progress.add(p);
        achievements[index].progress.sort((a, b) => b.date.compareTo(a.date));
      });
    } else {
      setState(() {
        weight = double.parse(weight.toStringAsFixed(2));
        p = new Progress(weight, reps, date);
        achievements[index].progress.add(p);
        achievements[index].progress.sort((a, b) => b.date.compareTo(a.date));
      });
    }
    Navigator.of(context, rootNavigator: false).pop();
  }

  Future<Achievement?> createAchievement() => showDialog<Achievement>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0))),
            title:
                const Text('New Achievement', style: TextStyle(fontSize: 20)),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                  child: Column(
                children: [
                  TextField(
                    decoration: InputDecoration(hintText: "Achievement Name"),
                    controller: nameController,
                  ),
                  Padding(
                    padding: EdgeInsets.all(2),
                    child: OutlinedButton(
                        onPressed: () {
                          submitAchievement();
                        },
                        child: Icon(Icons.check_rounded),
                        style: ButtonStyle(
                            shape: MaterialStateProperty.all<CircleBorder>(
                                CircleBorder(
                                    side: BorderSide(color: Colors.black87))))),
                  )
                ],
              ));
            }));
      });
  void submitAchievement(){
    if(nameController.text.isEmpty)
      return;
    else{
      List<Progress> progress = [];
      Achievement a = Achievement(nameController.text, progress);
      setState(() {
        achievements.add(a);
        achievements.sort((a,b) => a.name.compareTo(b.name));
      });
    }
    Navigator.of(context, rootNavigator: false).pop();
  }
}
