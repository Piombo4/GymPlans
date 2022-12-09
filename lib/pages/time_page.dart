import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:gymplans/classes/database.dart';
import 'package:gymplans/pages/edit_workouts_page.dart';
import 'package:gymplans/classes/stopwatch.dart';
import 'package:gymplans/classes/timer.dart';
import 'package:gymplans/classes/workout.dart';
import 'package:hive/hive.dart';
import 'package:gymplans/models/model.dart';

import 'create_workout_page.dart';
import '../classes/custom_page_route.dart';
import 'package:gymplans/pages/edit_workouts_page.dart';
import '../main.dart';

class time_page extends StatefulWidget {
  const time_page({Key? key}) : super(key: key);

  @override
  State<time_page> createState() => _time_pageState();
}

class _time_pageState extends State<time_page> with TickerProviderStateMixin {
  late TabController _tabController;
  late int _selectedTab;

  @override
  void initState() {
    _selectedTab = 0;
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  TabBar get _tabBar => TabBar(
        onTap: (index) {
          _selectedTab = index;
          setState((){});
        },
        unselectedLabelColor: Colors.black45,
        controller: _tabController,
        labelColor: myColor[900],
        tabs: [
          Tab(icon: Icon(Icons.timer_outlined,size: _selectedTab==0 ? 32:28,)),
          Tab(icon: Icon(Icons.hourglass_empty_rounded,size: _selectedTab==1 ? 32:28))
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          bottom: PreferredSize(
            preferredSize: _tabBar.preferredSize,
            child: ColoredBox(
              color: Colors.white,
              child: _tabBar,
            ),
          )),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          stopwatch(),
          timer(),
        ],
      ),
    );
  }
}
